Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab1JaVLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:11:40 -0400
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:39709
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753552Ab1JaVLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:11:37 -0400
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: [RFC PATCH 01/10] powerpc/85xx: Move mpc85xx_smp_init() decl to a new "smp.h"
Date: Mon, 31 Oct 2011 17:10:02 -0400
Message-Id: <1320095411-20667-2-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1320095411-20667-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1320095411-20667-1-git-send-email-Kyle.D.Moffett@boeing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes a bunch of "extern" declarations and CONFIG_SMP ifdefs.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@kernel.crashing.org>
---
 arch/powerpc/platforms/85xx/corenet_ds.c  |    7 +------
 arch/powerpc/platforms/85xx/mpc85xx_ds.c  |    6 +-----
 arch/powerpc/platforms/85xx/mpc85xx_mds.c |    7 +------
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c |    7 +------
 arch/powerpc/platforms/85xx/p1022_ds.c    |    7 +------
 arch/powerpc/platforms/85xx/p1023_rds.c   |    5 +----
 arch/powerpc/platforms/85xx/smp.c         |    1 +
 arch/powerpc/platforms/85xx/smp.h         |   15 +++++++++++++++
 arch/powerpc/platforms/85xx/xes_mpc85xx.c |    6 +-----
 9 files changed, 23 insertions(+), 38 deletions(-)
 create mode 100644 arch/powerpc/platforms/85xx/smp.h

diff --git a/arch/powerpc/platforms/85xx/corenet_ds.c b/arch/powerpc/platforms/85xx/corenet_ds.c
index 802ad11..435074d 100644
--- a/arch/powerpc/platforms/85xx/corenet_ds.c
+++ b/arch/powerpc/platforms/85xx/corenet_ds.c
@@ -31,6 +31,7 @@
 #include <linux/of_platform.h>
 #include <sysdev/fsl_soc.h>
 #include <sysdev/fsl_pci.h>
