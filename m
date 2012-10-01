Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab2JAX3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:29:00 -0400
Received: from 1wt.eu ([62.212.114.60]:35233 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932738Ab2JAXAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:47 -0400
Message-Id: <20121001225201.843348475@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:37 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tiejun Chen <tiejun.chen@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 100/180] powerpc: Add "memory" attribute for mfmsr()
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Tiejun Chen <tiejun.chen@windriver.com>

commit b416c9a10baae6a177b4f9ee858b8d309542fbef upstream.

Add "memory" attribute in inline assembly language as a compiler
barrier to make sure 4.6.x GCC don't reorder mfmsr().

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 93487ce8d6edc7c550b1449770df5e44715f520f upstream.
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/powerpc/include/asm/reg.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index 32a7c30..6ce44dd 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -870,7 +870,8 @@
 /* Macros for setting and retrieving special purpose registers */
 #ifndef __ASSEMBLY__
 #define mfmsr()		({unsigned long rval; \
-			asm volatile("mfmsr %0" : "=r" (rval)); rval;})
+			asm volatile("mfmsr %0" : "=r" (rval) : \
+						: "memory"); rval;})
 #ifdef CONFIG_PPC64
 #define __mtmsrd(v, l)	asm volatile("mtmsrd %0," __stringify(l) \
 				     : : "r" (v) : "memory")
-- 
1.7.2.1.45.g54fbc



