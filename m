Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1AYDSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 22:18:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:45852 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab1AYDSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 22:18:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,372,1291622400"; 
   d="scan'208";a="880613949"
From: Shane Wang <shane.wang@intel.com>
To: linux-kernel@vger.kernel.org, tboot-devel@lists.sourceforge.net
Cc: jonmccune@cmu.edu, joseph.cihula@intel.com, shane.wang@intel.com
Subject: [PATCH] intel_txt: Add more explicit dependencies for CONFIG_INTEL_TXT
Date: Thu, 27 Jan 2011 02:37:22 +0800
Message-Id: <1296067042-13485-1-git-send-email-shane.wang@intel.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to follow the recommended way in kconfig-language.txt to use HAVE_INTEL_TXT, so to add more explicit dependencies for CONFIG_INTEL_TXT.

Signed-off-by: Jonathan McCune <jonmccune@cmu.edu>
Signed-off-by: Shane Wang <shane.wang@intel.com>

---
 arch/x86/Kconfig |    5 +----
 security/Kconfig |    5 ++++-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -r 2ec3d14a1901 arch/x86/Kconfig
--- a/arch/x86/Kconfig	Thu Jan 27 00:23:42 2011 +0800
+++ b/arch/x86/Kconfig	Thu Jan 27 00:44:49 2011 +0800
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
diff -r 2ec3d14a1901 security/Kconfig
--- a/security/Kconfig	Thu Jan 27 00:23:42 2011 +0800
+++ b/security/Kconfig	Thu Jan 27 00:44:49 2011 +0800
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
