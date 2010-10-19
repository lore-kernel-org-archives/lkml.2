Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab0JSXoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 19:44:21 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:65083 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab0JSXoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 19:44:19 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/YKXXalmN/63AsldxugMzl
Date: Tue, 19 Oct 2010 16:44:14 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Felipe Balbi <me@felipebalbi.com>, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
Message-ID: <20101019234414.GB30991@atomide.com>
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
 <1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>
 <20101019103234.GI31170@legolas.emea.dhcp.ti.com>
 <AANLkTinXzMQXoyyu+anSCvSuE9w3FWAP5HswDS0kfpzE@mail.gmail.com>
 <20101019111613.GJ31170@legolas.emea.dhcp.ti.com>
 <AANLkTikkMphKa2DGGtWxy-3LpFX0kn92UEYPj==Euzok@mail.gmail.com>
 <20101019115236.GL31170@legolas.emea.dhcp.ti.com>
 <AANLkTim3NsgjC3Nh8VCCrx4cV1Y+kn38=30=en0KCft6@mail.gmail.com>
 <6ea089ac75d4d15d88698468eacb7fe3@secure211.sgcpanel.com>
 <AANLkTinYM5aavk9_jcTTymff=OY+Yyv8T6C+dmMih0p_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinYM5aavk9_jcTTymff=OY+Yyv8T6C+dmMih0p_@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Contreras <felipe.contreras@gmail.com> [101019 13:43]:
> On Tue, Oct 19, 2010 at 6:05 PM, Felipe Balbi <me@felipebalbi.com> wrote:
> > On Tue, 19 Oct 2010 17:32:07 +0300, Felipe Contreras
> > <felipe.contreras@gmail.com> wrote:
> >> There are two parts, one part is to fix the Kconfigs, and another was
> >> to come up with a way to replace the horrible defconfigs. Part two is
> >> mostly fixed thanks to 'make savedefconfig', since the defconfigs are
> >> not so horrible any more, but part one is a continued effort.
> >>
> >> For part two Linus had the idea to use Kconfigs instead of defconfigs,
> >> but they would mostly look very similar to the current ones generated
> >> by 'make savedefconfig'.
> >>
> >> I don't know what makes you think Linus didn't want part one to be
> >> done. He wanted the Kconfig.rx51 to be human readable, and you are
> >> proposing that TWL4030_USB should be manually added there... I don't
> >> think TWL4030_USB says anything to human beings.
> >
> > I don't read anywhere Linus saying we should clutter drivers/*/Kconfig
> > with defaults. I think you're inverting things, it's much better
> > to select TWL4030_USB when you enable MACH_OMAP_RX51 then default y
> > if MACH_OMAP_RX51.
> 
> So say, if you have 100 board defconfigs with OMAP3 chips and TWL4030,
> each and every one of them should select both USB_MUSB_HDRC and
> TWL4030_USB?
> 
> And you are saying if somebody is doing 'make menuconfig', that person
> should somehow know that _obviously_ he needs TWL4030_USB in order to
> use USB_MUSB_HDRC, or USB_G_NOKIA?

Hey we're already dealing with stuff like this :)

See ARCH_OMAP2PLUS_TYPICAL in arch/arm/mach-omap2/Kconfig:

config ARCH_OMAP2PLUS_TYPICAL
        bool "Typical OMAP configuration"
        default y
        select AEABI
        select REGULATOR
        select PM
        select PM_RUNTIME
        select VFP
        select NEON if ARCH_OMAP3 || ARCH_OMAP4
        select SERIAL_OMAP
        select SERIAL_OMAP_CONSOLE
        select I2C
        select I2C_OMAP
        select MFD
        select MENELAUS if ARCH_OMAP2
        select TWL4030_CORE if ARCH_OMAP3 || ARCH_OMAP4
        select TWL4030_POWER if ARCH_OMAP3 || ARCH_OMAP4
        help
          Compile a kernel suitable for booting most boards

This actually produces a booting omap2+ kernel with no .config
at all. I've tested it with:

$ echo CONFIG_ARCH_OMAP=y > .config
$ yes "" | ARCH=arm make oldconfig

So if you have something that's needed on almost every omap,
you can select it there.

Regards,

Tony
