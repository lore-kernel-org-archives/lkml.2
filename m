Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab0LFWLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:11:20 -0500
Received: from mail.perches.com ([173.55.12.10]:2330 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab0LFWFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:21 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/29] arch/arm: Update WARN uses
Date: Mon,  6 Dec 2010 14:04:53 -0800
Message-Id: <daff7ef69572129b581a8aa28c3c6cd1d786504c.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coalesce long formats.
Align arguments.
Add missing newlines.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/mach-davinci/clock.c     |    4 +-
 arch/arm/mach-davinci/da830.c     |    2 +-
 arch/arm/mach-davinci/da850.c     |   12 ++++-----
 arch/arm/mach-omap2/clkt_clksel.c |   12 ++++----
 arch/arm/mach-omap2/clock.c       |   16 ++++++------
 arch/arm/mach-omap2/devices.c     |    4 +-
 arch/arm/mach-omap2/omap_hwmod.c  |   47 ++++++++++++++++++++++---------------
 arch/arm/mach-omap2/pm34xx.c      |    7 ++---
 arch/arm/mach-omap2/serial.c      |    2 +-
 arch/arm/mach-omap2/timer-gp.c    |    3 +-
 arch/arm/mach-tegra/clock.c       |    3 +-
 arch/arm/mach-tegra/timer.c       |    2 +-
 arch/arm/mach-u300/padmux.c       |   14 +++--------
 arch/arm/plat-omap/omap-pm-noop.c |   10 ++++----
 14 files changed, 69 insertions(+), 69 deletions(-)

diff --git a/arch/arm/mach-davinci/clock.c b/arch/arm/mach-davinci/clock.c
index e4e3af1..dc479fe 100644
--- a/arch/arm/mach-davinci/clock.c
+++ b/arch/arm/mach-davinci/clock.c
@@ -177,8 +177,8 @@ int clk_register(struct clk *clk)
 		return -EINVAL;
 
 	if (WARN(clk->parent && !clk->parent->rate,
-			"CLK: %s parent %s has no rate!\n",
-			clk->name, clk->parent->name))
+		 "CLK: %s parent %s has no rate!\n",
+		 clk->name, clk->parent->name))
 		return -EINVAL;
 
 	INIT_LIST_HEAD(&clk->children);
diff --git a/arch/arm/mach-davinci/da830.c b/arch/arm/mach-davinci/da830.c
index ec23ab4..1ae9ea9 100644
--- a/arch/arm/mach-davinci/da830.c
+++ b/arch/arm/mach-davinci/da830.c
@@ -1208,5 +1208,5 @@ void __init da830_init(void)
 	davinci_common_init(&davinci_soc_info_da830);
 
 	da8xx_syscfg0_base = ioremap(DA8XX_SYSCFG0_BASE, SZ_4K);
-	WARN(!da8xx_syscfg0_base, "Unable to map syscfg0 module");
+	WARN(!da8xx_syscfg0_base, "Unable to map syscfg0 module\n");
 }
diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index 63916b9..b83a273 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -811,8 +811,8 @@ static void da850_set_async3_src(int pllnum)
 		clk = c->clk;
 		if (clk->flags & DA850_CLK_ASYNC3) {
 			ret = clk_set_parent(clk, newparent);
-			WARN(ret, "DA850: unable to re-parent clock %s",
-								clk->name);
+			WARN(ret, "DA850: unable to re-parent clock %s\n",
+			     clk->name);
 		}
        }
 
@@ -903,10 +903,8 @@ static int da850_set_voltage(unsigned int index)
 static int da850_regulator_init(void)
 {
 	cvdd = regulator_get(NULL, "cvdd");
-	if (WARN(IS_ERR(cvdd), "Unable to obtain voltage regulator for CVDD;"
-					" voltage scaling unsupported\n")) {
+	if (WARN(IS_ERR(cvdd), "Unable to obtain voltage regulator for CVDD; voltage scaling unsupported\n"))
 		return PTR_ERR(cvdd);
-	}
 
 	return 0;
 }
@@ -1079,11 +1077,11 @@ void __init da850_init(void)
 	davinci_common_init(&davinci_soc_info_da850);
 
 	da8xx_syscfg0_base = ioremap(DA8XX_SYSCFG0_BASE, SZ_4K);
