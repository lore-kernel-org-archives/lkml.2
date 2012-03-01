Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab2CAUF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:05:57 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16477 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab2CAUFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:05:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 01 Mar 2012 12:05:36 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Alan Ott <alan@signal11.us>, Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 1 Mar 2012 12:05:34 -0800
Subject: RE: [PATCH 6/8] ARM: tegra: USB_ULPI needs USB
Thread-Topic: [PATCH 6/8] ARM: tegra: USB_ULPI needs USB
Thread-Index: Acz34Vn8/MPOfmTYQe25cZFfnIlkDwABPwkA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BE86172C@HQMAIL01.nvidia.com>
References: <1330630010-11241-1-git-send-email-alan@signal11.us>
 <1330630010-11241-7-git-send-email-alan@signal11.us>
In-Reply-To: <1330630010-11241-7-git-send-email-alan@signal11.us>
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

Alan Ott wrote at Thursday, March 01, 2012 12:27 PM:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The USB_ULPI driver is selected by tegra, but can only be
> built if at least one of USB or USB_GADGET is enabled.
> The kernel fails to link if both are off.

> diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
...
> @@ -10,6 +10,7 @@ config ARCH_TEGRA_2x_SOC
...
> +	select USB_GADGET if USB_SUPPORT && !USB

I don't believe the Tegra USB driver supports gadget mode at present.
Would the above be better written as:

    select USB if USB_SUPPORT

And I wonder if the Tegra EHCI driver shouldn't be doing some of these
selects, not the ARCH_TEGRA_* option.

And this is probably required for Tegra30 too not just Tegra20.

-- 
nvpublic

