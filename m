Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab3AIQV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:21:57 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42898 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3AIQV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:21:56 -0500
Date: Wed, 9 Jan 2013 16:21:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] Proposed removal of IS_ERR_OR_NULL() (was: Re: [PATCH
	1/4] gpiolib: introduce descriptor-based GPIO interface)
Message-ID: <20130109162145.GO3931@n2100.arm.linux.org.uk>
References: <201301081259.29839.arnd@arndb.de> <CAAVeFu+4VbCbj9TaeMm+NMDJ9_M4-j4O0ONF7Yh_un63wS38+Q@mail.gmail.com> <201301091035.23206.arnd@arndb.de> <20130109104414.GF3931@n2100.arm.linux.org.uk> <20130109111055.GG3931@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1301090932400.6300@xanadu.home> <20130109150427.GL3931@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1301091020580.6300@xanadu.home> <20130109155154.GN3931@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1301091058070.6300@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1301091058070.6300@xanadu.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 11:09:23AM -0500, Nicolas Pitre wrote:
> On Wed, 9 Jan 2013, Russell King - ARM Linux wrote:
> 
> > On Wed, Jan 09, 2013 at 10:27:53AM -0500, Nicolas Pitre wrote:
> > > Anyone with good coccinelle skills around to deal with the users?
> > 
> > I'm not sure that's a solution.
> 
> Well, I was thinking that coccinelle could handle the majority of the 
> 354 users when the "fix" is obvious enough to be automated.
> 
> That said, if we want people to fix their code, it is probably necessary 
> to merge your patch right away so the warnings are actually being seen, 
> and revert it right before the final v3.8 release if the remaining 
> warnings are still too numerous.  Repeat with next cycle.

Well, this is what I currently have for arch/arm thus far, and ooh look,
we save some lines of code too.

 arch/arm/mach-integrator/integrator_ap.c |    4 +---
 arch/arm/mach-integrator/integrator_cp.c |    5 +----
 arch/arm/mach-omap2/omap_device.c        |   11 ++++-------
 arch/arm/mach-omap2/pm-debug.c           |    6 +++---
 arch/arm/mach-omap2/powerdomain.c        |    2 +-
 arch/arm/mach-tegra/board-harmony-pcie.c |    6 +++---
 arch/arm/mach-tegra/tegra2_emc.c         |    2 +-
 arch/arm/mach-ux500/cpu.c                |    3 +--
 arch/arm/plat-omap/dmtimer.c             |    4 ++--
 9 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mach-integrator/integrator_ap.c b/arch/arm/mach-integrator/integrator_ap.c
index 11e2a41..251f54f 100644
--- a/arch/arm/mach-integrator/integrator_ap.c
+++ b/arch/arm/mach-integrator/integrator_ap.c
@@ -547,9 +547,7 @@ static void __init ap_init_of(void)
 	}
 
 	parent = soc_device_to_device(soc_dev);
-
-	if (!IS_ERR_OR_NULL(parent))
-		integrator_init_sysfs(parent, ap_sc_id);
+	integrator_init_sysfs(parent, ap_sc_id);
 
 	of_platform_populate(root, of_default_bus_match_table,
 			ap_auxdata_lookup, parent);
diff --git a/arch/arm/mach-integrator/integrator_cp.c b/arch/arm/mach-integrator/integrator_cp.c
index 7322838..3fadadf 100644
--- a/arch/arm/mach-integrator/integrator_cp.c
+++ b/arch/arm/mach-integrator/integrator_cp.c
@@ -371,10 +371,7 @@ static void __init intcp_init_of(void)
 	}
 
 	parent = soc_device_to_device(soc_dev);
-
-	if (!IS_ERR_OR_NULL(parent))
-		integrator_init_sysfs(parent, intcp_sc_id);
-
+	integrator_init_sysfs(parent, intcp_sc_id);
 	of_platform_populate(root, of_default_bus_match_table,
 			intcp_auxdata_lookup, parent);
 }
diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
index e065daa..fabb32d 100644
--- a/arch/arm/mach-omap2/omap_device.c
+++ b/arch/arm/mach-omap2/omap_device.c
@@ -1157,20 +1157,17 @@ struct device *omap_device_get_by_hwmod_name(const char *oh_name)
 	}
 
 	oh = omap_hwmod_lookup(oh_name);
