Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab1FHBLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 21:11:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:64877 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab1FHBLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 21:11:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,335,1304319600"; 
   d="scan'208";a="10897511"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, x86@kernel.org
Subject: [PATCH 1/3] x86: Readd asmregparm
Date: Tue,  7 Jun 2011 18:09:59 -0700
Message-Id: <1307495401-2631-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

For a followon patchkit of mine I need to mark all functions
that can be called from assembler. But on 32bit kernels some
assembler functions are called with register arguments and others
with stack arguments. asmlinkage forces stack arguments.

This patch readds the recently removed asmregparm to be able
to mark assembler functions called with register arguments on 32bit.

Unlike the old code it's x86 only now to prevent it from
leaking.

Cc: x86@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/linkage.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkage.h
index 4814297..fe10d95 100644
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -8,6 +8,7 @@
 
 #ifdef CONFIG_X86_32
 #define asmlinkage CPP_ASMLINKAGE __attribute__((regparm(0)))
+#define asmregparm CPP_ASMLINKAGE __attribute__((regparm(3)))
 
 /*
  * Make sure the compiler doesn't do anything stupid with the
@@ -42,7 +43,9 @@
 	__asmlinkage_protect_n(ret, "g" (arg1), "g" (arg2), "g" (arg3), \
 			      "g" (arg4), "g" (arg5), "g" (arg6))
 
-#endif /* CONFIG_X86_32 */
+#else
+#define asmregparm asmlinkage
+#endif /* !CONFIG_X86_32 */
 
 #ifdef __ASSEMBLY__
 
-- 
1.7.4.4

