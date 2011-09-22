Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab1IVN1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 09:27:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48015 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab1IVN1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 09:27:07 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <paul@pwsan.com>, <aneesh@ti.com>, <khilman@ti.com>,
        <santosh.shilimkar@ti.com>, <christian.gmeiner@gmail.com>,
        Abhilash K V <abhilash.kv@ti.com>
Subject: [PATCH v4 3/3] OMAP2+: voltage: add check for missing PMIC info in vp init
Date: Thu, 22 Sep 2011 18:56:33 +0530
Message-ID: <1316697993-696-4-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1316697993-696-3-git-send-email-abhilash.kv@ti.com>
References: <1316697993-696-1-git-send-email-abhilash.kv@ti.com>
 <1316697993-696-2-git-send-email-abhilash.kv@ti.com>
 <1316697993-696-3-git-send-email-abhilash.kv@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If PMIC info is not available in omap_vp_init(), abort.

Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
---
 arch/arm/mach-omap2/vp.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/vp.c b/arch/arm/mach-omap2/vp.c
index 66bd700..2c99837 100644
--- a/arch/arm/mach-omap2/vp.c
+++ b/arch/arm/mach-omap2/vp.c
@@ -41,6 +41,13 @@ void __init omap_vp_init(struct voltagedomain *voltdm)
 	u32 val, sys_clk_rate, timeout, waittime;
 	u32 vddmin, vddmax, vstepmin, vstepmax;
 
+	if (!voltdm->pmic || !voltdm->pmic->uv_to_vsel) {
+		pr_err("%s: PMIC info requried to configure vp for"
+			"vdd_%s not populated.Hence cannot initialize vp\n",
+			__func__, voltdm->name);
+		return;
+	}
+
 	if (!voltdm->read || !voltdm->write) {
 		pr_err("%s: No read/write API for accessing vdd_%s regs\n",
 			__func__, voltdm->name);
-- 
1.7.1

