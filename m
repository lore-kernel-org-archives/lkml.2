Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab1CCKzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:55:35 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:37173 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989Ab1CCKzd convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Thu, 3 Mar 2011 05:55:33 -0500
Message-Id: <4D6F81B10200007800034B0B@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 03 Mar 2011 10:55:29 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Shaohua Li" <shaohua.li@intel.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: work around old gas bug (try 2)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add extra parentheses around a couple of definitions introduced by
"x86: Cleanup vector usage" and used in assembly macro arguments, and
remove spaces. Without that old (2.16.1) gas would see more macro
arguments than were actually specified.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shaohua.li@intel.com>

---
 arch/x86/include/asm/irq_vectors.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- tip-20110303.orig/arch/x86/include/asm/irq_vectors.h
+++ tip-20110303/arch/x86/include/asm/irq_vectors.h
@@ -126,14 +126,14 @@
 
 /* up to 32 vectors used for spreading out TLB flushes: */
 #if NR_CPUS <= 32
-# define NUM_INVALIDATE_TLB_VECTORS NR_CPUS
+# define NUM_INVALIDATE_TLB_VECTORS	(NR_CPUS)
 #else
-# define NUM_INVALIDATE_TLB_VECTORS 32
+# define NUM_INVALIDATE_TLB_VECTORS	(32)
 #endif
 
-#define INVALIDATE_TLB_VECTOR_END	0xee
+#define INVALIDATE_TLB_VECTOR_END	(0xee)
 #define INVALIDATE_TLB_VECTOR_START	\
-	(INVALIDATE_TLB_VECTOR_END - NUM_INVALIDATE_TLB_VECTORS + 1)
+	(INVALIDATE_TLB_VECTOR_END-NUM_INVALIDATE_TLB_VECTORS+1)
 
 #define NR_VECTORS			 256
 



