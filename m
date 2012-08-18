Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab2HRRbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:31:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:9940 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532Ab2HRRa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="210330064"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 07/31] sections: Fix section conflicts in arch/powerpc
Date: Sat, 18 Aug 2012 10:29:58 -0700
Message-Id: <1345311022-26328-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/powerpc/platforms/40x/ppc40x_simple.c    |    2 +-
 arch/powerpc/platforms/512x/mpc5121_generic.c |    2 +-
 arch/powerpc/platforms/52xx/lite5200.c        |    2 +-
 arch/powerpc/platforms/52xx/media5200.c       |    2 +-
 arch/powerpc/platforms/83xx/mpc837x_rdb.c     |    2 +-
 arch/powerpc/platforms/85xx/tqm85xx.c         |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/40x/ppc40x_simple.c b/arch/powerpc/platforms/40x/ppc40x_simple.c
index 9761206..969dddc 100644
--- a/arch/powerpc/platforms/40x/ppc40x_simple.c
+++ b/arch/powerpc/platforms/40x/ppc40x_simple.c
@@ -50,7 +50,7 @@ machine_device_initcall(ppc40x_simple, ppc40x_device_probe);
  * Again, if your board needs to do things differently then create a
  * board.c file for it rather than adding it to this list.
  */
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"amcc,acadia",
 	"amcc,haleakala",
 	"amcc,kilauea",
diff --git a/arch/powerpc/platforms/512x/mpc5121_generic.c b/arch/powerpc/platforms/512x/mpc5121_generic.c
index 926731f..ca1ca66 100644
--- a/arch/powerpc/platforms/512x/mpc5121_generic.c
+++ b/arch/powerpc/platforms/512x/mpc5121_generic.c
@@ -26,7 +26,7 @@
 /*
  * list of supported boards
  */
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"prt,prtlvt",
 	NULL
 };
diff --git a/arch/powerpc/platforms/52xx/lite5200.c b/arch/powerpc/platforms/52xx/lite5200.c
index 01ffa64..448d862 100644
--- a/arch/powerpc/platforms/52xx/lite5200.c
+++ b/arch/powerpc/platforms/52xx/lite5200.c
@@ -172,7 +172,7 @@ static void __init lite5200_setup_arch(void)
 	mpc52xx_setup_pci();
 }
 
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"fsl,lite5200",
 	"fsl,lite5200b",
 	NULL,
diff --git a/arch/powerpc/platforms/52xx/media5200.c b/arch/powerpc/platforms/52xx/media5200.c
index 17d91b7..070d315 100644
--- a/arch/powerpc/platforms/52xx/media5200.c
+++ b/arch/powerpc/platforms/52xx/media5200.c
@@ -232,7 +232,7 @@ static void __init media5200_setup_arch(void)
 }
 
 /* list of the supported boards */
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"fsl,media5200",
 	NULL
 };
diff --git a/arch/powerpc/platforms/83xx/mpc837x_rdb.c b/arch/powerpc/platforms/83xx/mpc837x_rdb.c
index 16c9c9c..eca1f09 100644
--- a/arch/powerpc/platforms/83xx/mpc837x_rdb.c
+++ b/arch/powerpc/platforms/83xx/mpc837x_rdb.c
@@ -60,7 +60,7 @@ static void __init mpc837x_rdb_setup_arch(void)
 
 machine_device_initcall(mpc837x_rdb, mpc83xx_declare_of_platform_devices);
 
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"fsl,mpc8377rdb",
 	"fsl,mpc8378rdb",
 	"fsl,mpc8379rdb",
diff --git a/arch/powerpc/platforms/85xx/tqm85xx.c b/arch/powerpc/platforms/85xx/tqm85xx.c
index 3e70a20..b62fa87 100644
--- a/arch/powerpc/platforms/85xx/tqm85xx.c
+++ b/arch/powerpc/platforms/85xx/tqm85xx.c
@@ -125,7 +125,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_1520,
 
 machine_device_initcall(tqm85xx, mpc85xx_common_publish_devices);
 
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"tqc,tqm8540",
 	"tqc,tqm8541",
 	"tqc,tqm8548",
-- 
1.7.7.6

