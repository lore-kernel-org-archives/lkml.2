Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab2K3Itb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:49:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:40531 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab2K3It2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:49:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="scan'208";a="255459082"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v2 06/10] x86/head_32.S: Early update ucode in 32-bit
Date: Thu, 29 Nov 2012 17:47:44 -0800
Message-Id: <1354240068-9821-7-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1354240068-9821-1-git-send-email-fenghua.yu@intel.com>
References: <1354240068-9821-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

This updates ucode in 32-bit kernel. At this point, there is no paging and no
virtual address yet.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/head_32.S |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 957a47a..b7b76a4 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -144,6 +144,12 @@ ENTRY(startup_32)
 	movl %eax, pa(olpc_ofw_pgd)
 #endif
 
+#ifdef CONFIG_MICROCODE_EARLY
+	/* Early load ucode on BSP. */
+	movl $pa(boot_params), %eax
+	call load_ucode_bsp
+#endif
+
 /*
  * Initialize page tables.  This creates a PDE and a set of page
  * tables, which are located immediately beyond __brk_base.  The variable
-- 
1.7.2

