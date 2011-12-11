Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab1LKXVX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 18:21:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab1LKXVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 18:21:22 -0500
Date: Mon, 12 Dec 2011 00:21:16 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next bad Kconfig for drivers/hid
In-Reply-To: <4EE19DA0.5010705@goop.org>
Message-ID: <alpine.LNX.2.00.1112120020330.21970@pobox.suse.cz>
References: <20111209012746.GC20353@thor.bakeyournoodle.com> <4EE19DA0.5010705@goop.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Dec 2011, Jeremy Fitzhardinge wrote:

> > Commit 4f5ca836bef3 (HID: hid-input: add support for HID devices
> > reporting Battery Strength) went into linux-next on Dec 1st since then a
> > ppc6xx_defconfig has been failing with:
> >
> > ---
> > drivers/built-in.o: In function `hidinput_cleanup_battery':
> > /scratch/tony/working/drivers/hid/hid-input.c:351: undefined reference to `power_supply_unregister'
> > drivers/built-in.o: In function `hidinput_setup_battery':
> > /scratch/tony/working/drivers/hid/hid-input.c:338: undefined reference to `power_supply_register'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > ---
> >
> > http://kisskb.ellerman.id.au/kisskb/buildresult/5012563/
> > vs
> > http://kisskb.ellerman.id.au/kisskb/buildresult/5017366/
> >
> > The defconfig in question doens't mention either option
> > (CONFIG_POWER_SUPPLY or CONFIG_HID_BATTERY_STRENGTH) and kbuild is
> > genertaing
> > CONFIG_HID_BATTERY_STRENGTH=y
> > CONFIG_POWER_SUPPLY=m
> > which clearly isn't going to work.
> >
> > The following change to HID_BATTERY_STRENGTH Kconfig "works" but seems a
> > little gross.
> >
> > diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> > index 5ed64f6..d2a94e6 100644
> > --- a/drivers/hid/Kconfig
> > +++ b/drivers/hid/Kconfig
> > @@ -33,7 +33,7 @@ config HID
> >  
> >  config HID_BATTERY_STRENGTH
> >         bool
> > -       depends on POWER_SUPPLY
> > +       depends on POWER_SUPPLY=y
> >         default y
> >  
> >  config HIDRAW
> >
> > Any chance we can get a fix into linux-next?
> 
> Hm.  How about making it "depends on HID && POWER_SUPPLY"?  I think that
> would needlessly disable it if HID is also modular, but I'm not sure how
> to fix that.  "depends on HID && POWER_SUPPLY && HID == POWER_SUPPLY"?

How about making it 'default POWER_SUPPLY' instead?

I somehow feel that we'd rather avoid too much 'default y's.

Thanks,

-- 
Jiri Kosina
SUSE Labs
