Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751004Ab1ETWqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 18:46:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:45764 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab1ETWqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 18:46:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,244,1304319600"; 
   d="scan'208";a="440039325"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>, "Yinghai Lu" <yinghai@kernel.org>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 1/1] x86/kernel/cpu/common.c: Fix section mismatch warnings
Date: Fri, 20 May 2011 15:33:17 -0700
Message-Id: <1305930797-11409-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Fix kernel compilation warnings from commit:
de5397ad5b9ad22e2401c4dacdf1bb3b19c05679

WARNING: arch/x86/built-in.o(.cpuinit.text+0x1e07): Section mismatch in reference from the function generic_identify() to the variable .init.data:disable_smep
The function __cpuinit generic_identify() references
a variable __initdata disable_smep.
If disable_smep is only used by generic_identify then
annotate disable_smep with a matching annotation.

WARNING: arch/x86/built-in.o(.cpuinit.text+0x1b10): Section mismatch in reference from the function identify_cpu() to the function .init.text:setup_smep() The function __cpuinit identify_cpu() references a function __init setup_smep().
If setup_smep is only used by identify_cpu then annotate setup_smep with a matching annotation.

Change disable_smep from __initdata to __cpuinitdata.

Change setup_smep() from __init to __cpuinit.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---
 arch/x86/kernel/cpu/common.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cbc70a2..c8b4162 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -254,7 +254,7 @@ static inline void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
 }
 #endif
 
-static int disable_smep __initdata;
+static int disable_smep __cpuinitdata;
 static __init int setup_disable_smep(char *arg)
 {
 	disable_smep = 1;
@@ -262,7 +262,7 @@ static __init int setup_disable_smep(char *arg)
 }
 __setup("nosmep", setup_disable_smep);
 
-static __init void setup_smep(struct cpuinfo_x86 *c)
+static __cpuinit void setup_smep(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_SMEP)) {
 		if (unlikely(disable_smep)) {
-- 
1.7.2

