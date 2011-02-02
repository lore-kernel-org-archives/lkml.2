Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1BBBIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:08:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:41311 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab1BBAn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="598622312"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: suresh.b.siddha@intel.com, ak@linux.intel.com, hpa@linux.intel.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [25/139] x86, xsave: Use alloc_bootmem_align() instead of alloc_bootmem()
Message-Id: <20110202004339.F2B143E09C6@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Suresh Siddha <suresh.b.siddha@intel.com>

commit 10340ae130fb70352eae1ae8a00b7906d91bf166 upstream.

Alignment of alloc_bootmem() depends on the value of
L1_CACHE_SHIFT. What we need here, however, is 64 byte alignment.  Use
alloc_bootmem_align() and explicitly specify the alignment instead.

This fixes a kernel boot crash reported by Jody when the cpu in .config
is set to MPENTIUMII but the kernel is booted on a xsave-capable CPU.

Reported-by: Jody Bruchon <jody@nctritech.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <20101116212442.059967454@sbsiddha-MOBL3.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/xsave.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/arch/x86/kernel/xsave.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/xsave.c
+++ linux-2.6.35.y/arch/x86/kernel/xsave.c
@@ -305,7 +305,8 @@ void __cpuinit xsave_init(void)
  */
 static void __init setup_xstate_init(void)
 {
-	init_xstate_buf = alloc_bootmem(xstate_size);
+	init_xstate_buf = alloc_bootmem_align(xstate_size,
+			      __alignof__(struct xsave_struct));
 	init_xstate_buf->i387.mxcsr = MXCSR_DEFAULT;
 }
 
