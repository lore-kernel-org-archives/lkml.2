Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab2HIKnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 06:43:47 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18689 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360Ab2HIKnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 06:43:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 09 Aug 2012 03:43:37 -0700
Subject: How to get the irq flags from the dts file
From: Wei Ni <wni@nvidia.com>
To: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        <frankyl@broadcom.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <brcm80211-dev-list@broadcom.com>,
        <linux-wireless@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Date: Thu, 9 Aug 2012 18:43:26 +0800
Message-ID: <1344509006.2295.148.camel@tegra-chromium-2>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all
I'm working on tegra wlan upstream issue.
The tegra board use the Broadcom 4329 as wlan device, and the driver is
the brcmfmac. 

This wlan driver support out-band-interrupt (OOB), I want to add DT
support to use this OOB.
I can add following lines in the dts file to create platform device and
pass the interrupt resource to the driver.

wlan {
        compatible = "broadcome, brcmf_sdio_pd";
        interrupt-parten = <&gpio>;
        interrupts = <144, 0x04>; /* IRQF_TRIGGER_HIGH */
};

In the wlan driver, it will use platform_get_resource() to get the
res->irq, res->flags, the irq number is right, but the flags will be
IORESOURCE_IRQ, not the 0x04 (IRQF_TRIGGER_HIGH).
The wlan driver wish this flags include the IRQF_TRGGER_* information,
and it will use this flags to configure other hw settings. If it is
wrong, the wlan can't work.

I checked drivers/of/irq.c, in function of_irq_to_resource(), it will
set r->flags = IORESOURCE_IRQ directly, not read the flags from the dtb
file. And I didn't find any of_xx api to get this flags.

How can I get this flags, does anyone has suggestion?

Thanks.
Wei.