-	if (WARN(!da8xx_syscfg0_base, "Unable to map syscfg0 module"))
+	if (WARN(!da8xx_syscfg0_base, "Unable to map syscfg0 module\n"))
 		return;
 
 	da8xx_syscfg1_base = ioremap(DA8XX_SYSCFG1_BASE, SZ_4K);
-	if (WARN(!da8xx_syscfg1_base, "Unable to map syscfg1 module"))
+	if (WARN(!da8xx_syscfg1_base, "Unable to map syscfg1 module\n"))
 		return;
 
 	/*
diff --git a/arch/arm/mach-omap2/clkt_clksel.c b/arch/arm/mach-omap2/clkt_clksel.c
index a781cd6..f0f7c0b 100644
--- a/arch/arm/mach-omap2/clkt_clksel.c
+++ b/arch/arm/mach-omap2/clkt_clksel.c
@@ -70,8 +70,8 @@ static const struct clksel *_get_clksel_by_parent(struct clk *clk,
 
 	if (!clks->parent) {
 		/* This indicates a data problem */
-		WARN(1, "clock: Could not find parent clock %s in clksel array "
-		     "of clock %s\n", src_clk->name, clk->name);
+		WARN(1, "clock: Could not find parent clock %s in clksel array of clock %s\n",
+		     src_clk->name, clk->name);
 		return NULL;
 	}
 
@@ -125,8 +125,8 @@ static u8 _get_div_and_fieldval(struct clk *src_clk, struct clk *clk,
 
 	if (max_div == 0) {
 		/* This indicates an error in the clksel data */
-		WARN(1, "clock: Could not find divisor for clock %s parent %s"
-		     "\n", clk->name, src_clk->parent->name);
+		WARN(1, "clock: Could not find divisor for clock %s parent %s\n",
+		     clk->name, src_clk->parent->name);
 		return 0;
 	}
 
@@ -190,8 +190,8 @@ static u32 _clksel_to_divisor(struct clk *clk, u32 field_val)
 
 	if (!clkr->div) {
 		/* This indicates a data error */
-		WARN(1, "clock: Could not find fieldval %d for clock %s parent "
-		     "%s\n", field_val, clk->name, clk->parent->name);
+		WARN(1, "clock: Could not find fieldval %d for clock %s parent %s\n",
+		     field_val, clk->name, clk->parent->name);
 		return 0;
 	}
 
diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index b5babf5..0336813 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -249,8 +249,8 @@ const struct clkops clkops_omap2_dflt = {
 void omap2_clk_disable(struct clk *clk)
 {
 	if (clk->usecount == 0) {
-		WARN(1, "clock: %s: omap2_clk_disable() called, but usecount "
-		     "already 0?", clk->name);
+		WARN(1, "clock: %s: omap2_clk_disable() called, but usecount already 0?\n",
+		     clk->name);
 		return;
 	}
 
@@ -308,8 +308,8 @@ int omap2_clk_enable(struct clk *clk)
 	if (clk->clkdm) {
 		ret = omap2_clkdm_clk_enable(clk->clkdm, clk);
 		if (ret) {
-			WARN(1, "clock: %s: could not enable clockdomain %s: "
-			     "%d\n", clk->name, clk->clkdm->name, ret);
+			WARN(1, "clock: %s: could not enable clockdomain %s: %d\n",
+			     clk->name, clk->clkdm->name, ret);
 			goto oce_err2;
 		}
 	}
@@ -431,7 +431,7 @@ int __init omap2_clk_switch_mpurate_at_boot(const char *mpurate_ck_name)
 		return -EINVAL;
 
 	mpurate_ck = clk_get(NULL, mpurate_ck_name);
-	if (WARN(IS_ERR(mpurate_ck), "Failed to get %s.\n", mpurate_ck_name))
+	if (WARN(IS_ERR(mpurate_ck), "Failed to get %s\n", mpurate_ck_name))
 		return -ENOENT;
 
 	r = clk_set_rate(mpurate_ck, mpurate);
@@ -469,15 +469,15 @@ void __init omap2_clk_print_new_rates(const char *hfclkin_ck_name,
 	unsigned long hfclkin_rate;
 
 	mpu_ck = clk_get(NULL, mpu_ck_name);
-	if (WARN(IS_ERR(mpu_ck), "clock: failed to get %s.\n", mpu_ck_name))
+	if (WARN(IS_ERR(mpu_ck), "clock: failed to get %s\n", mpu_ck_name))
 		return;
 
 	core_ck = clk_get(NULL, core_ck_name);
-	if (WARN(IS_ERR(core_ck), "clock: failed to get %s.\n", core_ck_name))
+	if (WARN(IS_ERR(core_ck), "clock: failed to get %s\n", core_ck_name))
 		return;
 
 	hfclkin_ck = clk_get(NULL, hfclkin_ck_name);
-	if (WARN(IS_ERR(hfclkin_ck), "Failed to get %s.\n", hfclkin_ck_name))
+	if (WARN(IS_ERR(hfclkin_ck), "Failed to get %s\n", hfclkin_ck_name))
 		return;
 
 	hfclkin_rate = clk_get_rate(hfclkin_ck);
diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 5a0c148..b6ab066 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -1062,8 +1062,8 @@ static int __init omap_init_wdt(void)
 	od = omap_device_build(dev_name, id, oh, NULL, 0,
 				omap_wdt_latency,
 				ARRAY_SIZE(omap_wdt_latency), 0);
-	WARN(IS_ERR(od), "Cant build omap_device for %s:%s.\n",
-				dev_name, oh->name);
+	WARN(IS_ERR(od), "Cant build omap_device for %s:%s\n",
+	     dev_name, oh->name);
 	return 0;
 }
 subsys_initcall(omap_init_wdt);
diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 5a30658..a8ef5c1 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -178,7 +178,8 @@ static u8 inited;
 static int _update_sysc_cache(struct omap_hwmod *oh)
 {
 	if (!oh->class->sysc) {
-		WARN(1, "omap_hwmod: %s: cannot read OCP_SYSCONFIG: not defined on hwmod's class\n", oh->name);
+		WARN(1, "omap_hwmod: %s: cannot read OCP_SYSCONFIG: not defined on hwmod's class\n",
+		     oh->name);
 		return -EINVAL;
 	}
 
@@ -203,7 +204,8 @@ static int _update_sysc_cache(struct omap_hwmod *oh)
 static void _write_sysconfig(u32 v, struct omap_hwmod *oh)
 {
 	if (!oh->class->sysc) {
-		WARN(1, "omap_hwmod: %s: cannot write OCP_SYSCONFIG: not defined on hwmod's class\n", oh->name);
+		WARN(1, "omap_hwmod: %s: cannot write OCP_SYSCONFIG: not defined on hwmod's class\n",
+		     oh->name);
 		return;
 	}
 
@@ -236,7 +238,8 @@ static int _set_master_standbymode(struct omap_hwmod *oh, u8 standbymode,
 		return -EINVAL;
 
 	if (!oh->class->sysc->sysc_fields) {
-		WARN(1, "omap_hwmod: %s: offset struct for sysconfig not provided in class\n", oh->name);
+		WARN(1, "omap_hwmod: %s: offset struct for sysconfig not provided in class\n",
+		     oh->name);
 		return -EINVAL;
 	}
 
@@ -269,7 +272,8 @@ static int _set_slave_idlemode(struct omap_hwmod *oh, u8 idlemode, u32 *v)
 		return -EINVAL;
 
 	if (!oh->class->sysc->sysc_fields) {
-		WARN(1, "omap_hwmod: %s: offset struct for sysconfig not provided in class\n", oh->name);
+		WARN(1, "omap_hwmod: %s: offset struct for sysconfig not provided in class\n",
+		     oh->name);
 		return -EINVAL;
 	}
 
@@ -303,7 +307,8 @@ static int _set_clockactivity(struct omap_hwmod *oh, u8 clockact, u32 *v)
 		return -EINVAL;
 
 	if (!oh->class->sysc->sysc_fields) {
-		WARN(1, "omap_hwmod: %s: offset struct for sysconfig not provided in class\n", oh->name);
+		WARN(1, "omap_hwmod: %s: offset struct for sysconfig not provided in class\n",
+		     oh->name);
 		return -EINVAL;
 	}
 
@@ -333,7 +338,8 @@ static int _set_softreset(struct omap_hwmod *oh, u32 *v)
 		return -EINVAL;
 
 	if (!oh->class->sysc->sysc_fields) {
-		WARN(1, "omap_hwmod: %s: offset struct for sysconfig not provided in class\n", oh->name);
+		WARN(1, "omap_hwmod: %s: offset struct for sysconfig not provided in class\n",
+		     oh->name);
 		return -EINVAL;
 	}
 
@@ -368,7 +374,8 @@ static int _set_module_autoidle(struct omap_hwmod *oh, u8 autoidle,
 		return -EINVAL;
 
 	if (!oh->class->sysc->sysc_fields) {
-		WARN(1, "omap_hwmod: %s: offset struct for sysconfig not provided in class\n", oh->name);
+		WARN(1, "omap_hwmod: %s: offset struct for sysconfig not provided in class\n",
+		     oh->name);
 		return -EINVAL;
 	}
 
@@ -397,7 +404,8 @@ static int _enable_wakeup(struct omap_hwmod *oh)
 		return -EINVAL;
 
 	if (!oh->class->sysc->sysc_fields) {
-		WARN(1, "omap_hwmod: %s: offset struct for sysconfig not provided in class\n", oh->name);
+		WARN(1, "omap_hwmod: %s: offset struct for sysconfig not provided in class\n",
+		     oh->name);
 		return -EINVAL;
 	}
 
@@ -430,7 +438,8 @@ static int _disable_wakeup(struct omap_hwmod *oh)
 		return -EINVAL;
 
 	if (!oh->class->sysc->sysc_fields) {
-		WARN(1, "omap_hwmod: %s: offset struct for sysconfig not provided in class\n", oh->name);
+		WARN(1, "omap_hwmod: %s: offset struct for sysconfig not provided in class\n",
+		     oh->name);
 		return -EINVAL;
 	}
 
@@ -1181,8 +1190,8 @@ int _omap_hwmod_enable(struct omap_hwmod *oh)
 	if (oh->_state != _HWMOD_STATE_INITIALIZED &&
 	    oh->_state != _HWMOD_STATE_IDLE &&
 	    oh->_state != _HWMOD_STATE_DISABLED) {
-		WARN(1, "omap_hwmod: %s: enabled state can only be entered "
-		     "from initialized, idle, or disabled state\n", oh->name);
+		WARN(1, "omap_hwmod: %s: enabled state can only be entered from initialized, idle, or disabled state\n",
+		     oh->name);
 		return -EINVAL;
 	}
 
@@ -1233,8 +1242,8 @@ int _omap_hwmod_enable(struct omap_hwmod *oh)
 int _omap_hwmod_idle(struct omap_hwmod *oh)
 {
 	if (oh->_state != _HWMOD_STATE_ENABLED) {
-		WARN(1, "omap_hwmod: %s: idle state can only be entered from "
-		     "enabled state\n", oh->name);
+		WARN(1, "omap_hwmod: %s: idle state can only be entered from enabled state\n",
+		     oh->name);
 		return -EINVAL;
 	}
 
@@ -1263,8 +1272,8 @@ static int _shutdown(struct omap_hwmod *oh)
 {
 	if (oh->_state != _HWMOD_STATE_IDLE &&
 	    oh->_state != _HWMOD_STATE_ENABLED) {
-		WARN(1, "omap_hwmod: %s: disabled state can only be entered "
-		     "from idle, or enabled state\n", oh->name);
+		WARN(1, "omap_hwmod: %s: disabled state can only be entered from idle, or enabled state\n",
+		     oh->name);
 		return -EINVAL;
 	}
 
@@ -1559,8 +1568,8 @@ int omap_hwmod_init(struct omap_hwmod **ohs)
 	while (oh) {
 		if (omap_chip_is(oh->omap_chip)) {
 			r = omap_hwmod_register(oh);
-			WARN(r, "omap_hwmod: %s: omap_hwmod_register returned "
-			     "%d\n", oh->name, r);
+			WARN(r, "omap_hwmod: %s: omap_hwmod_register returned %d\n",
+			     oh->name, r);
 		}
 		oh = *++ohs;
 	}
@@ -1729,8 +1738,8 @@ void omap_hwmod_ocp_barrier(struct omap_hwmod *oh)
 	BUG_ON(!oh);
 
 	if (!oh->class->sysc || !oh->class->sysc->sysc_flags) {
-		WARN(1, "omap_device: %s: OCP barrier impossible due to "
-		      "device configuration\n", oh->name);
+		WARN(1, "omap_device: %s: OCP barrier impossible due to device configuration\n",
+		     oh->name);
 		return;
 	}
 
diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index ab0d57b..cc26651 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -283,12 +283,11 @@ static irqreturn_t prcm_interrupt_handler (int irq, void *dev_id)
 			 * Is the MPU PRCM interrupt handler racing with the
 			 * IVA2 PRCM interrupt handler ?
 			 */
-			WARN(c == 0, "prcm: WARNING: PRCM indicated MPU wakeup "
-			     "but no wakeup sources are marked\n");
+			WARN(c == 0, "prcm: WARNING: PRCM indicated MPU wakeup but no wakeup sources are marked\n");
 		} else {
 			/* XXX we need to expand our PRCM interrupt handler */
-			WARN(1, "prcm: WARNING: PRCM interrupt received, but "
-			     "no code to handle it (%08x)\n", irqstatus_mpu);
+			WARN(1, "prcm: WARNING: PRCM interrupt received, but no code to handle it (%08x)\n",
+			     irqstatus_mpu);
 		}
 
 		prm_write_mod_reg(irqstatus_mpu, OCP_MOD,
diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
index 2282822..19a109d 100644
--- a/arch/arm/mach-omap2/serial.c
+++ b/arch/arm/mach-omap2/serial.c
@@ -800,7 +800,7 @@ void __init omap_serial_init_port(int port)
 	od = omap_device_build(name, uart->num, oh, pdata, pdata_size,
 			       omap_uart_latency,
 			       ARRAY_SIZE(omap_uart_latency), false);
-	WARN(IS_ERR(od), "Could not build omap_device for %s: %s.\n",
+	WARN(IS_ERR(od), "Could not build omap_device for %s: %s\n",
 	     name, oh->name);
 
 	uart->irq = oh->mpu_irqs[0].irq;
diff --git a/arch/arm/mach-omap2/timer-gp.c b/arch/arm/mach-omap2/timer-gp.c
index f9052e1..24850bc 100644
--- a/arch/arm/mach-omap2/timer-gp.c
+++ b/arch/arm/mach-omap2/timer-gp.c
@@ -141,8 +141,7 @@ static void __init omap2_gp_clockevent_init(void)
 	src = OMAP_TIMER_SRC_32_KHZ;
 #else
 	src = OMAP_TIMER_SRC_SYS_CLK;
-	WARN(gptimer_id == 12, "WARNING: GPTIMER12 can only use the "
-	     "secure 32KiHz clock source\n");
+	WARN(gptimer_id == 12, "WARNING: GPTIMER12 can only use the secure 32KiHz clock source\n");
 #endif
 
 	if (gptimer_id != 12)
diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
index 77948e0..6d42369 100644
--- a/arch/arm/mach-tegra/clock.c
+++ b/arch/arm/mach-tegra/clock.c
@@ -249,7 +249,8 @@ void clk_disable_locked(struct clk *c)
 {
 	pr_debug("%s: %s\n", __func__, c->name);
 	if (c->refcnt == 0) {
-		WARN(1, "Attempting to disable clock %s with refcnt 0", c->name);
+		WARN(1, "Attempting to disable clock %s with refcnt 0\n",
+		     c->name);
 		return;
 	}
 	if (c->refcnt == 1) {
diff --git a/arch/arm/mach-tegra/timer.c b/arch/arm/mach-tegra/timer.c
index b49f2f5..637171d 100644
--- a/arch/arm/mach-tegra/timer.c
+++ b/arch/arm/mach-tegra/timer.c
@@ -154,7 +154,7 @@ static void __init tegra_init_timer(void)
 		timer_writel(0x0019, TIMERUS_USEC_CFG);
 		break;
 	default:
-		WARN(1, "Unknown clock rate");
+		WARN(1, "Unknown clock rate\n");
 	}
 
 	if (clocksource_register_hz(&tegra_clocksource, 1000000)) {
diff --git a/arch/arm/mach-u300/padmux.c b/arch/arm/mach-u300/padmux.c
index 4c93c6c..b51b889 100644
--- a/arch/arm/mach-u300/padmux.c
+++ b/arch/arm/mach-u300/padmux.c
@@ -120,8 +120,7 @@ struct pmx *pmx_get(struct device *dev, enum pmx_settings setting)
 		if (setting == pmx_settings[i]->setting) {
 
 			if (pmx_settings[i]->dev != NULL) {
-				WARN(1, "padmux: required setting "
-				     "in use by another consumer\n");
+				WARN(1, "padmux: required setting in use by another consumer\n");
 			} else {
 				pmx = pmx_settings[i];
 				pmx->dev = dev;
@@ -152,8 +151,7 @@ int pmx_put(struct device *dev, struct pmx *pmx)
 		if (pmx->setting == pmx_settings[i]->setting) {
 
 			if (dev != pmx->dev) {
-				WARN(1, "padmux: cannot release handle as "
-					"it is bound to another consumer\n");
+				WARN(1, "padmux: cannot release handle as it is bound to another consumer\n");
 				ret = -EINVAL;
 				break;
 			} else {
@@ -190,9 +188,7 @@ int pmx_activate(struct device *dev, struct pmx *pmx)
 			if (pmx_settings[i]->onmask[j].mask & pmx->
 				onmask[j].mask) {
 				/* More than one entry on the same bits */
-				WARN(1, "padmux: cannot activate "
-					"setting. Bit conflict with "
-					"an active setting\n");
+				WARN(1, "padmux: cannot activate setting. Bit conflict with an active setting\n");
 
 				ret = -EUSERS;
 				goto exit;
@@ -227,9 +223,7 @@ int pmx_deactivate(struct device *dev, struct pmx *pmx)
 		if (pmx->setting == pmx_settings[i]->setting) {
 
 			if (dev != pmx->dev) {
-				WARN(1, "padmux: cannot deactivate "
-				     "pmx setting as it was activated "
-				     "by another consumer\n");
+				WARN(1, "padmux: cannot deactivate pmx setting as it was activated by another consumer\n");
 
 				ret = -EBUSY;
 				continue;
diff --git a/arch/arm/plat-omap/omap-pm-noop.c b/arch/arm/plat-omap/omap-pm-noop.c
index e129ce8..94e82b5 100644
--- a/arch/arm/plat-omap/omap-pm-noop.c
+++ b/arch/arm/plat-omap/omap-pm-noop.c
@@ -37,7 +37,7 @@ struct omap_opp *l3_opps;
 int omap_pm_set_max_mpu_wakeup_lat(struct device *dev, long t)
 {
 	if (!dev || t < -1) {
-		WARN(1, "OMAP PM: %s: invalid parameter(s)", __func__);
+		WARN(1, "OMAP PM: %s: invalid parameter(s)\n", __func__);
 		return -EINVAL;
 	};
 
@@ -66,7 +66,7 @@ int omap_pm_set_min_bus_tput(struct device *dev, u8 agent_id, unsigned long r)
 {
 	if (!dev || (agent_id != OCP_INITIATOR_AGENT &&
 	    agent_id != OCP_TARGET_AGENT)) {
-		WARN(1, "OMAP PM: %s: invalid parameter(s)", __func__);
+		WARN(1, "OMAP PM: %s: invalid parameter(s)\n", __func__);
 		return -EINVAL;
 	};
 
@@ -93,7 +93,7 @@ int omap_pm_set_max_dev_wakeup_lat(struct device *req_dev, struct device *dev,
 				   long t)
 {
 	if (!req_dev || !dev || t < -1) {
-		WARN(1, "OMAP PM: %s: invalid parameter(s)", __func__);
+		WARN(1, "OMAP PM: %s: invalid parameter(s)\n", __func__);
 		return -EINVAL;
 	};
 
@@ -123,7 +123,7 @@ int omap_pm_set_max_dev_wakeup_lat(struct device *req_dev, struct device *dev,
 int omap_pm_set_max_sdma_lat(struct device *dev, long t)
 {
 	if (!dev || t < -1) {
-		WARN(1, "OMAP PM: %s: invalid parameter(s)", __func__);
+		WARN(1, "OMAP PM: %s: invalid parameter(s)\n", __func__);
 		return -EINVAL;
 	};
 
@@ -152,7 +152,7 @@ int omap_pm_set_max_sdma_lat(struct device *dev, long t)
 int omap_pm_set_min_clk_rate(struct device *dev, struct clk *c, long r)
 {
 	if (!dev || !c || r < 0) {
-		WARN(1, "OMAP PM: %s: invalid parameter(s)", __func__);
+		WARN(1, "OMAP PM: %s: invalid parameter(s)\n", __func__);
 		return -EINVAL;
 	}
 
-- 
1.7.3.2.245.g03276.dirty

