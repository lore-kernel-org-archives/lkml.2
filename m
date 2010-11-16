Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab0KPVcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:32:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:25972 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932594Ab0KPVcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:32:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,207,1288594800"; 
   d="scan'208";a="627454843"
Message-Id: <20101116212442.059967454@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Tue, 16 Nov 2010 13:23:51 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@linux.jf.intel.com>
Subject: [patch 2/2] xsave: use alloc_bootmem_align() instead of alloc_bootmem()
References: <20101116212441.977574826@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=xsave_use_alloc_bootmem_align.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alignment of alloc_bootmem() depends on the value of L1_CACHE_SHIFT. What
we need here is 64byte alignment. Use alloc_bootmem_align() instead.

This fixes a kernel boot crash reported by Jody when the cpu in .config
is set to MPENTIUMII

Reported-by: Jody Bruchon <jody@nctritech.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/xsave.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: tree/arch/x86/kernel/xsave.c
===================================================================
--- tree.orig/arch/x86/kernel/xsave.c
+++ tree/arch/x86/kernel/xsave.c
@@ -394,7 +394,8 @@ static void __init setup_xstate_init(voi
 	 * Setup init_xstate_buf to represent the init state of
 	 * all the features managed by the xsave
 	 */
-	init_xstate_buf = alloc_bootmem(xstate_size);
+	init_xstate_buf = alloc_bootmem_align(xstate_size,
+					      __alignof__(struct xsave_struct));
 	init_xstate_buf->i387.mxcsr = MXCSR_DEFAULT;
 
 	clts();


