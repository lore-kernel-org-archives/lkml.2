Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab2CAU0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:26:03 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57050 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415Ab2CAU0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:26:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 6/8] ARM: tegra: USB_ULPI needs USB
Date: Thu, 1 Mar 2012 20:25:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Alan Ott <alan@signal11.us>, Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
References: <1330630010-11241-1-git-send-email-alan@signal11.us> <1330630010-11241-7-git-send-email-alan@signal11.us> <74CDBE0F657A3D45AFBB94109FB122FF17BE86172C@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BE86172C@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203012025.53560.arnd@arndb.de>
X-Provags-ID: V02:K0:hV6FW7N8BupCcf/BmFhNg4cqytcIEwJ7e5qmyyW+zro
 a2mrZIsfjy55iq8m3kMhEdhtHTsSDwNMAoF4mP8SZ7Y7swdOqs
 NwNpuLVTWg9rSBZj8tQCMl//TB2VwxTarcyLKbTKL1s4EgRF1s
 t+mqnaX/zB5BGTpEgh/qEtaYuKsmBTtDxKBYQqVZ1bl1qe/R0o
 NEmHTIhHrZL88CUfzMFVhGKiyeCqlGheAs7KCWXaxhactYuXg9
 PS1qWWwrmBEJ5dn6uNKJjt2cV26DcoyhB38+3lFk5Z14QakaUZ
 D9HBeJ2A6+AE9smDUBk18yd8823B/T6oO38YnXhtEYtAHUKSFh
 ex+NU2WJ/Q6YKWthi67Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2012, Stephen Warren wrote:
> Alan Ott wrote at Thursday, March 01, 2012 12:27 PM:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > The USB_ULPI driver is selected by tegra, but can only be
> > built if at least one of USB or USB_GADGET is enabled.
> > The kernel fails to link if both are off.
> 
> > diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
> ...
> > @@ -10,6 +10,7 @@ config ARCH_TEGRA_2x_SOC
> ...
> > +	select USB_GADGET if USB_SUPPORT && !USB
> 
> I don't believe the Tegra USB driver supports gadget mode at present.

ok.

> Would the above be better written as:
> 
>     select USB if USB_SUPPORT

That does not look correct either. There is no reason why USB
can't be disabled with USB_SUPPORT enabled on other platforms.

Maybe it's better to change the 'select USB_ULPI if USB_SUPPORT'
into 'select USB_ULPI if USB' instead? Or maybe just don't select
USB_ULPI to start with and put it into the defconfig instead.

> And this is probably required for Tegra30 too not just Tegra20.

Right. Tegra30 was not there when I did these patches, so it's
probably missing in other places, too.

	Arnd
