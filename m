Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab0KGNKO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 08:10:14 -0500
Received: from nm19.bullet.mail.ukl.yahoo.com ([217.146.183.193]:26065 "HELO
	nm19.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752675Ab0KGNKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 08:10:11 -0500
X-Yahoo-Newman-Id: 792636.25366.bm@omp1022.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=DKIM-Signature:Message-ID:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Cc:Subject;
  b=2Zpav0yp1rWkwrzvqP7kiG7abMzpuHKG0lfPdhXrwc15fhZLDUmiCloKW5/xXECcacMKoI7tG3C69LfTmsT51Xr3nak5YxSbuJ4HKufHilFzF9xNPE8130Tnvcp0AxmkWvsh91GugJRT7gF2N4yLSnfJX6oLDqr2ZclE1XJRrCk=  ;
Message-ID: <731625.98342.qm@smtp146.mail.ukl.yahoo.com>
X-Yahoo-SMTP: zgdcvJ6swBBcTOk5fgveL37ak9AQxYCP7GdO
X-YMail-OSG: YZ1ANjIVM1lyXGMUZBFxcXEFQRejFT6R.aj_lIJBO2yeXy6
 emG.c9PxZfeTHV5l9upBhmC0fby4OQbL8.rBzhEc91RI7pQzihJXG50BOo7Y
 PHjmB6pAK7FTh5D4.pRgen0iXvMq_q4CBoS2kEX8ijWAT4TI9ZR88glEXEHc
 zTTR1JfnSBVUTjc.8IPfxsZ0nuROVrz71Xc4GlM7wtg4rwfyTWDvlbEvy1QE
 8nmdrn_jLHH3B78WeDl7r.FuAL0X.9U9fYB9gfDUuiab9ViXdViu2K.2Ba1a
 j7O7hE8_QSS4rU4IEPwdKj1gZ.RUS8seovCrGjh_5w5wF_dgK0jg4HLrdDkn
 rN5ZgWjaA
X-Yahoo-Newman-Property: ymail-3
Date: Sun, 07 Nov 2010 14:10:13 +0100
From: Lionel Debroux <lionel_debroux@yahoo.fr>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] suspend: constify platform_suspend_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it, fix two checkpatch errors.

Patch against mainline.

---

Subject: [PATCH] suspend: constify platform_suspend_ops

Inspired by hunks of the grsecurity patch, updated for newer kernels.
Even though platform_suspend_ops is already part of the list of "should be
const" operations structures of 2.6.35 checkpatch.pl, several non-const
struct instances constified by this patch have been added after 2.6.35.

Signed-off-by: Lionel Debroux <lionel_debroux@yahoo.fr>
---
 arch/arm/mach-at91/pm.c                   |    2 +-
 arch/arm/mach-davinci/pm.c                |    2 +-
 arch/arm/mach-imx/pm-imx27.c              |    2 +-
 arch/arm/mach-lpc32xx/pm.c                |    2 +-
 arch/arm/mach-omap1/pm.c                  |    2 +-
 arch/arm/mach-omap2/pm24xx.c              |    2 +-
 arch/arm/mach-omap2/pm34xx.c              |    2 +-
 arch/arm/mach-omap2/pm44xx.c              |    2 +-
 arch/arm/mach-pnx4008/pm.c                |    2 +-
 arch/arm/mach-pxa/pm.c                    |    2 +-
 arch/arm/mach-pxa/sharpsl_pm.c            |    2 +-
 arch/arm/mach-sa1100/pm.c                 |    2 +-
 arch/arm/plat-samsung/pm.c                |    2 +-
 arch/avr32/mach-at32ap/pm.c               |    2 +-
 arch/blackfin/mach-common/pm.c            |    2 +-
 arch/mips/alchemy/devboards/pm.c          |    2 +-
 arch/mips/jz4740/pm.c                     |    2 +-
 arch/mips/loongson/common/pm.c            |    2 +-
 arch/powerpc/platforms/52xx/lite5200_pm.c |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_pm.c  |    2 +-
 arch/powerpc/platforms/83xx/suspend.c     |    2 +-
 arch/powerpc/platforms/pseries/suspend.c  |    2 +-
 arch/powerpc/sysdev/fsl_pmc.c             |    2 +-
 arch/sh/boards/mach-hp6xx/pm.c            |    2 +-
 arch/sh/kernel/cpu/shmobile/pm.c          |    2 +-
 arch/sh/kernel/dma-nommu.c                |    2 +-
 drivers/acpi/sleep.c                      |    4 ++--
 drivers/macintosh/via-pmu.c               |    2 +-
 include/linux/suspend.h                   |   22 +++++++++++-----------
 kernel/power/hibernate.c                  |    4 ++--
 kernel/power/suspend.c                    |    4 ++--
 31 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index dafbacc..ea53f4d 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -301,7 +301,7 @@ static void at91_pm_end(void)
 }
 
 
