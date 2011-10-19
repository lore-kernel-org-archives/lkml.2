Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab1JSOwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:52:20 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38446 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442Ab1JSOvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:51:31 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 4/9] x86, RAS: Move MCE injection code into ras/
Date: Wed, 19 Oct 2011 16:51:01 +0200
Message-Id: <1319035866-29570-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1319035866-29570-1-git-send-email-bp@amd64.org>
References: <1319035866-29570-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This is the code collecting all AMD MCE injection methods.

No functionality change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/ras/Kconfig                    |    9 +++++++--
 arch/x86/kernel/cpu/ras/amd/Makefile               |    3 +++
 .../x86/kernel/cpu/ras/amd/mce-inject.c            |    0
 drivers/edac/Kconfig                               |   10 ----------
 drivers/edac/Makefile                              |    2 --
 5 files changed, 10 insertions(+), 14 deletions(-)
 rename drivers/edac/mce_amd_inj.c => arch/x86/kernel/cpu/ras/amd/mce-inject.c (100%)

diff --git a/arch/x86/kernel/cpu/ras/Kconfig b/arch/x86/kernel/cpu/ras/Kconfig
index 440d6a1..39dd0af 100644
--- a/arch/x86/kernel/cpu/ras/Kconfig
+++ b/arch/x86/kernel/cpu/ras/Kconfig
@@ -22,7 +22,12 @@ config X86_AMD_DECODE_MCE
 	  which occur really early upon boot, before the module infrastructure
 	  has been initialized.
 
+config X86_AMD_MCE_INJECT
+	tristate "Simple MCE injection interface over /sysfs"
+	depends on X86_AMD_DECODE_MCE
+	default n
+	help
+	  This is a simple interface to inject MCEs over /sysfs and test
+	  the MCE decoding code.
 
 endmenu
-
-
diff --git a/arch/x86/kernel/cpu/ras/amd/Makefile b/arch/x86/kernel/cpu/ras/amd/Makefile
index a18207b..3a01e3a 100644
--- a/arch/x86/kernel/cpu/ras/amd/Makefile
+++ b/arch/x86/kernel/cpu/ras/amd/Makefile
@@ -2,3 +2,6 @@ obj-$(CONFIG_X86_AMD_ERROR_THRESHOLDING)	+= thresholding.o
 
 amd_mce_decode-y				:= mce-decode.o
 obj-$(CONFIG_X86_AMD_DECODE_MCE)		+= amd_mce_decode.o
+
+amd_mce_inject-y				:= mce-inject.o
+obj-$(CONFIG_X86_AMD_MCE_INJECT)		+= amd_mce_inject.o
diff --git a/drivers/edac/mce_amd_inj.c b/arch/x86/kernel/cpu/ras/amd/mce-inject.c
similarity index 100%
rename from drivers/edac/mce_amd_inj.c
rename to arch/x86/kernel/cpu/ras/amd/mce-inject.c
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 8de46e7..9c9b319 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -39,16 +39,6 @@ config EDAC_DEBUG
 	  there're four debug levels (x=0,1,2,3 from low to high).
 	  Usually you should select 'N'.
 
-config EDAC_MCE_INJ
-	tristate "Simple MCE injection interface over /sysfs"
-	depends on EDAC_DECODE_MCE
-	default n
-	help
-	  This is a simple interface to inject MCEs over /sysfs and test
-	  the MCE decoding code in EDAC.
-
-	  This is currently AMD-only.
-
 config EDAC_MM_EDAC
 	tristate "Main Memory EDAC (Error Detection And Correction) reporting"
 	help
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index a6f10c2..5444512 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -17,8 +17,6 @@ ifdef CONFIG_PCI
 edac_core-y	+= edac_pci.o edac_pci_sysfs.o
 endif
 
-obj-$(CONFIG_EDAC_MCE_INJ)		+= mce_amd_inj.o
-
 obj-$(CONFIG_EDAC_AMD76X)		+= amd76x_edac.o
 obj-$(CONFIG_EDAC_CPC925)		+= cpc925_edac.o
 obj-$(CONFIG_EDAC_I5000)		+= i5000_edac.o
-- 
1.7.4.rc2

