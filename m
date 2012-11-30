Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab2K3IvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:51:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:40531 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab2K3It3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:49:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="scan'208";a="255459086"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v2 07/10] x86/head64.c: Early update ucode in 64-bit
Date: Thu, 29 Nov 2012 17:47:45 -0800
Message-Id: <1354240068-9821-8-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1354240068-9821-1-git-send-email-fenghua.yu@intel.com>
References: <1354240068-9821-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

This updates ucode in 64-bit mode. Paging and virtual address are working now.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/head64.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 037df57..a512f56 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -25,6 +25,7 @@
 #include <asm/kdebug.h>
 #include <asm/e820.h>
 #include <asm/bios_ebda.h>
+#include <asm/microcode.h>
 
 static void __init zap_identity_mappings(void)
 {
@@ -73,6 +74,11 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	/* clear bss before set_intr_gate with early_idt_handler */
 	clear_bss();
 
+	/*
+	 * Load microcode early on BSP.
+	 */
+	load_ucode_bsp(real_mode_data);
+
 	/* Make NULL pointers segfault */
 	zap_identity_mappings();
 
-- 
1.7.2

