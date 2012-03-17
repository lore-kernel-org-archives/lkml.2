Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab2CQMse (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 08:48:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56552 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab2CQMsb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 08:48:31 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 17 Mar 2012 13:47:56 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Wakko Warner <wakko@animx.eu.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: Burning multiple DVDs at one time
Message-ID: <20120317134756.7a9ea99c@stein>
In-Reply-To: <20120317115324.10b39bb7@galadriel.home>
References: <20120315225310.GB3152@animx.eu.org>
	<20120317095644.145d0588@stein>
	<20120317115324.10b39bb7@galadriel.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 17 Emmanuel Florac wrote:
> Le Sat, 17 Mar 2012 09:56:44 +0100 vous écriviez:
> 
> > This is likely due to serialization by a global mutex in the sr
> > driver. Have a look at thread "[PATCH] [SCSI] sr: fix multi-drive
> > performance, remove BKL replacement" from February.
> > https://lkml.org/lkml/2012/2/28/230 
> 
> When was this regression introduced? I have a dedicated cd burning
> machine running 2.6.35.x, and it works great with 4 drives at a time.

BKL was replaced by sr_mutex in 2.6.37-rc1.

Wakko, you could try the patch from the mentioned thread and see whether
it fixes your problem.  But be aware that the patch opens possible race
conditions between processes that access the same optical drive, e.g.
applications vs. udisks-daemon.  (I haven't noticed anything bad during the
period of using the patch though.)
-- 
Stefan Richter
-=====-===-- --== =---=
http://arcgraph.de/sr/