+#include "smp.h"
 
 void __init corenet_ds_pic_init(void)
 {
@@ -65,10 +66,6 @@ void __init corenet_ds_pic_init(void)
 /*
  * Setup the architecture
  */
-#ifdef CONFIG_SMP
-void __init mpc85xx_smp_init(void);
-#endif
-
 void __init corenet_ds_setup_arch(void)
 {
 #ifdef CONFIG_PCI
@@ -77,9 +74,7 @@ void __init corenet_ds_setup_arch(void)
 #endif
 	dma_addr_t max = 0xffffffff;
 
-#ifdef CONFIG_SMP
 	mpc85xx_smp_init();
-#endif
 
 #ifdef CONFIG_PCI
 	for_each_node_by_type(np, "pci") {
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ds.c b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
index 1b9a8cf..52d2a3e 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
@@ -35,6 +35,7 @@
 
 #include <sysdev/fsl_soc.h>
 #include <sysdev/fsl_pci.h>
+#include "smp.h"
 
 #undef DEBUG
 
@@ -152,9 +153,6 @@ static int mpc85xx_exclude_device(struct pci_controller *hose,
 /*
  * Setup the architecture
  */
-#ifdef CONFIG_SMP
-extern void __init mpc85xx_smp_init(void);
-#endif
 static void __init mpc85xx_ds_setup_arch(void)
 {
 #ifdef CONFIG_PCI
@@ -187,9 +185,7 @@ static void __init mpc85xx_ds_setup_arch(void)
 	ppc_md.pci_exclude_device = mpc85xx_exclude_device;
 #endif
 
-#ifdef CONFIG_SMP
 	mpc85xx_smp_init();
-#endif
 
 #ifdef CONFIG_SWIOTLB
 	if (memblock_end_of_DRAM() > max) {
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
index 973b3f4..074be05 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
@@ -52,6 +52,7 @@
 #include <asm/qe_ic.h>
 #include <asm/mpic.h>
 #include <asm/swiotlb.h>
+#include "smp.h"
 
 #undef DEBUG
 #ifdef DEBUG
@@ -154,10 +155,6 @@ static int mpc8568_mds_phy_fixups(struct phy_device *phydev)
  * Setup the architecture
  *
  */
-#ifdef CONFIG_SMP
-extern void __init mpc85xx_smp_init(void);
-#endif
-
 #ifdef CONFIG_QUICC_ENGINE
 static struct of_device_id mpc85xx_qe_ids[] __initdata = {
 	{ .type = "qe", },
@@ -382,9 +379,7 @@ static void __init mpc85xx_mds_setup_arch(void)
 	}
 #endif
 
-#ifdef CONFIG_SMP
 	mpc85xx_smp_init();
-#endif
 
 	mpc85xx_mds_qe_init();
 
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
index f5ff911..cd49898 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
@@ -29,6 +29,7 @@
 
 #include <sysdev/fsl_soc.h>
 #include <sysdev/fsl_pci.h>
+#include "smp.h"
 
 #undef DEBUG
 
@@ -82,9 +83,6 @@ void __init mpc85xx_rdb_pic_init(void)
 /*
  * Setup the architecture
  */
-#ifdef CONFIG_SMP
-extern void __init mpc85xx_smp_init(void);
-#endif
 static void __init mpc85xx_rdb_setup_arch(void)
 {
 #ifdef CONFIG_PCI
@@ -102,10 +100,7 @@ static void __init mpc85xx_rdb_setup_arch(void)
 
 #endif
 
-#ifdef CONFIG_SMP
 	mpc85xx_smp_init();
-#endif
-
 	printk(KERN_INFO "MPC85xx RDB board from Freescale Semiconductor\n");
 }
 
diff --git a/arch/powerpc/platforms/85xx/p1022_ds.c b/arch/powerpc/platforms/85xx/p1022_ds.c
index 266b3aa..7e90e24 100644
--- a/arch/powerpc/platforms/85xx/p1022_ds.c
+++ b/arch/powerpc/platforms/85xx/p1022_ds.c
@@ -26,6 +26,7 @@
 #include <sysdev/fsl_soc.h>
 #include <sysdev/fsl_pci.h>
 #include <asm/fsl_guts.h>
+#include "smp.h"
 
 #if defined(CONFIG_FB_FSL_DIU) || defined(CONFIG_FB_FSL_DIU_MODULE)
 
@@ -265,10 +266,6 @@ void __init p1022_ds_pic_init(void)
 	mpic_init(mpic);
 }
 
-#ifdef CONFIG_SMP
-void __init mpc85xx_smp_init(void);
-#endif
-
 /*
  * Setup the architecture
  */
@@ -309,9 +306,7 @@ static void __init p1022_ds_setup_arch(void)
 	diu_ops.set_sysfs_monitor_port	= p1022ds_set_sysfs_monitor_port;
 #endif
 
-#ifdef CONFIG_SMP
 	mpc85xx_smp_init();
-#endif
 
 #ifdef CONFIG_SWIOTLB
 	if (memblock_end_of_DRAM() > max) {
diff --git a/arch/powerpc/platforms/85xx/p1023_rds.c b/arch/powerpc/platforms/85xx/p1023_rds.c
index 835e0b3..5ab21f3 100644
--- a/arch/powerpc/platforms/85xx/p1023_rds.c
+++ b/arch/powerpc/platforms/85xx/p1023_rds.c
@@ -30,6 +30,7 @@
 #include <asm/prom.h>
 #include <asm/udbg.h>
 #include <asm/mpic.h>
+#include "smp.h"
 
 #include <sysdev/fsl_soc.h>
 #include <sysdev/fsl_pci.h>
@@ -39,10 +40,6 @@
  * Setup the architecture
  *
  */
-#ifdef CONFIG_SMP
-void __init mpc85xx_smp_init(void);
-#endif
-
 static void __init mpc85xx_rds_setup_arch(void)
 {
 	struct device_node *np;
diff --git a/arch/powerpc/platforms/85xx/smp.c b/arch/powerpc/platforms/85xx/smp.c
index 5b9b901..4578112 100644
--- a/arch/powerpc/platforms/85xx/smp.c
+++ b/arch/powerpc/platforms/85xx/smp.c
@@ -27,6 +27,7 @@
 
 #include <sysdev/fsl_soc.h>
 #include <sysdev/mpic.h>
+#include "smp.h"
 
 extern void __early_start(void);
 
diff --git a/arch/powerpc/platforms/85xx/smp.h b/arch/powerpc/platforms/85xx/smp.h
new file mode 100644
index 0000000..e2b4493
--- /dev/null
+++ b/arch/powerpc/platforms/85xx/smp.h
@@ -0,0 +1,15 @@
+#ifndef POWERPC_85XX_SMP_H_
+#define POWERPC_85XX_SMP_H_ 1
+
+#include <linux/init.h>
+
+#ifdef CONFIG_SMP
+void __init mpc85xx_smp_init(void);
+#else
+static inline void mpc85xx_smp_init(void)
+{
+	/* Nothing to do */
+}
+#endif
+
+#endif /* not POWERPC_85XX_SMP_H_ */
diff --git a/arch/powerpc/platforms/85xx/xes_mpc85xx.c b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
index a9dc5e7..ce3f660 100644
--- a/arch/powerpc/platforms/85xx/xes_mpc85xx.c
+++ b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
@@ -32,6 +32,7 @@
 
 #include <sysdev/fsl_soc.h>
 #include <sysdev/fsl_pci.h>
+#include "smp.h"
 
 /* A few bit definitions needed for fixups on some boards */
 #define MPC85xx_L2CTL_L2E		0x80000000 /* L2 enable */
@@ -136,9 +137,6 @@ static int primary_phb_addr;
 /*
  * Setup the architecture
  */
-#ifdef CONFIG_SMP
-extern void __init mpc85xx_smp_init(void);
-#endif
 static void __init xes_mpc85xx_setup_arch(void)
 {
 #ifdef CONFIG_PCI
@@ -172,9 +170,7 @@ static void __init xes_mpc85xx_setup_arch(void)
 	}
 #endif
 
-#ifdef CONFIG_SMP
 	mpc85xx_smp_init();
-#endif
 }
 
 static struct of_device_id __initdata xes_mpc85xx_ids[] = {
-- 
1.7.2.5

