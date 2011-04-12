Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab1DLVQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 17:16:32 -0400
Received: from void.printf.net ([89.145.121.20]:32944 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503Ab1DLVQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 17:16:30 -0400
From: Chris Ball <cjb@laptop.org>
To: Cyril Hrubis <metan@ucw.cz>
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org, marek.vasut@gmail.com,
        linux-mmc@vger.kernel.org
Subject: Re: zaurus: mmcblk0: error -110
References: <20110412151547.GC20815@atrey.karlin.mff.cuni.cz>
	<m3aafvz30t.fsf@pullcord.laptop.org>
	<20110412193944.GC2665@atrey.karlin.mff.cuni.cz>
	<m3oc4bxne1.fsf@pullcord.laptop.org>
	<20110412205421.GD2665@atrey.karlin.mff.cuni.cz>
Date: Tue, 12 Apr 2011 17:21:15 -0400
In-Reply-To: <20110412205421.GD2665@atrey.karlin.mff.cuni.cz> (Cyril Hrubis's
	message of "Tue, 12 Apr 2011 22:54:21 +0200")
Message-ID: <m3fwpnxj1w.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 12 2011, Cyril Hrubis wrote:
> Tried 2.6.39-rc3 both with and without CONFIG_MMC_UNSAFE_RESUME and the
> insert/remove detection works but both with and without unsafe resume, if the
> card is removed for more than second or two it fails to recognize the card
> after insertion failing with:
>
> mmc0: error -95 whilst initialising SD card

That's interesting.  Would you mind trying to bisect?  (Knowing whether
2.6.38 final does it, for example, would be very helpful.)

There aren't many -EOPNOTSUPP returns in the stack.  I see:

card/block.c: mmc_blk_issue_secdiscard_rq and mmc_blk_issue_discard_rq
card/core.c: mmc_erase
core/sd_ops.c: mmc_app_cmd

Mind doing some instrumentation to figure out which it is?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
