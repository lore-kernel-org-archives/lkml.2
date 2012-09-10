Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab2IJSMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:12:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:6412 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757513Ab2IJSMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:12:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,398,1344236400"; 
   d="scan'208";a="191253106"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH v2 3/5] x86, fpu: move check_fpu() after alternative_instructions()
Date: Mon, 10 Sep 2012 11:11:03 -0700
Message-Id: <1347300665-6209-4-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1347300665-6209-1-git-send-email-suresh.b.siddha@intel.com>
References: <1347300665-6209-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use_eager_fpu() in kernel_fpu_begin/end() relies on the patched
alternative instructions. So move check_fpu() which uses the
kernel_fpu_begin/end() after alternative_instructions().

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/cpu/bugs.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index c97bb7b..d0e910d 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -165,10 +165,15 @@ void __init check_bugs(void)
 	print_cpu_info(&boot_cpu_data);
 #endif
 	check_config();
-	check_fpu();
 	check_hlt();
 	check_popad();
 	init_utsname()->machine[1] =
 		'0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
 	alternative_instructions();
+
+	/*
+	 * kernel_fpu_begin/end() in check_fpu() relies on the patched
+	 * alternative instructions.
+	 */
+	check_fpu();
 }
-- 
1.7.6.5

