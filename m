Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab1AYIY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 03:24:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:34051 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab1AYIYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 03:24:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,373,1291622400"; 
   d="scan'208";a="650805335"
From: Shane Wang <shane.wang@intel.com>
To: linux-kernel@vger.kernel.org, tboot-devel@lists.sourceforge.net
Cc: jonmccune@cmu.edu, joseph.cihula@intel.com, shane.wang@intel.com
Subject: [PATCH RESEND] intel_txt: Add more explicit dependencies for CONFIG_INTEL_TXT
Date: Thu, 27 Jan 2011 07:43:27 +0800
Message-Id: <1296085407-15880-1-git-send-email-shane.wang@intel.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to follow the recommended way in kconfig-language.txt to use HAVE_INTEL_TXT, so to add more explicit dependencies for CONFIG_INTEL_TXT.

Signed-off-by: Jonathan McCune <jonmccune@cmu.edu>
Signed-off-by: Shane Wang <shane.wang@intel.com>

---
 Documentation/intel_txt.txt |    4 +++-
 arch/x86/Kconfig            |    5 +----
 security/Kconfig            |    5 ++++-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff -r 95e0d1104426 Documentation/intel_txt.txt
--- a/Documentation/intel_txt.txt	Thu Jan 27 07:04:38 2011 +0800
+++ b/Documentation/intel_txt.txt	Thu Jan 27 07:37:23 2011 +0800
@@ -196,7 +196,9 @@
 depends on the generic x86 support (to allow maximum flexibility in
 kernel build options), since the tboot code will detect whether the
 platform actually supports Intel TXT and thus whether any of the
-kernel code is executed.
+kernel code is executed. The kernel option for enabling Intel TXT
+support will only appear if its dependencies are also enabled.
+These are CONFIG_DMAR and CONFIG_ACPI.
 
 The Q35_SINIT_17.BIN file is what Intel TXT refers to as an
 Authenticated Code Module.  It is specific to the chipset in the
diff -r 95e0d1104426 arch/x86/Kconfig
--- a/arch/x86/Kconfig	Thu Jan 27 07:04:38 2011 +0800
+++ b/arch/x86/Kconfig	Thu Jan 27 07:37:23 2011 +0800
@@ -65,6 +65,7 @@
 	select HAVE_SPARSE_IRQ
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
+	select HAVE_INTEL_TXT
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
@@ -199,10 +200,6 @@
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	def_bool y
 
-config HAVE_INTEL_TXT
-	def_bool y
-	depends on EXPERIMENTAL && DMAR && ACPI
-
 config USE_GENERIC_SMP_HELPERS
 	def_bool y
 	depends on SMP
diff -r 95e0d1104426 security/Kconfig
--- a/security/Kconfig	Thu Jan 27 07:04:38 2011 +0800
+++ b/security/Kconfig	Thu Jan 27 07:37:23 2011 +0800
@@ -103,9 +103,12 @@
 	  implement pathname based access controls.
 	  If you are unsure how to answer this question, answer N.
 
+config HAVE_INTEL_TXT
+	bool
+
 config INTEL_TXT
 	bool "Enable Intel(R) Trusted Execution Technology (Intel(R) TXT)"
-	depends on HAVE_INTEL_TXT
+	depends on HAVE_INTEL_TXT && EXPERIMENTAL && DMAR && ACPI
 	help
 	  This option enables support for booting the kernel with the
 	  Trusted Boot (tboot) module. This will utilize
