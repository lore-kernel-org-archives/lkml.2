Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab2LAAam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 19:30:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39230 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab2LAAak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 19:30:40 -0500
Date: Fri, 30 Nov 2012 16:30:29 -0800
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-16544f8d32aca4ec97b22db880f879ee164c3658@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1354240068-9821-11-git-send-email-fenghua.yu@intel.com>
References: <1354240068-9821-11-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86/Kconfig: Configurations to enable/
 disable the feature
Git-Commit-ID: 16544f8d32aca4ec97b22db880f879ee164c3658
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 30 Nov 2012 16:30:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  16544f8d32aca4ec97b22db880f879ee164c3658
Gitweb:     http://git.kernel.org/tip/16544f8d32aca4ec97b22db880f879ee164c3658
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 29 Nov 2012 17:47:48 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 30 Nov 2012 15:18:17 -0800

x86/Kconfig: Configurations to enable/disable the feature

MICROCODE_INTEL_LIB, MICROCODE_INTEL_EARLY, and MICROCODE_EARLY are three new
configurations to enable or disable the feature.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1354240068-9821-11-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 46c3bff..abb1153 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1031,6 +1031,24 @@ config MICROCODE_OLD_INTERFACE
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
