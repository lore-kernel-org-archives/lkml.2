Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab2KSRL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 12:11:57 -0500
Received: from mga03.intel.com ([143.182.124.21]:16725 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750Ab2KSRL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:11:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,280,1352102400"; 
   d="scan'208";a="219760691"
Subject: [PATCH] x86: Fix warning about cast from pointer to integer of
 different size
To: tglx@linutronix.de, mingo@redhat.com, andi@firstfloor.org, hpa@zytor.com
From: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 19 Nov 2012 09:10:43 -0800
Message-ID: <20121119171043.2965.8482.stgit@ahduyck-cp1.jf.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a warning reported by the kbuild test robot where we were
casting a pointer to a physical address which represents an integer of a
different size.  Per the suggestion of Peter Anvin I am replacing it and one
other spot where I made a similar cast with an unsigned long.

Cc: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---
 arch/x86/kernel/head32.c |    2 +-
 arch/x86/kernel/head64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index f15db0c..e175548 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -31,7 +31,7 @@ static void __init i386_default_early_setup(void)
 void __init i386_start_kernel(void)
 {
 	memblock_reserve(__pa_symbol(_text),
-			 (phys_addr_t)__bss_stop - (phys_addr_t)_text);
+			 (unsigned long)__bss_stop - (unsigned long)_text);
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 42f5df1..7b215a5 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -98,7 +98,7 @@ void __init x86_64_start_reservations(char *real_mode_data)
 	copy_bootdata(__va(real_mode_data));
 
 	memblock_reserve(__pa_symbol(_text),
-			 (phys_addr_t)__bss_stop - (phys_addr_t)_text);
+			 (unsigned long)__bss_stop - (unsigned long)_text);
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */

