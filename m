Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab0EZKUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:20:06 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:41295 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757159Ab0EZKUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:20:01 -0400
Date: Wed, 26 May 2010 12:19:59 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Peter Tyser <ptyser@xes-inc.com>, Dave Jiang <djiang@mvista.com>,
       Yang Shi <yang.shi@windriver.com>, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH] MPC85xx -> FSL_SOC_BOOKE
Message-ID: <20100526101959.GA6744@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

	There was a restructuring of Kconfig in October leafing some
dangling ifdefs behind that aren't referenced any more. I've created a
patch following the pattern used in the restructuring.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

----
>From ac003845a68e37e2fbb1ac5849fb46b8b3100a07 Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@cs.fau.de>
Date: Wed, 26 May 2010 12:13:36 +0200
Subject: Missing pieces from MPC85xx -> FSL_SOC_BOOKE

In 5753c082f66eca5be81f6bda85c1718c5eea6ada menuconfig MPC85xx was
replaced by FSL_SOC_BOOKE but some references insider the code were
not adjusted accordingly. This patch adresses these missing pieces.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 drivers/edac/mpc85xx_edac.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 6c1886b..25e7ea0 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -43,7 +43,7 @@ static u32 orig_pci_err_en;
 #endif
 
 static u32 orig_l2_err_disable;
-#ifdef CONFIG_MPC85xx
+#ifdef CONFIG_FSL_SOC_BOOKE
 static u32 orig_hid1[2];
 #endif
 
@@ -1136,7 +1136,7 @@ static struct of_platform_driver mpc85xx_mc_err_driver = {
 	},
 };
 
-#ifdef CONFIG_MPC85xx
+#ifdef CONFIG_FSL_SOC_BOOKE
 static void __init mpc85xx_mc_clear_rfxe(void *data)
 {
 	orig_hid1[smp_processor_id()] = mfspr(SPRN_HID1);
@@ -1175,7 +1175,7 @@ static int __init mpc85xx_mc_init(void)
 		printk(KERN_WARNING EDAC_MOD_STR "PCI fails to register\n");
 #endif
 
-#ifdef CONFIG_MPC85xx
+#ifdef CONFIG_FSL_SOC_BOOKE
 	/*
 	 * need to clear HID1[RFXE] to disable machine check int
 	 * so we can catch it
@@ -1189,7 +1189,7 @@ static int __init mpc85xx_mc_init(void)
 
 module_init(mpc85xx_mc_init);
 
-#ifdef CONFIG_MPC85xx
+#ifdef CONFIG_FSL_SOC_BOOKE
 static void __exit mpc85xx_mc_restore_hid1(void *data)
 {
 	mtspr(SPRN_HID1, orig_hid1[smp_processor_id()]);
@@ -1198,7 +1198,7 @@ static void __exit mpc85xx_mc_restore_hid1(void *data)
 
 static void __exit mpc85xx_mc_exit(void)
 {
-#ifdef CONFIG_MPC85xx
+#ifdef CONFIG_FSL_SOC_BOOKE
 	on_each_cpu(mpc85xx_mc_restore_hid1, NULL, 0);
 #endif
 #ifdef CONFIG_PCI
-- 
1.6.3.3













