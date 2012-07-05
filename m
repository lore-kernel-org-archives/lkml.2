Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab2GEMlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:41:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57683 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932356Ab2GEMl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:41:29 -0400
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>,
        "Cousson, Benoit" <b-cousson@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v2 REPOST 4/4] ARM: OMAP2+: dmtimer: cleanup fclk usage
Date: Thu, 5 Jul 2012 18:10:59 +0530
Message-ID: <1341492059-5544-1-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With omap_hwmod_get_main_clk() now available, this can be passed to
clk_get() to extract the fclk and thus avoid construction of fclk name.
Corrected the timer fck name mis-match between clock44xx_data.c and
omap_hwmod_44xx_data.c. For other platforms this is already taken care.

Cc: Cousson, Benoit <b-cousson@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>

Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
---
Reference:
git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap.git
Branch: cleanup-part2

Tested on ZOOM3, BLAZE, PANDA.

 arch/arm/mach-omap2/clock44xx_data.c |   22 +++++++++++-----------
 arch/arm/mach-omap2/timer.c          |    3 +--
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-omap2/clock44xx_data.c b/arch/arm/mach-omap2/clock44xx_data.c
index ba6f9a0..f9d4f58 100644
--- a/arch/arm/mach-omap2/clock44xx_data.c
+++ b/arch/arm/mach-omap2/clock44xx_data.c
@@ -3299,17 +3299,17 @@ static struct omap_clk omap44xx_clks[] = {
 	CLK(NULL,	"smartreflex_core_fck",		&smartreflex_core_fck,	CK_443X),
 	CLK(NULL,	"smartreflex_iva_fck",		&smartreflex_iva_fck,	CK_443X),
 	CLK(NULL,	"smartreflex_mpu_fck",		&smartreflex_mpu_fck,	CK_443X),
-	CLK(NULL,	"gpt1_fck",			&timer1_fck,	CK_443X),
-	CLK(NULL,	"gpt10_fck",			&timer10_fck,	CK_443X),
-	CLK(NULL,	"gpt11_fck",			&timer11_fck,	CK_443X),
-	CLK(NULL,	"gpt2_fck",			&timer2_fck,	CK_443X),
-	CLK(NULL,	"gpt3_fck",			&timer3_fck,	CK_443X),
-	CLK(NULL,	"gpt4_fck",			&timer4_fck,	CK_443X),
-	CLK(NULL,	"gpt5_fck",			&timer5_fck,	CK_443X),
-	CLK(NULL,	"gpt6_fck",			&timer6_fck,	CK_443X),
-	CLK(NULL,	"gpt7_fck",			&timer7_fck,	CK_443X),
-	CLK(NULL,	"gpt8_fck",			&timer8_fck,	CK_443X),
-	CLK(NULL,	"gpt9_fck",			&timer9_fck,	CK_443X),
+	CLK(NULL,	"timer1_fck",			&timer1_fck,	CK_443X),
+	CLK(NULL,	"timer10_fck",			&timer10_fck,	CK_443X),
+	CLK(NULL,	"timer11_fck",			&timer11_fck,	CK_443X),
+	CLK(NULL,	"timer2_fck",			&timer2_fck,	CK_443X),
+	CLK(NULL,	"timer3_fck",			&timer3_fck,	CK_443X),
+	CLK(NULL,	"timer4_fck",			&timer4_fck,	CK_443X),
+	CLK(NULL,	"timer5_fck",			&timer5_fck,	CK_443X),
+	CLK(NULL,	"timer6_fck",			&timer6_fck,	CK_443X),
+	CLK(NULL,	"timer7_fck",			&timer7_fck,	CK_443X),
+	CLK(NULL,	"timer8_fck",			&timer8_fck,	CK_443X),
+	CLK(NULL,	"timer9_fck",			&timer9_fck,	CK_443X),
 	CLK(NULL,	"uart1_fck",			&uart1_fck,	CK_443X),
 	CLK(NULL,	"uart2_fck",			&uart2_fck,	CK_443X),
 	CLK(NULL,	"uart3_fck",			&uart3_fck,	CK_443X),
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 840929b..4c9ef35 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -173,8 +173,7 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
 		return -ENXIO;
 
 	/* After the dmtimer is using hwmod these clocks won't be needed */
-	sprintf(name, "gpt%d_fck", gptimer_id);
-	timer->fclk = clk_get(NULL, name);
+	timer->fclk = clk_get(NULL, omap_hwmod_get_main_clk(oh));
 	if (IS_ERR(timer->fclk))
 		return -ENODEV;
 
-- 
1.7.0.4

