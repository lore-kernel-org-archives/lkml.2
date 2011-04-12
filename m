Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab1DLTT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:19:56 -0400
Received: from void.printf.net ([89.145.121.20]:49524 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab1DLTTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:19:55 -0400
From: Chris Ball <cjb@laptop.org>
To: Cyril Hrubis <metan@ucw.cz>
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org, marek.vasut@gmail.com,
        linux-mmc@vger.kernel.org
Subject: Re: zaurus: mmcblk0: error -110
References: <20110412151547.GC20815@atrey.karlin.mff.cuni.cz>
Date: Tue, 12 Apr 2011 15:24:34 -0400
In-Reply-To: <20110412151547.GC20815@atrey.karlin.mff.cuni.cz> (Cyril Hrubis's
	message of "Tue, 12 Apr 2011 17:15:48 +0200")
Message-ID: <m3aafvz30t.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(Adding linux-mmc@.)

On Tue, Apr 12 2011, Cyril Hrubis wrote:
> Hi!
> When I insert the mmc card to zaurus, it gets properly detected and prints some
> info into console. Mounting reading/writing files works fine.
>
> However when the card is removed (doesn't need to be mounted before), the
> removal is most likely not detected, so when I insert it again, no info is
> printed into console and moreover when I try to mount it zaurus goes into
> infinite loop printing:
>
> Buffer I/O error on device mmcblk0p1, logical block 9
> mmcblk0: error -110 sending status command
> mmcblk0: error -110 sending read/write command, response 0xb00, card status 0xb00
> end_request: I/O error, dev mmcblk0, sector 257
> Buffer I/O error on device mmcblk0p1, logical block 10
> ...
>
> Related part of the .config:
>
> #
> # OTG and related infrastructure
> #
> # CONFIG_USB_GPIO_VBUS is not set
> # CONFIG_USB_ULPI is not set
> # CONFIG_NOP_USB_XCEIV is not set
> CONFIG_MMC=y
> # CONFIG_MMC_DEBUG is not set
> CONFIG_MMC_UNSAFE_RESUME=y

Your symptoms match the bug that was fixed by:

bad3babace2ee4d ("mmc: fix CONFIG_MMC_UNSAFE_RESUME regression")

but this fix made it into 2.6.38, so if you're using 2.6.38 final then
you shouldn't be seeing this.  Could you confirm that you have this
patch?

If so, could you try building a kernel with CONFIG_MMC_UNSAFE_RESUME=n
and see if you still have the same problem?

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
