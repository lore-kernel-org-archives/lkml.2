Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2LUCvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:51:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:49854 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab2LUCus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:50:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,327,1355126400"; 
   d="scan'208";a="265338764"
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
Subject: [PATCH v4 09/11] x86/head64.c: Early update ucode in 64-bit
Date: Thu, 20 Dec 2012 11:48:11 -0800
Message-Id: <1356032893-2730-10-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1356032893-2730-1-git-send-email-fenghua.yu@intel.com>
References: <1356032893-2730-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

This updates ucode on BSP in 64-bit mode. Paging and virtual address are
working now.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/head64.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index e1cb611..1ccbaf1 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -26,6 +26,7 @@
 #include <asm/kdebug.h>
 #include <asm/e820.h>
 #include <asm/bios_ebda.h>
+#include <asm/microcode.h>
 
 /*
  * Manage page tables very early on.
@@ -179,6 +180,11 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	}
 	load_idt((const struct desc_ptr *)&idt_descr);
 
+	/*
+	 * Load microcode early on BSP.
+	 */
+	load_ucode_bsp(__va(real_mode_data));
+
 	copy_bootdata(__va(real_mode_data));
 
 	if (console_loglevel == 10)
-- 
1.8.0.1

