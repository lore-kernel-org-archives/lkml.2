Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab1JCLD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 07:03:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55103 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab1JCLDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 07:03:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 23/30] ARM: omap2: select twl4030 support on boards that need it
Date: Mon, 03 Oct 2011 13:03:48 +0200
Message-ID: <8140311.pfrshFtPLz@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <4E8945CE.6070800@ti.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-24-git-send-email-arnd@arndb.de> <4E8945CE.6070800@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:6rvbRjrbJwUBRnVk3ST7iCBGqYN6VHVwmqFuNIbtfd9
 3f6Uls0Y0g3hxmMvy0xqE1DmefEC8b5QFiXF4FYDoIhKqqqkAm
 e9HRUaeX+LnABZS4HkVBCNh8Kewcf4OlM5XByXYOblQFwGE8KY
 po5db5rZL4eVAbLp81t2ffOYVepqyynx2ciS8jf59ZD4VAdY43
 4UYduN4+mQxnAB+kJTPYqiHmnB2rqBGytyxvpONDNtgb1Ihd5t
 Q+OvicfHz28Djgd4ALdQo8FPSQ4RdruU0R13LnHddLUwTw9h90
 klLo6wGcpxit/BEN7lrFpc5Ss6CYYMOdODP62AWob3BkbbmI9D
 QYRrS9eGyXdDV1O2x21Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 October 2011 10:49:10 Santosh Shilimkar wrote:
> > diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> > index 57b66d5..4deeade 100644
> > --- a/arch/arm/mach-omap2/Kconfig
> > +++ b/arch/arm/mach-omap2/Kconfig
> > @@ -253,6 +253,8 @@ config MACH_OMAP_ZOOM2
> >       select SERIAL_CORE_CONSOLE
> >       select SERIAL_8250_CONSOLE
> >       select REGULATOR_FIXED_VOLTAGE
> > +     select TWL4030_CORE
> > +     select I2C
> >  
> Another option to ensure I2C is selected when
> TWL* drivers are selected is let it depends
> on I2C. That wat we can avoid patching every
> machine entry with I2C option.
> Not a strong opinion though.

I generally try to avoid having select statements where a
depends on works fine, as in the generic TWL4030_CORE config.

For platforms that require TWL4030, this does not work, although
it would be better not to have this strict dependency and make
the configuration build if the driver is disabled, even if that
is rather pointless.

	Arnd
