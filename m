Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab2K3Iu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:50:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:45218 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872Ab2K3It3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:49:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="scan'208";a="255459090"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v2 08/10] x86/smpboot.c: Early update ucode on AP
Date: Thu, 29 Nov 2012 17:47:46 -0800
Message-Id: <1354240068-9821-9-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1354240068-9821-1-git-send-email-fenghua.yu@intel.com>
References: <1354240068-9821-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

This updates ucode on AP. At this point, BSP should store some valid ucode
patches in memory if it finds the ucode patches in initrd. AP searches the
stored ucode and uploads the ucode.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/smpboot.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 732bf5c..025690a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -76,6 +76,7 @@
 #include <asm/i8259.h>
 
 #include <asm/realmode.h>
+#include <asm/microcode.h>
 
 /* State of each CPU */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
@@ -239,6 +240,12 @@ notrace static void __cpuinit start_secondary(void *unused)
 	 * most necessary things.
 	 */
 	cpu_init();
+	/*
+	 * Load microcode on this cpu if a valid microcode is available.
+	 * This is early microcode loading procedure.
+	 */
+	load_ucode_ap();
+
 	x86_cpuinit.early_percpu_clock_init();
 	preempt_disable();
 	smp_callin();
-- 
1.7.2

