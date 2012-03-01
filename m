Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab2CAUhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:37:52 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1843 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab2CAUhu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:37:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 01 Mar 2012 12:36:59 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Alan Ott <alan@signal11.us>, Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Date: Thu, 1 Mar 2012 12:36:58 -0800
Subject: RE: [PATCH 6/8] ARM: tegra: USB_ULPI needs USB
Thread-Topic: [PATCH 6/8] ARM: tegra: USB_ULPI needs USB
Thread-Index: Acz36Yr5Tfp6VFgcTjylnPB6aFxCFgAASssg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BE861741@HQMAIL01.nvidia.com>
References: <1330630010-11241-1-git-send-email-alan@signal11.us>
 <1330630010-11241-7-git-send-email-alan@signal11.us>
 <74CDBE0F657A3D45AFBB94109FB122FF17BE86172C@HQMAIL01.nvidia.com>
 <201203012025.53560.arnd@arndb.de>
In-Reply-To: <201203012025.53560.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote at Thursday, March 01, 2012 1:26 PM:
> On Thursday 01 March 2012, Stephen Warren wrote:
> > Alan Ott wrote at Thursday, March 01, 2012 12:27 PM:
> > > From: Arnd Bergmann <arnd@arndb.de>
> > >
> > > The USB_ULPI driver is selected by tegra, but can only be
> > > built if at least one of USB or USB_GADGET is enabled.
> > > The kernel fails to link if both are off.
> >
> > > diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
> > ...
> > > @@ -10,6 +10,7 @@ config ARCH_TEGRA_2x_SOC
> > ...
> > > +	select USB_GADGET if USB_SUPPORT && !USB
> >
> > I don't believe the Tegra USB driver supports gadget mode at present.
> 
> ok.
> 
> > Would the above be better written as:
> >
> >     select USB if USB_SUPPORT
> 
> That does not look correct either. There is no reason why USB
> can't be disabled with USB_SUPPORT enabled on other platforms.
> 
> Maybe it's better to change the 'select USB_ULPI if USB_SUPPORT'
> into 'select USB_ULPI if USB' instead?

That sounds reasonable.

> Or maybe just don't select
> USB_ULPI to start with and put it into the defconfig instead.

Perhaps USB_EHCI_TEGRA should depend on USB, and select USB_EHCI?

-- 
nvpublic

