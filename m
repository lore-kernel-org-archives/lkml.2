Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2LUOsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 09:48:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:40310 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab2LUOrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 09:47:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,329,1355126400"; 
   d="scan'208";a="235197579"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Yinghai Lu" <yinghai@kernel.org>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v5 12/12] x86/Kconfig: Configurations to enable/disable the feature
Date: Thu, 20 Dec 2012 23:44:32 -0800
Message-Id: <1356075872-3054-13-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1356075872-3054-1-git-send-email-fenghua.yu@intel.com>
References: <1356075872-3054-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

MICROCODE_INTEL_LIB, MICROCODE_INTEL_EARLY, and MICROCODE_EARLY are three new
configurations to enable or disable the feature.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/Kconfig | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 97f8c5a..7f63084 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1030,6 +1030,24 @@ config MICROCODE_OLD_INTERFACE
 	def_bool y
 	depends on MICROCODE
 
+config MICROCODE_INTEL_LIB
+	def_bool y
+	depends on MICROCODE_INTEL
+
+config MICROCODE_INTEL_EARLY
+	bool "Early load microcode"
+	depends on MICROCODE_INTEL && BLK_DEV_INITRD
+	default y
+	help
+	  This option provides functionality to read additional microcode data
+	  at the beginning of initrd image. The data tells kernel to load
+	  microcode to CPU's as early as possible. No functional change if no
+	  microcode data is glued to the initrd, therefore it's safe to say Y.
+
+config MICROCODE_EARLY
+	def_bool y
+	depends on MICROCODE_INTEL_EARLY
+
 config X86_MSR
 	tristate "/dev/cpu/*/msr - Model-specific register support"
 	---help---
-- 
1.8.0.1

