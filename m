Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab2LUOtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 09:49:12 -0500
Received: from mga03.intel.com ([143.182.124.21]:40310 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab2LUOrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 09:47:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,329,1355126400"; 
   d="scan'208";a="235197563"
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
Subject: [PATCH v5 09/12] x86/head_32.S: Early update ucode in 32-bit
Date: Thu, 20 Dec 2012 23:44:29 -0800
Message-Id: <1356075872-3054-10-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1356075872-3054-1-git-send-email-fenghua.yu@intel.com>
References: <1356075872-3054-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

This updates ucode in 32-bit kernel on BSP and AP. At this point, there is no
paging and no virtual address yet.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/head_32.S | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 8e7f655..2f70530 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -144,6 +144,11 @@ ENTRY(startup_32)
 	movl %eax, pa(olpc_ofw_pgd)
 #endif
 
+#ifdef CONFIG_MICROCODE_EARLY
+	/* Early load ucode on BSP. */
+	call load_ucode_bsp
+#endif
+
 /*
  * Initialize page tables.  This creates a PDE and a set of page
  * tables, which are located immediately beyond __brk_base.  The variable
@@ -299,6 +304,12 @@ ENTRY(startup_32_smp)
 	movl %eax,%ss
 	leal -__PAGE_OFFSET(%ecx),%esp
 
+#ifdef CONFIG_MICROCODE_EARLY
+	/* Early load ucode on AP. */
+	call load_ucode_ap
+#endif
+
+
 default_entry:
 /*
  *	New page tables may be in 4Mbyte page mode and may
-- 
1.8.0.1

