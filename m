Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab1HSLzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:55:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59166 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab1HSLzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:55:45 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <khilman@ti.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>, Abhilash K V <abhilash.kv@ti.com>
Subject: [PATCH 3/4] pm34xx: Warning FIX related to ambiguous else loop
Date: Fri, 19 Aug 2011 17:25:26 +0530
Message-ID: <1313754927-11992-4-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1313754927-11992-3-git-send-email-abhilash.kv@ti.com>
References: <1313754927-11992-1-git-send-email-abhilash.kv@ti.com>
 <1313754927-11992-2-git-send-email-abhilash.kv@ti.com>
 <1313754927-11992-3-git-send-email-abhilash.kv@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Hiremath <hvaibhav@ti.com>

Fixes below warning -

arch/arm/mach-omap2/pm34xx.c:1041: warning:
        suggest explicit braces to avoid ambiguous 'else

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
---
 arch/arm/mach-omap2/pm34xx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index 12af5b9..ab3822b 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -856,7 +856,7 @@ void omap_push_sram_idle(void)
 	else
 		_omap_sram_idle = omap_sram_push(omap34xx_cpu_suspend,
 					omap34xx_cpu_suspend_sz);
-	if (omap_type() != OMAP2_DEVICE_TYPE_GP)
+	if (omap_type() != OMAP2_DEVICE_TYPE_GP) {
 		if (cpu_is_omap3505() || cpu_is_omap3517())
 			_omap_save_secure_sram = omap_sram_push(
 					omap3517_save_secure_ram_context,
@@ -865,6 +865,7 @@ void omap_push_sram_idle(void)
 			_omap_save_secure_sram = omap_sram_push(
 					save_secure_ram_context,
 					save_secure_ram_context_sz);
+	}
 }
 
 static void __init pm_errata_configure(void)
-- 
1.7.1

