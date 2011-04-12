Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab1DLTjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:39:47 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:46569 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756788Ab1DLTjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:39:45 -0400
Date: Tue, 12 Apr 2011 21:39:44 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: Chris Ball <cjb@laptop.org>
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org, marek.vasut@gmail.com,
        linux-mmc@vger.kernel.org
Subject: Re: zaurus: mmcblk0: error -110
Message-ID: <20110412193944.GC2665@atrey.karlin.mff.cuni.cz>
References: <20110412151547.GC20815@atrey.karlin.mff.cuni.cz> <m3aafvz30t.fsf@pullcord.laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3aafvz30t.fsf@pullcord.laptop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > When I insert the mmc card to zaurus, it gets properly detected and prints some
> > info into console. Mounting reading/writing files works fine.
> >
> > However when the card is removed (doesn't need to be mounted before), the
> > removal is most likely not detected, so when I insert it again, no info is
> > printed into console and moreover when I try to mount it zaurus goes into
> > infinite loop printing:
> >
> > Buffer I/O error on device mmcblk0p1, logical block 9
> > mmcblk0: error -110 sending status command
> > mmcblk0: error -110 sending read/write command, response 0xb00, card status 0xb00
> > end_request: I/O error, dev mmcblk0, sector 257
> > Buffer I/O error on device mmcblk0p1, logical block 10
> > ...
> >
> > Related part of the .config:
> >
> > #
> > # OTG and related infrastructure
> > #
> > # CONFIG_USB_GPIO_VBUS is not set
> > # CONFIG_USB_ULPI is not set
> > # CONFIG_NOP_USB_XCEIV is not set
> > CONFIG_MMC=y
> > # CONFIG_MMC_DEBUG is not set
> > CONFIG_MMC_UNSAFE_RESUME=y
> 
> Your symptoms match the bug that was fixed by:
> 
> bad3babace2ee4d ("mmc: fix CONFIG_MMC_UNSAFE_RESUME regression")
> 
> but this fix made it into 2.6.38, so if you're using 2.6.38 final then
> you shouldn't be seeing this.  Could you confirm that you have this
> patch?

It seems that the pxa tree I have is still based on 2.6.38-rc8.

And yes, turning CONFIG_MMC_UNSAFE_RESUME off seems to fix that problem.

I'll try to update the kernel tree and try again with CONFIG_MMC_UNSAFE_RESUME
enabled.

-- 
metan
