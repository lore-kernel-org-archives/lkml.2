Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab1HDP7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 11:59:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43662 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033Ab1HDP7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 11:59:42 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <paul@pwsan.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Vaibhav Hiremath <hvaibhav@ti.com>,
        Abhilash K V <abhilash.kv@ti.com>
Subject: [PATCH 2/2] omap_twl: Prevent SR to enable for am3517/am3505 devices
Date: Thu, 4 Aug 2011 21:29:29 +0530
Message-ID: <1312473569-1212-1-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Hiremath <hvaibhav@ti.com>

In case of AM3517 & AM3505, Smart Reflex is not applicable so
we must not enable it. So add check for am3517/05 cpu revision
in omap3_twl_init() and return -ENODEV if true, else continue.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
---
 arch/arm/mach-omap2/omap_twl.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_twl.c b/arch/arm/mach-omap2/omap_twl.c
index 07d6140..92fadcb 100644
--- a/arch/arm/mach-omap2/omap_twl.c
+++ b/arch/arm/mach-omap2/omap_twl.c
@@ -269,6 +269,14 @@ int __init omap3_twl_init(void)
 	if (!cpu_is_omap34xx())
 		return -ENODEV;
 
+	/*
+	 * In case of AM3517/AM3505 we should not be going down
+	 * further, since SR is not applicable there.
+	 */
+	if (cpu_is_omap3505() || cpu_is_omap3517()) {
+		return -ENODEV;
+	}
+
 	if (cpu_is_omap3630()) {
 		omap3_mpu_volt_info.vp_vddmin = OMAP3630_VP1_VLIMITTO_VDDMIN;
 		omap3_mpu_volt_info.vp_vddmax = OMAP3630_VP1_VLIMITTO_VDDMAX;
-- 
1.7.1

