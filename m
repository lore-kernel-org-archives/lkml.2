Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab2CAUaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:30:08 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19814 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2CAUaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:30:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 01 Mar 2012 12:29:44 -0800
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
Date: Thu, 1 Mar 2012 12:29:43 -0800
Subject: RE: [PATCH 8/8] ARM: tegra: HACK: remove set_irq_flags() from driver
Thread-Topic: [PATCH 8/8] ARM: tegra: HACK: remove set_irq_flags() from
 driver
Thread-Index: Acz34Vs+fa6bBjn+T7+cKuisSEUdigACCGig
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BE86173C@HQMAIL01.nvidia.com>
References: <1330630010-11241-1-git-send-email-alan@signal11.us>
 <1330630010-11241-9-git-send-email-alan@signal11.us>
In-Reply-To: <1330630010-11241-9-git-send-email-alan@signal11.us>
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
> The driver should not call set_irq_flags itself, and

Probably true in this case.

> cannot do this from a loadable module.

I hope that's not true; grep'ing the entire of drivers/ shows a bunch
of drivers calling this function, and many look like they'd be reasonable
as module.

>From what little I understand of this, any irq_chip is going to call
that function after setting up any child/cascaded IRQs, and I assume
that irq_chips can be in modules.

> Remove the call for now, which might break the driver
> but at least lets the kernel link again.

The driver appears to work fine with this removed. At least, on Tegra20
Harmony, I was able to modprobe ehci-hcd and then use the USB Ethernet
controller for DHCP and SSH.

So,

Tested-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

