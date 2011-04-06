Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab1DFN3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 09:29:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57745 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab1DFN3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 09:29:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eiK5UZFDk3S7VA1blvQqQeVb2nK3EAmAng3y1TbpJ4DEAzmpyLgVIaUasYl2OHBWna
         b0u5nly5X2r75+0D9YMp90gbI9t5k8JcpYWW2aSyoHz+fIueR4KY2e77R4d22mmjJQ64
         xBo7sPbg351bXdvir/XCi6Vh5bQHXOdCb5yLQ=
From: Chihau Chau <chihau@gmail.com>
To: davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        linux@arm.linux.org.uk, gregkh@suse.de
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Chihau Chau <chihau@gmail.com>
Subject: [PATCH] arm: mach-msm: acpclock-arm11: Fix some code style issues
Date: Wed,  6 Apr 2011 10:28:33 -0300
Message-Id: <1302096513-18680-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix some code style issues like braces in the incorrect position, assignments in a if condition and lack of a space before '&&'

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 arch/arm/mach-msm/acpuclock-arm11.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-msm/acpuclock-arm11.c b/arch/arm/mach-msm/acpuclock-arm11.c
index 7ffbd98..d716cf1 100644
--- a/arch/arm/mach-msm/acpuclock-arm11.c
+++ b/arch/arm/mach-msm/acpuclock-arm11.c
@@ -51,8 +51,7 @@
 #define PERF_SWITCH_DEBUG 0
 #define PERF_SWITCH_STEP_DEBUG 0
 
-struct clock_state
-{
+struct clock_state {
 	struct clkctl_acpu_speed	*current_speed;
 	struct mutex			lock;
 	uint32_t			acpu_switch_time_us;
@@ -88,7 +87,7 @@ struct clkctl_acpu_speed {
 	unsigned int	ahbclk_khz;
 	unsigned int	ahbclk_div;
 	int		vdd;
-	unsigned int 	axiclk_khz;
+	unsigned int	axiclk_khz;
 	unsigned long	lpj; /* loops_per_jiffy */
 /* Index in acpu_freq_tbl[] for steppings. */
 	short		down;
@@ -176,7 +175,8 @@ static int pc_pll_request(unsigned id, unsigned on)
  * ARM11 'owned' clock control
  *---------------------------------------------------------------------------*/
 
-unsigned long acpuclk_power_collapse(void) {
+unsigned long acpuclk_power_collapse(void)
+{
 	int ret = acpuclk_get_rate();
 	ret *= 1000;
 	if (ret > drv_state.power_collapse_khz)
@@ -189,7 +189,8 @@ unsigned long acpuclk_get_wfi_rate(void)
 	return drv_state.wait_for_irq_khz;
 }
 
-unsigned long acpuclk_wait_for_irq(void) {
+unsigned long acpuclk_wait_for_irq(void)
+{
 	int ret = acpuclk_get_rate();
 	ret *= 1000;
 	if (ret > drv_state.wait_for_irq_khz)
@@ -223,7 +224,8 @@ static int acpuclk_set_vdd_level(int vdd)
 }
 
 /* Set proper dividers for the given clock speed. */
-static void acpuclk_set_div(const struct clkctl_acpu_speed *hunt_s) {
+static void acpuclk_set_div(const struct clkctl_acpu_speed *hunt_s)
+{
 	uint32_t reg_clkctl, reg_clksel, clk_div;
 
 	/* AHB_CLK_DIV */
@@ -336,7 +338,8 @@ int acpuclk_set_rate(unsigned long rate, int for_power_collapse)
 		}
 		/* Increase VDD if needed. */
 		if (tgt_s->vdd > cur_s->vdd) {
-			if ((rc = acpuclk_set_vdd_level(tgt_s->vdd)) < 0) {
+			rc = acpuclk_set_vdd_level(tgt_s->vdd)
+			if (rc < 0) {
 				printk(KERN_ERR "Unable to switch ACPU vdd\n");
 				goto out;
 			}
@@ -378,7 +381,7 @@ int acpuclk_set_rate(unsigned long rate, int for_power_collapse)
 		printk(KERN_DEBUG "%s: STEP khz = %u, pll = %d\n",
 			__FUNCTION__, cur_s->a11clk_khz, cur_s->pll);
 #endif
-		if (!for_power_collapse&& cur_s->pll != ACPU_PLL_TCXO
+		if (!for_power_collapse && cur_s->pll != ACPU_PLL_TCXO
 		    && !(plls_enabled & (1 << cur_s->pll))) {
 			rc = pc_pll_request(cur_s->pll, 1);
 			if (rc < 0) {
-- 
1.7.3.4

