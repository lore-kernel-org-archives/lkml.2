Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab1CCLwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 06:52:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:45177 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab1CCLwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 06:52:38 -0500
Date: Thu, 3 Mar 2011 11:52:04 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        shaohua.li@intel.com, akpm@linux-foundation.org, jbeulich@novell.com,
        JBeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        shaohua.li@intel.com, akpm@linux-foundation.org, jbeulich@novell.com,
        JBeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4D6F81B10200007800034B0B@vpn.id2.novell.com>
References: <4D6F81B10200007800034B0B@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Work around old gas bug
Message-ID: <tip-d04c579f971bf7d995db1ef7a7161c0143068859@git.kernel.org>
Git-Commit-ID: d04c579f971bf7d995db1ef7a7161c0143068859
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 03 Mar 2011 11:52:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d04c579f971bf7d995db1ef7a7161c0143068859
Gitweb:     http://git.kernel.org/tip/d04c579f971bf7d995db1ef7a7161c0143068859
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Thu, 3 Mar 2011 10:55:29 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Mar 2011 12:47:08 +0100

x86: Work around old gas bug

Add extra parentheses around a couple of definitions introduced
by "x86: Cleanup vector usage" and used in assembly macro
arguments, and remove spaces. Without that old (2.16.1) gas
would see more macro arguments than were actually specified.

Reported-and-tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Shaohua Li <shaohua.li@intel.com>
LKML-Reference: <4D6F81B10200007800034B0B@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/irq_vectors.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 4980f48..6e976ee 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
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
 
