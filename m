Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab1E3VEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 17:04:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61892 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab1E3VEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 17:04:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Date: Mon, 30 May 2011 23:04:46 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Randy Dunlap <rdunlap@xenotime.net>, David Woodhouse <dwmw2@infradead.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <1306707270.2029.377.camel@i7.infradead.org> <201105302040.55509.arnd@arndb.de> <BANLkTik36rFNDqAorY9gn2_mDPMmP_Y=iw@mail.gmail.com>
In-Reply-To: <BANLkTik36rFNDqAorY9gn2_mDPMmP_Y=iw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105302304.47100.arnd@arndb.de>
X-Provags-ID: V02:K0:gEHCKgYDO9wtSf75rZO+QRfvzKua3mZED7yQ37+pTBH
 5KyZZA2RSauVg6FdD/5l9uhpp+ixzicK4lS9dJVdirQHsA+1T8
 Bv0EUVVbDia1TzHoafarqnUCw6fUkH5a+lOpqwKggLS3LQjCJS
 JGEG65fEfIsU9XIGxUx/O40dxreCk7Wc2WILQz3QYuWox+cqTU
 aoVm24PJsFqh0Dgc0zCuw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 May 2011 22:30:14 Arnaud Lacombe wrote:
> % KCONFIG_ALLCONFIG=arch/arm/configs/omap2plus_defconfig make ARCH=arm
> allnoconfig
> scripts/kconfig/conf --allnoconfig Kconfig
> arch/arm/configs/omap2plus_defconfig:92:warning: symbol value 'm'
> invalid for BT_L2CAP
> arch/arm/configs/omap2plus_defconfig:93:warning: symbol value 'm'
> invalid for BT_SCO
> warning: (ARCH_STMP3XXX && ARCH_OMAP3 && ARCH_OMAP4) selects
> USB_ARCH_HAS_EHCI which has unmet direct dependencies (USB_SUPPORT)
> warning: (ARCH_OMAP4) selects PL310_ERRATA_588369 which has unmet
> direct dependencies (CACHE_L2X0)
> warning: (ARCH_OMAP4) selects PL310_ERRATA_727915 which has unmet
> direct dependencies (CACHE_L2X0)
> #
> # configuration written to .config
> #
> 
> % grep CONFIG_ARCH_OMAP .config
> CONFIG_ARCH_OMAP=y
> # CONFIG_ARCH_OMAP1 is not set
> CONFIG_ARCH_OMAP2PLUS=y
> # CONFIG_ARCH_OMAP2PLUS_TYPICAL is not set
> CONFIG_ARCH_OMAP2=y
> CONFIG_ARCH_OMAP3=y
> CONFIG_ARCH_OMAP4=y
> 
> did I missed something ?

I figured it out now. I was using a separate object directory, which
caused the relative file name arch/arm/configs/omap2plus_defconfig
not to be found and the KCONFIG_ALLCONFIG option to be silently
dropped. I misinterpreted the resulting .config file as one that only
got the choice statements wrong, when in fact it had not taken any
default values that I passed.

In short, everything's fine except for a missing warning message
when the allconfig snippet is not found, and me making a fool of
myself.

It did solve one of my problems in the end, so I'm happy.

	Arnd
