Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab2F1Lvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 07:51:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:32918 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab2F1Lvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 07:51:46 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <b-cousson@ti.com>, <rnayak@ti.com>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>
CC: <hvaibhav@ti.com>
Subject: [PATCH v1 04/11] arm: omap: hwmod: add a new addr space in otg for writing to control module
Date: Thu, 28 Jun 2012 17:21:00 +0530
Message-ID: <1340884267-28908-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1340884267-28908-1-git-send-email-kishon@ti.com>
References: <1340884267-28908-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mailbox register for usb otg in omap is present in control module.
On detection of any events VBUS or ID, this register should be written
to send the notification to musb core.

Till we have a separate control module driver to write to control module,
omap2430 will handle the register writes to control module by itself. So
a new address space to represent this control module register is added
to usb_otg_hs.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 249ff76..2c28754 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -5897,6 +5897,11 @@ static struct omap_hwmod_addr_space omap44xx_usb_otg_hs_addrs[] = {
 		.pa_end		= 0x4a0ab003,
 		.flags		= ADDR_TYPE_RT
 	},
+	{
+		.pa_start	= 0x4a00233c,
+		.pa_end		= 0x4a00233f,
+		.flags		= ADDR_TYPE_RT
+	},
 	{ }
 };
 
-- 
1.7.5.4

