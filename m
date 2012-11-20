Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab2KTFLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 00:11:52 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56384 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238Ab2KTFLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 00:11:50 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>, <paul@pwsan.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>
CC: <hvaibhav@ti.com>, <anilkumar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <vaibhav.bedia@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH v3 02/10] ARM: am33xx: clk: Add optional clock for EHRPWM
Date: Tue, 20 Nov 2012 10:33:43 +0530
Message-ID: <1353387831-31538-3-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1353387831-31538-1-git-send-email-avinashphilip@ti.com>
References: <1353387831-31538-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EHRPWM module requires explicit clock gating from control module.
Hence add clock node in clock tree for EHRPWM modules.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
:100644 100644 17e3de5... 833260f... M	arch/arm/mach-omap2/clock33xx_data.c
:100644 100644 a89e825... c0e34e6... M	arch/arm/mach-omap2/control.h
 arch/arm/mach-omap2/clock33xx_data.c |   37 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/control.h        |    8 +++++++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/clock33xx_data.c b/arch/arm/mach-omap2/clock33xx_data.c
index 17e3de5..833260f 100644
--- a/arch/arm/mach-omap2/clock33xx_data.c
+++ b/arch/arm/mach-omap2/clock33xx_data.c
@@ -995,6 +995,40 @@ static struct clk wdt1_fck = {
 };
 
 /*
+ * PWMSS Time based module clock node. This node is
+ * requred to enable clock gating for EHRPWM TBCLK.
+ */
+static struct clk ehrpwm0_tbclk = {
+	.name		= "ehrpwm0_tbclk",
+	.clkdm_name	= "l4ls_clkdm",
+	.enable_reg	= AM33XX_CTRL_REGADDR(AM33XX_PWMSS_TBCLK_CLKCTRL),
+	.enable_bit	= AM33XX_PWMSS0_TBCLKEN_SHIFT,
+	.ops		= &clkops_omap2_dflt,
+	.parent		= &l4ls_gclk,
+	.recalc		= &followparent_recalc,
+};
+
+static struct clk ehrpwm1_tbclk = {
+	.name		= "ehrpwm1_tbclk",
+	.clkdm_name	= "l4ls_clkdm",
+	.enable_reg	= AM33XX_CTRL_REGADDR(AM33XX_PWMSS_TBCLK_CLKCTRL),
+	.enable_bit	= AM33XX_PWMSS1_TBCLKEN_SHIFT,
+	.ops		= &clkops_omap2_dflt,
+	.parent		= &l4ls_gclk,
+	.recalc		= &followparent_recalc,
+};
+
+static struct clk ehrpwm2_tbclk = {
+	.name		= "ehrpwm2_tbclk",
+	.clkdm_name	= "l4ls_clkdm",
+	.enable_reg	= AM33XX_CTRL_REGADDR(AM33XX_PWMSS_TBCLK_CLKCTRL),
+	.enable_bit	= AM33XX_PWMSS2_TBCLKEN_SHIFT,
+	.ops		= &clkops_omap2_dflt,
+	.parent		= &l4ls_gclk,
+	.recalc		= &followparent_recalc,
+};
+
+/*
  * clkdev
  */
 static struct omap_clk am33xx_clks[] = {
@@ -1074,6 +1108,9 @@ static struct omap_clk am33xx_clks[] = {
 	CLK(NULL,	"clkout2_ck",		&clkout2_ck,	CK_AM33XX),
 	CLK(NULL,	"timer_32k_ck",		&clkdiv32k_ick,	CK_AM33XX),
 	CLK(NULL,	"timer_sys_ck",		&sys_clkin_ck,	CK_AM33XX),
+	CLK(NULL,	"ehrpwm0_tbclk",	&ehrpwm0_tbclk,	CK_AM33XX),
+	CLK(NULL,	"ehrpwm1_tbclk",	&ehrpwm1_tbclk,	CK_AM33XX),
+	CLK(NULL,	"ehrpwm2_tbclk",	&ehrpwm2_tbclk,	CK_AM33XX),
 };
 
 int __init am33xx_clk_init(void)
diff --git a/arch/arm/mach-omap2/control.h b/arch/arm/mach-omap2/control.h
index a89e825..c0e34e6 100644
--- a/arch/arm/mach-omap2/control.h
+++ b/arch/arm/mach-omap2/control.h
@@ -357,6 +357,14 @@
 #define AM33XX_CONTROL_STATUS_SYSBOOT1_WIDTH		0x2
 #define AM33XX_CONTROL_STATUS_SYSBOOT1_MASK		(0x3 << 22)
 
+/* AM33XX PWMSS Control register */
+#define AM33XX_PWMSS_TBCLK_CLKCTRL			0x664
+
+/* AM33XX  PWMSS Control bitfields */
+#define AM33XX_PWMSS0_TBCLKEN_SHIFT			0
+#define AM33XX_PWMSS1_TBCLKEN_SHIFT			1
+#define AM33XX_PWMSS2_TBCLKEN_SHIFT			2
+
 /* CONTROL OMAP STATUS register to identify OMAP3 features */
 #define OMAP3_CONTROL_OMAP_STATUS	0x044c
 
-- 
1.7.0.4

