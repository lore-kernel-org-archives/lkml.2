Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab3AGK1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:27:24 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:40667 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3AGK1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 05:27:22 -0500
Subject: [PATCH] uprobes/powerpc: Add dependency on single step emulation
To: benh@kernel.crashing.org
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Date: Mon, 07 Jan 2013 15:56:57 +0530
Message-ID: <20130107102648.27826.85082.stgit@suzukikp>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010710-2674-0000-0000-0000075DFB74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suzuki K. Poulose <suzuki@in.ibm.com>

Uprobes uses emulate_step in sstep.c, but we haven't explicitly specified
the dependency. On pseries HAVE_HW_BREAKPOINT protects us, but 44x has no
such luxury.

Consolidate other users that depend on sstep and create a new config option.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Cc: linuxppc-dev@ozlabs.org
Cc: stable@vger.kernel.org
---
 arch/powerpc/Kconfig      |    4 ++++
 arch/powerpc/lib/Makefile |    4 +---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 17903f1..dabe429 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -275,6 +275,10 @@ config PPC_ADV_DEBUG_DAC_RANGE
 	depends on PPC_ADV_DEBUG_REGS && 44x
 	default y
 
+config PPC_EMULATE_SSTEP
+	bool
+	default y if KPROBES || UPROBES || XMON || HAVE_HW_BREAKPOINT
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 746e0c8..35baad9 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -19,9 +19,7 @@ obj-$(CONFIG_PPC64)	+= copypage_64.o copyuser_64.o \
 			   checksum_wrappers_64.o hweight_64.o \
 			   copyuser_power7.o string_64.o copypage_power7.o \
 			   memcpy_power7.o
-obj-$(CONFIG_XMON)	+= sstep.o ldstfp.o
-obj-$(CONFIG_KPROBES)	+= sstep.o ldstfp.o
-obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= sstep.o ldstfp.o
+obj-$(CONFIG_PPC_EMULATE_SSTEP)	+= sstep.o ldstfp.o
 
 ifeq ($(CONFIG_PPC64),y)
 obj-$(CONFIG_SMP)	+= locks.o

