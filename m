Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab2G3JKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 05:10:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36898 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab2G3JK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 05:10:27 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <b-cousson@ti.com>, <rnayak@ti.com>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: [PATCH v6 04/11] arm: omap: hwmod: add a new addr space in otg for writing to control module
Date: Mon, 30 Jul 2012 14:39:53 +0530
Message-ID: <1343639400-28725-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343639400-28725-1-git-send-email-kishon@ti.com>
References: <1343639400-28725-1-git-send-email-kishon@ti.com>
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
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 249ff76..775e185 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -5934,6 +5934,11 @@ static struct omap_hwmod_addr_space omap44xx_wd_timer2_addrs[] = {
 		.pa_end		= 0x4a31407f,
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

