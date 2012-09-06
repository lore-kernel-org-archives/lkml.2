Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab2IFO4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:56:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33458 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730Ab2IFO4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:56:10 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>
Subject: [PATCH 1/3] arm: omap: hwmod: add a new addr space in otg for writing to control module
Date: Thu, 6 Sep 2012 20:25:29 +0530
Message-ID: <1346943331-18120-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346943331-18120-1-git-send-email-kishon@ti.com>
References: <1346943331-18120-1-git-send-email-kishon@ti.com>
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

Cc: Benoit Cousson <b-cousson@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 242aee4..02341bc 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -5890,6 +5890,11 @@ static struct omap_hwmod_addr_space omap44xx_usb_otg_hs_addrs[] = {
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
1.7.9.5

