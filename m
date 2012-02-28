Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab2B1RLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:11:41 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45652 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab2B1RLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:11:40 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 28 Feb 2012 18:11:32 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [SCSI] sr: fix multi-drive performance, remove BKL
 replacement
Message-ID: <20120228181132.13f1088c@stein>
In-Reply-To: <1330448257.2822.138.camel@dabdike.int.hansenpartnership.com>
References: <20120228153244.70413d34@stein>
	<20120228170930.132f7c1e@stein>
	<1330445795.2822.134.camel@dabdike.int.hansenpartnership.com>
	<201202281642.16496.arnd@arndb.de>
	<1330448257.2822.138.camel@dabdike.int.hansenpartnership.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 28 James Bottomley wrote:
> On Tue, 2012-02-28 at 16:42 +0000, Arnd Bergmann wrote:
> > I took another look and I believe the cdi->use_count in
> > cdrom_open/cdrom_release still requires some protection that is
> > currently provided by sr_mutex.
> 
> So I think this is fine ... it's protected by the bdev->bd_mutex.
> 
> >  Some parts of cdrom_ioctl also
> > access this variable and things like cdi->options or cdi->keeplocked.
> 
> This would be problematic because we no longer lock the ioctl.
> 
> > I could imagine that you can get rid of the mutex if you turn those
> > into atomics and bitops, but there may be other parts of cdrom_device_info
> > that need locking. A safer option to solve the performance problems
> > could be to replace sr_mutex with a per-device mutex inside of
> > cdrom_device_info.
> 
> I'd say the latter.

Thanks Arnd and James, I will pursue this when I get the time.
-- 
Stefan Richter
-=====-===-- --=- ===--
http://arcgraph.de/sr/