-	if (IS_ERR_OR_NULL(oh)) {
+	if (!oh) {
 		WARN(1, "%s: no hwmod for %s\n", __func__,
 			oh_name);
-		return ERR_PTR(oh ? PTR_ERR(oh) : -ENODEV);
+		return -ENODEV;
 	}
-	if (IS_ERR_OR_NULL(oh->od)) {
+	if (!oh->od) {
 		WARN(1, "%s: no omap_device for %s\n", __func__,
 			oh_name);
-		return ERR_PTR(oh->od ? PTR_ERR(oh->od) : -ENODEV);
+		return -ENODEV;
 	}
 
-	if (IS_ERR_OR_NULL(oh->od->pdev))
-		return ERR_PTR(oh->od->pdev ? PTR_ERR(oh->od->pdev) : -ENODEV);
-
 	return &oh->od->pdev->dev;
 }
 EXPORT_SYMBOL(omap_device_get_by_hwmod_name);
diff --git a/arch/arm/mach-omap2/pm-debug.c b/arch/arm/mach-omap2/pm-debug.c
index e2c291f..548547e 100644
--- a/arch/arm/mach-omap2/pm-debug.c
+++ b/arch/arm/mach-omap2/pm-debug.c
@@ -219,7 +219,7 @@ static int __init pwrdms_setup(struct powerdomain *pwrdm, void *dir)
 		return 0;
 
 	d = debugfs_create_dir(pwrdm->name, (struct dentry *)dir);
-	if (!(IS_ERR_OR_NULL(d)))
+	if (d)
 		(void) debugfs_create_file("suspend", S_IRUGO|S_IWUSR, d,
 			(void *)pwrdm, &pwrdm_suspend_fops);
 
@@ -263,8 +263,8 @@ static int __init pm_dbg_init(void)
 		return 0;
 
 	d = debugfs_create_dir("pm_debug", NULL);
-	if (IS_ERR_OR_NULL(d))
-		return PTR_ERR(d);
+	if (!d)
+		return -EINVAL;
 
 	(void) debugfs_create_file("count", S_IRUGO,
 		d, (void *)DEBUG_FILE_COUNTERS, &debug_fops);
diff --git a/arch/arm/mach-omap2/powerdomain.c b/arch/arm/mach-omap2/powerdomain.c
index dea62a9..36a6918 100644
--- a/arch/arm/mach-omap2/powerdomain.c
+++ b/arch/arm/mach-omap2/powerdomain.c
@@ -1054,7 +1054,7 @@ bool pwrdm_can_ever_lose_context(struct powerdomain *pwrdm)
 {
 	int i;
 
-	if (IS_ERR_OR_NULL(pwrdm)) {
+	if (!pwrdm) {
 		pr_debug("powerdomain: %s: invalid powerdomain pointer\n",
 			 __func__);
 		return 1;
diff --git a/arch/arm/mach-tegra/board-harmony-pcie.c b/arch/arm/mach-tegra/board-harmony-pcie.c
index 3cdc1bb..6d29e6a 100644
--- a/arch/arm/mach-tegra/board-harmony-pcie.c
+++ b/arch/arm/mach-tegra/board-harmony-pcie.c
@@ -56,9 +56,9 @@ int __init harmony_pcie_init(void)
 	gpio_direction_output(en_vdd_1v05, 1);
 
 	regulator = regulator_get(NULL, "vdd_ldo0,vddio_pex_clk");
-	if (IS_ERR_OR_NULL(regulator)) {
-		pr_err("%s: regulator_get failed: %d\n", __func__,
-		       (int)PTR_ERR(regulator));
+	if (IS_ERR(regulator)) {
+		err = PTR_ERR(regulator);
+		pr_err("%s: regulator_get failed: %d\n", __func__, err);
 		goto err_reg;
 	}
 
diff --git a/arch/arm/mach-tegra/tegra2_emc.c b/arch/arm/mach-tegra/tegra2_emc.c
index 837c7b9..844c8d2 100644
--- a/arch/arm/mach-tegra/tegra2_emc.c
+++ b/arch/arm/mach-tegra/tegra2_emc.c
@@ -276,7 +276,7 @@ static struct tegra_emc_pdata __devinit *tegra_emc_fill_pdata(struct platform_de
 	int i;
 
 	WARN_ON(pdev->dev.platform_data);
-	BUG_ON(IS_ERR_OR_NULL(c));
+	BUG_ON(IS_ERR(c));
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	pdata->tables = devm_kzalloc(&pdev->dev, sizeof(*pdata->tables),
diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index 721e7b4..e31c2b4 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -151,8 +151,7 @@ struct device * __init ux500_soc_device_init(const char *soc_id)
 	}
 
 	parent = soc_device_to_device(soc_dev);
-	if (!IS_ERR_OR_NULL(parent))
-		device_create_file(parent, &ux500_soc_attr);
+	device_create_file(parent, &ux500_soc_attr);
 
 	return parent;
 }
diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index d51b75b..c654bb8 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -140,7 +140,7 @@ static int omap_dm_timer_prepare(struct omap_dm_timer *timer)
 	 */
 	if (!(timer->capability & OMAP_TIMER_NEEDS_RESET)) {
 		timer->fclk = clk_get(&timer->pdev->dev, "fck");
-		if (WARN_ON_ONCE(IS_ERR_OR_NULL(timer->fclk))) {
+		if (WARN_ON_ONCE(IS_ERR(timer->fclk))) {
 			timer->fclk = NULL;
 			dev_err(&timer->pdev->dev, ": No fclk handle.\n");
 			return -EINVAL;
@@ -500,7 +500,7 @@ int omap_dm_timer_set_source(struct omap_dm_timer *timer, int source)
 	}
 
 	parent = clk_get(&timer->pdev->dev, parent_name);
-	if (IS_ERR_OR_NULL(parent)) {
+	if (IS_ERR(parent)) {
 		pr_err("%s: %s not found\n", __func__, parent_name);
 		return -EINVAL;
 	}

