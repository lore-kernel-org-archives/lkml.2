Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab0IXNxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:53:09 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35087 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300Ab0IXNxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:53:07 -0400
Message-ID: <4C9CAD27.1030705@kernel.dk>
Date: Fri, 24 Sep 2010 15:52:39 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: dgilbert@interlog.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Joel Becker <joel.becker@oracle.com>
Subject: Re: [PATCH] block: Prevent hang_check firing during long I/O
References: <4C9BE5A8.1090002@teksavvy.com> <4C9BEB49.2060208@interlog.com>	 <4C9C129E.5050504@teksavvy.com> <4C9C2039.8050903@teksavvy.com>	 <4C9C6B7D.1060805@kernel.dk> <1285336273.9259.2.camel@corey>
In-Reply-To: <1285336273.9259.2.camel@corey>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-24 15:51, Mark Lord wrote:
> During long I/O operations, the hang_check timer may fire,
> trigger stack dumps that unnecessarily alarm the user.
> 
> Eg.  hdparm --security-erase NULL /dev/sdb  ## can take *hours* to complete
> 
> So, if hang_check is armed, we should wake up periodically
> to prevent it from triggering.  This patch uses a wake-up interval
> equal to half the hang_check timer period, which keeps overhead low enough.

Applied, thanks.

-- 
Jens Axboe

