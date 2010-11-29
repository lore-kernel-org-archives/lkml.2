Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab0K2P6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:58:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59295 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab0K2P6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:58:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Ulli Kroll <ulli.kroll@googlemail.com>
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI Bus
Date: Mon, 29 Nov 2010 16:57:53 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirqus@gmail.com>,
        linux-kernel@vger.kernel.org
References: <1290263224-16965-1-git-send-email-ulli.kroll@googlemail.com> <20101129142200.GA14941@n2100.arm.linux.org.uk> <alpine.LNX.2.00.1011291546550.12293@localhost.localdomain>
In-Reply-To: <alpine.LNX.2.00.1011291546550.12293@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011291657.53316.arnd@arndb.de>
X-Provags-ID: V02:K0:mVoy9JZAeMXp4YVAvZdXp5OEcK7sh7sW+TrblAhbKEX
 cS6+aC3G0tVj+diU03zUYSVsgdHvIISbUMXfHOLZWD8Vvt3cCU
 5irbEQ2vYkU5nYHkCfqMgiX0YjX+y8fjBbEdaek71xEmfz7dLL
 0SI6NByub895zDZif81ICCshD8E71v048BgE0JyRkh4smuH7wU
 C/cEw4ijjPXgvAYeSRTfA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 November 2010, Hans Ulli Kroll wrote:
> @@ -1164,7 +1169,7 @@ config ISA_DMA_API
>         bool
>  
>  config PCI
> -       bool "PCI support" if ARCH_INTEGRATOR_AP || ARCH_VERSATILE_PB || 
> ARCH_IXP4XX || ARCH_KS8695 || MACH_ARMCORE || ARCH_CNS3XXX
> +       bool "PCI support" if MIGHT_HAVE_PCI
>         help
>           Find out whether you have a PCI motherboard. PCI is the name of 
> a
>           bus system, i.e. the way the CPU talks to the other stuff inside

This does not solve the problem that Russell mentioned: existing platforms
select PCI unconditionally, e.g. Iop13XX, some IXP, Orion, Shark
and more. At the very least, these would need to also select MIGHT_HAVE_PCI
to avoid the warning.

> index fe0c82e..f5c39a8 100644
> --- a/arch/arm/mach-ks8695/Kconfig
> +++ b/arch/arm/mach-ks8695/Kconfig
> @@ -4,6 +4,7 @@ menu "Kendin/Micrel KS8695 Implementations"
>  
>  config MACH_KS8695
>         +++ b/arch/arm/mach-versatile/Kconfig
> @@ -4,6 +4,7 @@ menu "Versatile platform type"
>  config ARCH_VERSATILE_PB
>         bool "Support Versatile/PB platform"
>         select CPU_ARM926T
> +       select HAVE_PCI
>         default y
>         help
>           Include support for the ARM(R) Versatile/PB platform.bool 

Typo: you certainly meant MIGHT_HAVE_PCI here.

We still need to agree on what it should be doing, but otherwise this
is what I had in mind.

	Arnd
