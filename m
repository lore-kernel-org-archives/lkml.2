Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab1DLWnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 18:43:37 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34767 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753277Ab1DLWnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 18:43:35 -0400
Date: Wed, 13 Apr 2011 00:43:33 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: Chris Ball <cjb@laptop.org>
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org, marek.vasut@gmail.com,
        linux-mmc@vger.kernel.org
Subject: Re: zaurus: mmcblk0: error -110
Message-ID: <20110412224333.GA22640@atrey.karlin.mff.cuni.cz>
References: <20110412151547.GC20815@atrey.karlin.mff.cuni.cz> <m3aafvz30t.fsf@pullcord.laptop.org> <20110412193944.GC2665@atrey.karlin.mff.cuni.cz> <m3oc4bxne1.fsf@pullcord.laptop.org> <20110412205421.GD2665@atrey.karlin.mff.cuni.cz> <m3fwpnxj1w.fsf@pullcord.laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3fwpnxj1w.fsf@pullcord.laptop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > Tried 2.6.39-rc3 both with and without CONFIG_MMC_UNSAFE_RESUME and the
> > insert/remove detection works but both with and without unsafe resume, if the
> > card is removed for more than second or two it fails to recognize the card
> > after insertion failing with:
> >
> > mmc0: error -95 whilst initialising SD card
> 
> That's interesting.  Would you mind trying to bisect?  (Knowing whether
> 2.6.38 final does it, for example, would be very helpful.)

It may need one or two tries on 2.6.38 but it's there too.

> There aren't many -EOPNOTSUPP returns in the stack.  I see:
> 
> card/block.c: mmc_blk_issue_secdiscard_rq and mmc_blk_issue_discard_rq
> card/core.c: mmc_erase
> core/sd_ops.c: mmc_app_cmd
> 
> Mind doing some instrumentation to figure out which it is?

Fails in the mmc_app_cmd.

-- 
metan
