Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab2IUTqC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:46:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:26130 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab2IUTnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:43:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,464,1344236400"; 
   d="scan'208";a="225201988"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 02/11] x86-32, mm: The WP test should be done on a kernel page
Date: Fri, 21 Sep 2012 12:43:06 -0700
Message-Id: <1348256595-29119-3-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

PAGE_READONLY includes user permission, but this is a page used
exclusively by the kernel; use PAGE_KERNEL_RO instead.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 575d86f..e537b35 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -712,7 +712,7 @@ static void __init test_wp_bit(void)
   "Checking if this processor honours the WP bit even in supervisor mode...");
 
 	/* Any page-aligned address will do, the test is non-destructive */
-	__set_fixmap(FIX_WP_TEST, __pa(&swapper_pg_dir), PAGE_READONLY);
+	__set_fixmap(FIX_WP_TEST, __pa(&swapper_pg_dir), PAGE_KERNEL_RO);
 	boot_cpu_data.wp_works_ok = do_test_wp_bit();
 	clear_fixmap(FIX_WP_TEST);
 
-- 
1.7.6.5