-static struct platform_suspend_ops at91_pm_ops ={
+static const struct platform_suspend_ops at91_pm_ops = {
 	.valid	= at91_pm_valid_state,
 	.begin	= at91_pm_begin,
 	.enter	= at91_pm_enter,
diff --git a/arch/arm/mach-davinci/pm.c b/arch/arm/mach-davinci/pm.c
index fab953b..1bd73a0 100644
--- a/arch/arm/mach-davinci/pm.c
+++ b/arch/arm/mach-davinci/pm.c
@@ -110,7 +110,7 @@ static int davinci_pm_enter(suspend_state_t state)
 	return ret;
 }
 
-static struct platform_suspend_ops davinci_pm_ops = {
+static const struct platform_suspend_ops davinci_pm_ops = {
 	.enter		= davinci_pm_enter,
 	.valid		= suspend_valid_only_mem,
 };
diff --git a/arch/arm/mach-imx/pm-imx27.c b/arch/arm/mach-imx/pm-imx27.c
index afc17ce..2153ca7 100644
--- a/arch/arm/mach-imx/pm-imx27.c
+++ b/arch/arm/mach-imx/pm-imx27.c
@@ -32,7 +32,7 @@ static int mx27_suspend_enter(suspend_state_t state)
 	return 0;
 }
 
-static struct platform_suspend_ops mx27_suspend_ops = {
+static const struct platform_suspend_ops mx27_suspend_ops = {
 	.enter = mx27_suspend_enter,
 	.valid = suspend_valid_only_mem,
 };
diff --git a/arch/arm/mach-lpc32xx/pm.c b/arch/arm/mach-lpc32xx/pm.c
index a6e2aed..e76d41b 100644
--- a/arch/arm/mach-lpc32xx/pm.c
+++ b/arch/arm/mach-lpc32xx/pm.c
@@ -123,7 +123,7 @@ static int lpc32xx_pm_enter(suspend_state_t state)
 	return 0;
 }
 
-static struct platform_suspend_ops lpc32xx_pm_ops = {
+static const struct platform_suspend_ops lpc32xx_pm_ops = {
 	.valid	= suspend_valid_only_mem,
 	.enter	= lpc32xx_pm_enter,
 };
diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index b1d3f9f..4cf3b67 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -647,7 +647,7 @@ static struct irqaction omap_wakeup_irq = {
 
 
 
-static struct platform_suspend_ops omap_pm_ops ={
+static const struct platform_suspend_ops omap_pm_ops = {
 	.prepare	= omap_pm_prepare,
 	.enter		= omap_pm_enter,
 	.finish		= omap_pm_finish,
diff --git a/arch/arm/mach-omap2/pm24xx.c b/arch/arm/mach-omap2/pm24xx.c
index a40457d..aa9764e 100644
--- a/arch/arm/mach-omap2/pm24xx.c
+++ b/arch/arm/mach-omap2/pm24xx.c
@@ -326,7 +326,7 @@ static void omap2_pm_finish(void)
 	enable_hlt();
 }
 
-static struct platform_suspend_ops omap_pm_ops = {
+static const struct platform_suspend_ops omap_pm_ops = {
 	.prepare	= omap2_pm_prepare,
 	.enter		= omap2_pm_enter,
 	.finish		= omap2_pm_finish,
diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index 75c0cd1..4000c3c 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -594,7 +594,7 @@ static void omap3_pm_end(void)
 	return;
 }
 
-static struct platform_suspend_ops omap_pm_ops = {
+static const struct platform_suspend_ops omap_pm_ops = {
 	.begin		= omap3_pm_begin,
 	.end		= omap3_pm_end,
 	.prepare	= omap3_pm_prepare,
diff --git a/arch/arm/mach-omap2/pm44xx.c b/arch/arm/mach-omap2/pm44xx.c
index 54544b4..dc8b1ef 100644
--- a/arch/arm/mach-omap2/pm44xx.c
+++ b/arch/arm/mach-omap2/pm44xx.c
@@ -75,7 +75,7 @@ static void omap4_pm_end(void)
 	return;
 }
 
-static struct platform_suspend_ops omap_pm_ops = {
+static const struct platform_suspend_ops omap_pm_ops = {
 	.begin		= omap4_pm_begin,
 	.end		= omap4_pm_end,
 	.prepare	= omap4_pm_prepare,
diff --git a/arch/arm/mach-pnx4008/pm.c b/arch/arm/mach-pnx4008/pm.c
index ee3c29c..f3e60a0 100644
--- a/arch/arm/mach-pnx4008/pm.c
+++ b/arch/arm/mach-pnx4008/pm.c
@@ -119,7 +119,7 @@ static int pnx4008_pm_valid(suspend_state_t state)
 	       (state == PM_SUSPEND_MEM);
 }
 
-static struct platform_suspend_ops pnx4008_pm_ops = {
+static const struct platform_suspend_ops pnx4008_pm_ops = {
 	.enter = pnx4008_pm_enter,
 	.valid = pnx4008_pm_valid,
 };
diff --git a/arch/arm/mach-pxa/pm.c b/arch/arm/mach-pxa/pm.c
index 166c15f..978e1b2 100644
--- a/arch/arm/mach-pxa/pm.c
+++ b/arch/arm/mach-pxa/pm.c
@@ -96,7 +96,7 @@ void pxa_pm_finish(void)
 		pxa_cpu_pm_fns->finish();
 }
 
-static struct platform_suspend_ops pxa_pm_ops = {
+static const struct platform_suspend_ops pxa_pm_ops = {
 	.valid		= pxa_pm_valid,
 	.enter		= pxa_pm_enter,
 	.prepare	= pxa_pm_prepare,
diff --git a/arch/arm/mach-pxa/sharpsl_pm.c b/arch/arm/mach-pxa/sharpsl_pm.c
index 8fed027..02874e9 100644
--- a/arch/arm/mach-pxa/sharpsl_pm.c
+++ b/arch/arm/mach-pxa/sharpsl_pm.c
@@ -868,7 +868,7 @@ static void sharpsl_apm_get_power_status(struct apm_power_info *info)
 }
 
 #ifdef CONFIG_PM
-static struct platform_suspend_ops sharpsl_pm_ops = {
+static const struct platform_suspend_ops sharpsl_pm_ops = {
 	.prepare	= pxa_pm_prepare,
 	.finish		= pxa_pm_finish,
 	.enter		= corgi_pxa_pm_enter,
diff --git a/arch/arm/mach-sa1100/pm.c b/arch/arm/mach-sa1100/pm.c
index c83fdc8..ab9fc44 100644
--- a/arch/arm/mach-sa1100/pm.c
+++ b/arch/arm/mach-sa1100/pm.c
@@ -120,7 +120,7 @@ unsigned long sleep_phys_sp(void *sp)
 	return virt_to_phys(sp);
 }
 
-static struct platform_suspend_ops sa11x0_pm_ops = {
+static const struct platform_suspend_ops sa11x0_pm_ops = {
 	.enter		= sa11x0_pm_enter,
 	.valid		= suspend_valid_only_mem,
 };
diff --git a/arch/arm/plat-samsung/pm.c b/arch/arm/plat-samsung/pm.c
index 27cfca5..5bf3f2f 100644
--- a/arch/arm/plat-samsung/pm.c
+++ b/arch/arm/plat-samsung/pm.c
@@ -355,7 +355,7 @@ static void s3c_pm_finish(void)
 	s3c_pm_check_cleanup();
 }
 
-static struct platform_suspend_ops s3c_pm_ops = {
+static const struct platform_suspend_ops s3c_pm_ops = {
 	.enter		= s3c_pm_enter,
 	.prepare	= s3c_pm_prepare,
 	.finish		= s3c_pm_finish,
diff --git a/arch/avr32/mach-at32ap/pm.c b/arch/avr32/mach-at32ap/pm.c
index f021edf..32d680e 100644
--- a/arch/avr32/mach-at32ap/pm.c
+++ b/arch/avr32/mach-at32ap/pm.c
@@ -176,7 +176,7 @@ out:
 	return 0;
 }
 
-static struct platform_suspend_ops avr32_pm_ops = {
+static const struct platform_suspend_ops avr32_pm_ops = {
 	.valid	= avr32_pm_valid_state,
 	.enter	= avr32_pm_enter,
 };
diff --git a/arch/blackfin/mach-common/pm.c b/arch/blackfin/mach-common/pm.c
index 80884b1..745af2d 100644
--- a/arch/blackfin/mach-common/pm.c
+++ b/arch/blackfin/mach-common/pm.c
@@ -233,7 +233,7 @@ static int bfin_pm_enter(suspend_state_t state)
 	return 0;
 }
 
-struct platform_suspend_ops bfin_pm_ops = {
+static const struct platform_suspend_ops bfin_pm_ops = {
 	.enter = bfin_pm_enter,
 	.valid	= bfin_pm_valid,
 };
diff --git a/arch/mips/alchemy/devboards/pm.c b/arch/mips/alchemy/devboards/pm.c
index 4bbd313..acaf91b 100644
--- a/arch/mips/alchemy/devboards/pm.c
+++ b/arch/mips/alchemy/devboards/pm.c
@@ -110,7 +110,7 @@ static void db1x_pm_end(void)
 
 }
 
-static struct platform_suspend_ops db1x_pm_ops = {
+static const struct platform_suspend_ops db1x_pm_ops = {
 	.valid		= suspend_valid_only_mem,
 	.begin		= db1x_pm_begin,
 	.enter		= db1x_pm_enter,
diff --git a/arch/mips/jz4740/pm.c b/arch/mips/jz4740/pm.c
index a999458..902d5b5 100644
--- a/arch/mips/jz4740/pm.c
+++ b/arch/mips/jz4740/pm.c
@@ -42,7 +42,7 @@ static int jz4740_pm_enter(suspend_state_t state)
 	return 0;
 }
 
-static struct platform_suspend_ops jz4740_pm_ops = {
+static const struct platform_suspend_ops jz4740_pm_ops = {
 	.valid		= suspend_valid_only_mem,
 	.enter		= jz4740_pm_enter,
 };
diff --git a/arch/mips/loongson/common/pm.c b/arch/mips/loongson/common/pm.c
index 6c1fd90..f55e07a 100644
--- a/arch/mips/loongson/common/pm.c
+++ b/arch/mips/loongson/common/pm.c
@@ -147,7 +147,7 @@ static int loongson_pm_valid_state(suspend_state_t state)
 	}
 }
 
-static struct platform_suspend_ops loongson_pm_ops = {
+static const struct platform_suspend_ops loongson_pm_ops = {
 	.valid	= loongson_pm_valid_state,
 	.enter	= loongson_pm_enter,
 };
diff --git a/arch/powerpc/platforms/52xx/lite5200_pm.c b/arch/powerpc/platforms/52xx/lite5200_pm.c
index 80234e5..eda0fc2 100644
--- a/arch/powerpc/platforms/52xx/lite5200_pm.c
+++ b/arch/powerpc/platforms/52xx/lite5200_pm.c
@@ -232,7 +232,7 @@ static void lite5200_pm_end(void)
 	lite5200_pm_target_state = PM_SUSPEND_ON;
 }
 
-static struct platform_suspend_ops lite5200_pm_ops = {
+static const struct platform_suspend_ops lite5200_pm_ops = {
 	.valid		= lite5200_pm_valid,
 	.begin		= lite5200_pm_begin,
 	.prepare	= lite5200_pm_prepare,
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pm.c b/arch/powerpc/platforms/52xx/mpc52xx_pm.c
index 568cef6..8310e8b 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pm.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pm.c
@@ -186,7 +186,7 @@ void mpc52xx_pm_finish(void)
 	iounmap(mbar);
 }
 
-static struct platform_suspend_ops mpc52xx_pm_ops = {
+static const struct platform_suspend_ops mpc52xx_pm_ops = {
 	.valid		= mpc52xx_pm_valid,
 	.prepare	= mpc52xx_pm_prepare,
 	.enter		= mpc52xx_pm_enter,
diff --git a/arch/powerpc/platforms/83xx/suspend.c b/arch/powerpc/platforms/83xx/suspend.c
index 75ae77f..fd4f2f2 100644
--- a/arch/powerpc/platforms/83xx/suspend.c
+++ b/arch/powerpc/platforms/83xx/suspend.c
@@ -311,7 +311,7 @@ static int mpc83xx_is_pci_agent(void)
 	return ret;
 }
 
-static struct platform_suspend_ops mpc83xx_suspend_ops = {
+static const struct platform_suspend_ops mpc83xx_suspend_ops = {
 	.valid = mpc83xx_suspend_valid,
 	.begin = mpc83xx_suspend_begin,
 	.enter = mpc83xx_suspend_enter,
diff --git a/arch/powerpc/platforms/pseries/suspend.c b/arch/powerpc/platforms/pseries/suspend.c
index ed72098..a8ca289 100644
--- a/arch/powerpc/platforms/pseries/suspend.c
+++ b/arch/powerpc/platforms/pseries/suspend.c
@@ -153,7 +153,7 @@ static struct sysdev_class suspend_sysdev_class = {
 	.name = "power",
 };
 
-static struct platform_suspend_ops pseries_suspend_ops = {
+static const struct platform_suspend_ops pseries_suspend_ops = {
 	.valid		= suspend_valid_only_mem,
 	.begin		= pseries_suspend_begin,
 	.prepare_late	= pseries_prepare_late,
diff --git a/arch/powerpc/sysdev/fsl_pmc.c b/arch/powerpc/sysdev/fsl_pmc.c
index 44de855..e9381bf 100644
--- a/arch/powerpc/sysdev/fsl_pmc.c
+++ b/arch/powerpc/sysdev/fsl_pmc.c
@@ -53,7 +53,7 @@ static int pmc_suspend_valid(suspend_state_t state)
 	return 1;
 }
 
-static struct platform_suspend_ops pmc_suspend_ops = {
+static const struct platform_suspend_ops pmc_suspend_ops = {
 	.valid = pmc_suspend_valid,
 	.enter = pmc_suspend_enter,
 };
diff --git a/arch/sh/boards/mach-hp6xx/pm.c b/arch/sh/boards/mach-hp6xx/pm.c
index 4499a37..adc9b4b 100644
--- a/arch/sh/boards/mach-hp6xx/pm.c
+++ b/arch/sh/boards/mach-hp6xx/pm.c
@@ -143,7 +143,7 @@ static int hp6x0_pm_enter(suspend_state_t state)
 	return 0;
 }
 
-static struct platform_suspend_ops hp6x0_pm_ops = {
+static const struct platform_suspend_ops hp6x0_pm_ops = {
 	.enter		= hp6x0_pm_enter,
 	.valid		= suspend_valid_only_mem,
 };
diff --git a/arch/sh/kernel/cpu/shmobile/pm.c b/arch/sh/kernel/cpu/shmobile/pm.c
index e559687..a6f95ae 100644
--- a/arch/sh/kernel/cpu/shmobile/pm.c
+++ b/arch/sh/kernel/cpu/shmobile/pm.c
@@ -141,7 +141,7 @@ static int sh_pm_enter(suspend_state_t state)
 	return 0;
 }
 
-static struct platform_suspend_ops sh_pm_ops = {
+static const struct platform_suspend_ops sh_pm_ops = {
 	.enter          = sh_pm_enter,
 	.valid          = suspend_valid_only_mem,
 };
diff --git a/arch/sh/kernel/dma-nommu.c b/arch/sh/kernel/dma-nommu.c
index 3c55b87..92ccab3 100644
--- a/arch/sh/kernel/dma-nommu.c
+++ b/arch/sh/kernel/dma-nommu.c
@@ -62,7 +62,7 @@ static void nommu_sync_sg(struct device *dev, struct scatterlist *sg,
 }
 #endif
 
-struct dma_map_ops nommu_dma_ops = {
+const struct dma_map_ops nommu_dma_ops = {
 	.alloc_coherent		= dma_generic_alloc_coherent,
 	.free_coherent		= dma_generic_free_coherent,
 	.map_page		= nommu_map_page,
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 721d93b..acfa8c3 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -319,7 +319,7 @@ static int acpi_suspend_state_valid(suspend_state_t pm_state)
 	}
 }
 
-static struct platform_suspend_ops acpi_suspend_ops = {
+static const struct platform_suspend_ops acpi_suspend_ops = {
 	.valid = acpi_suspend_state_valid,
 	.begin = acpi_suspend_begin,
 	.prepare_late = acpi_pm_prepare,
@@ -347,7 +347,7 @@ static int acpi_suspend_begin_old(suspend_state_t pm_state)
  * The following callbacks are used if the pre-ACPI 2.0 suspend ordering has
  * been requested.
  */
-static struct platform_suspend_ops acpi_suspend_ops_old = {
+static const struct platform_suspend_ops acpi_suspend_ops_old = {
 	.valid = acpi_suspend_state_valid,
 	.begin = acpi_suspend_begin_old,
 	.prepare_late = acpi_pm_pre_suspend,
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index cd29c82..8b021eb 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -2257,7 +2257,7 @@ static int pmu_sleep_valid(suspend_state_t state)
 		&& (pmac_call_feature(PMAC_FTR_SLEEP_STATE, NULL, 0, -1) >= 0);
 }
 
-static struct platform_suspend_ops pmu_pm_ops = {
+static const struct platform_suspend_ops pmu_pm_ops = {
 	.enter = powerbook_sleep,
 	.valid = pmu_sleep_valid,
 };
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 2669751..0fc6088 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -106,15 +106,15 @@ typedef int __bitwise suspend_state_t;
  *	which require special recovery actions in that situation.
  */
 struct platform_suspend_ops {
-	int (*valid)(suspend_state_t state);
-	int (*begin)(suspend_state_t state);
-	int (*prepare)(void);
-	int (*prepare_late)(void);
-	int (*enter)(suspend_state_t state);
-	void (*wake)(void);
-	void (*finish)(void);
-	void (*end)(void);
-	void (*recover)(void);
+	int (* const valid)(suspend_state_t state);
+	int (* const begin)(suspend_state_t state);
+	int (* const prepare)(void);
+	int (* const prepare_late)(void);
+	int (* const enter)(suspend_state_t state);
+	void (* const wake)(void);
+	void (* const finish)(void);
+	void (* const end)(void);
+	void (* const recover)(void);
 };
 
 #ifdef CONFIG_SUSPEND
@@ -122,7 +122,7 @@ struct platform_suspend_ops {
  * suspend_set_ops - set platform dependent suspend operations
  * @ops: The new suspend operations to set.
  */
-extern void suspend_set_ops(struct platform_suspend_ops *ops);
+extern void suspend_set_ops(const struct platform_suspend_ops *ops);
 extern int suspend_valid_only_mem(suspend_state_t state);
 
 /**
@@ -147,7 +147,7 @@ extern int pm_suspend(suspend_state_t state);
 #else /* !CONFIG_SUSPEND */
 #define suspend_valid_only_mem	NULL
 
-static inline void suspend_set_ops(struct platform_suspend_ops *ops) {}
+static inline void suspend_set_ops(const struct platform_suspend_ops *ops) {}
 static inline int pm_suspend(suspend_state_t state) { return -ENOSYS; }
 #endif /* !CONFIG_SUSPEND */
 
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 657272e..491b81a 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -51,14 +51,14 @@ enum {
 
 static int hibernation_mode = HIBERNATION_SHUTDOWN;
 
-static struct platform_hibernation_ops *hibernation_ops;
+static const struct platform_hibernation_ops *hibernation_ops;
 
 /**
  * hibernation_set_ops - set the global hibernate operations
  * @ops: the hibernation operations to use in subsequent hibernation transitions
  */
 
-void hibernation_set_ops(struct platform_hibernation_ops *ops)
+void hibernation_set_ops(const struct platform_hibernation_ops *ops)
 {
 	if (ops && !(ops->begin && ops->end &&  ops->pre_snapshot
 	    && ops->prepare && ops->finish && ops->enter && ops->pre_restore
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 7335952..80051bd 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -30,13 +30,13 @@ const char *const pm_states[PM_SUSPEND_MAX] = {
 	[PM_SUSPEND_MEM]	= "mem",
 };
 
-static struct platform_suspend_ops *suspend_ops;
+static const struct platform_suspend_ops *suspend_ops;
 
 /**
  *	suspend_set_ops - Set the global suspend method table.
  *	@ops:	Pointer to ops structure.
  */
-void suspend_set_ops(struct platform_suspend_ops *ops)
+void suspend_set_ops(const struct platform_suspend_ops *ops)
 {
 	mutex_lock(&pm_mutex);
 	suspend_ops = ops;
-- 
1.7.3.2.161.g3089c


