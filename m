Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab2HRIcP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 04:32:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:10632 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab2HRIaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 04:30:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,790,1336374000"; 
   d="scan'208";a="182264789"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 11/11] x86/Kconfig: Configurations to enable/disable the feature
Date: Sat, 18 Aug 2012 01:15:29 -0700
Message-Id: <1345277729-8399-12-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

MICROCODE_INTEL_LIB, MICROCODE_INTEL_EARLY, and MICROCODE_EARLY are three new
configurations to enable or disable the feature.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/Kconfig |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 50c660d..32caa77 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1035,6 +1035,7 @@ config MICROCODE_INTEL
 	depends on MICROCODE
 	default MICROCODE
 	select FW_LOADER
+	select MICROCODE_INTEL_LIB
 	---help---
 	  This options enables microcode patch loading support for Intel
 	  processors.
@@ -1055,6 +1056,27 @@ config MICROCODE_OLD_INTERFACE
 	def_bool y
 	depends on MICROCODE
 
+config MICROCODE_EARLY
+	def_bool y
+	depends on MICROCODE_INTEL_EARLY
+
+config MICROCODE_INTEL_LIB
+	def_bool y
+	depends on MICROCODE_INTEL_EARLY
+
+config MICROCODE_INTEL_EARLY
+	bool "Early load microcode"
+	depends on MICROCODE_INTEL && BLK_DEV_INITRD
+	default y
+	select FW_LOADER
+	select MICROCODE_EARLY
+	select MICROCODE_INTEL_LIB
+	help
+	  This option provides functionality to read additional microcode data
+	  at the beginning of initrd image. The data tells kernel to load
+	  microcode to CPU's as early as possible. No functional change if no
+	  microcode data is glued to the initrd, therefore it's safe to say Y.
+
 config X86_MSR
 	tristate "/dev/cpu/*/msr - Model-specific register support"
 	---help---
-- 
1.7.2

