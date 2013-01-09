Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab3AILIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:08:48 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38104 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab3AILIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:08:46 -0500
Date: Wed, 9 Jan 2013 11:08:40 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 2/3] ARM: ux500: Turn on the 'heartbeat' LED trigger
Message-ID: <20130109110840.GD31678@gmail.com>
References: <1357725965-27342-1-git-send-email-lee.jones@linaro.org>
 <1357725965-27342-2-git-send-email-lee.jones@linaro.org>
 <201301091018.55058.arnd@arndb.de>
 <20130109103510.GE3931@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130109103510.GE3931@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jan 2013, Russell King - ARM Linux wrote:

> On Wed, Jan 09, 2013 at 10:18:54AM +0000, Arnd Bergmann wrote:
> > On Wednesday 09 January 2013, Lee Jones wrote:
> > > diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
> > > index 5dea906..0f25b07 100644
> > > --- a/arch/arm/mach-ux500/Kconfig
> > > +++ b/arch/arm/mach-ux500/Kconfig
> > > @@ -43,6 +43,8 @@ config MACH_HREFV60
> > >  config MACH_SNOWBALL
> > >         bool "U8500 Snowball platform"
> > >         select MACH_MOP500
> > > +       select LEDS_TRIGGERS
> > > +       select LEDS_TRIGGER_HEARTBEAT
> > >         help
> > >           Include support for the snowball development platform.
> > 
> > Be careful with "select" statements like this when there are other
> > dependencies. I think LEDS_TRIGGERS depends on LEDS_CLASS, so this
> > should probably be written as
> > 
> > 	select LEDS_TRIGGERS if LEDS_CLASS
> 
> Umm, this is also wrong for another reason.  LEDS is an optional feature.
> It's not required for the platform to be functional.  So why the hell would
> anyone want to _force_ such an optional feature to be mandatory?
> 
> This is something that the default config published for the platform should
> be handling.

Do you mean <config_dir>/u8500_defconfig?

If so, that's wrong, as it covers many more boards than just Snowball
and this is only applicable on the Snowball board. So how else can
I enable this feature?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
