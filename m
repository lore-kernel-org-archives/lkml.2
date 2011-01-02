Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab1ABHYV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:24:21 -0500
Received: from mail.windriver.com ([147.11.1.11]:36218 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab1ABHYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:17 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, David Daney <ddaney@caviumnetworks.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 155/260] MIPS: Quit using undefined behavior of ADDU in 64-bit atomic operations.
Date: Sun,  2 Jan 2011 02:17:31 -0500
Message-Id: <1293952756-15010-156-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:00.0259 (UTC) FILETIME=[E2B02730:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney@caviumnetworks.com>

commit f2a68272d799bf4092443357142f63b74f7669a1 upstream.

For 64-bit, we must use DADDU and DSUBU.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/1483/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/mips/include/asm/atomic.h |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/mips/include/asm/atomic.h b/arch/mips/include/asm/atomic.h
index 519197e..dbbcc73 100644
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -434,7 +434,7 @@ static __inline__ void atomic64_add(long i, atomic64_t * v)
 		__asm__ __volatile__(
 		"	.set	mips3					\n"
 		"1:	lld	%0, %1		# atomic64_add		\n"
-		"	addu	%0, %2					\n"
+		"	daddu	%0, %2					\n"
 		"	scd	%0, %1					\n"
 		"	beqzl	%0, 1b					\n"
 		"	.set	mips0					\n"
@@ -446,7 +446,7 @@ static __inline__ void atomic64_add(long i, atomic64_t * v)
 		__asm__ __volatile__(
 		"	.set	mips3					\n"
 		"1:	lld	%0, %1		# atomic64_add		\n"
-		"	addu	%0, %2					\n"
+		"	daddu	%0, %2					\n"
 		"	scd	%0, %1					\n"
 		"	beqz	%0, 2f					\n"
 		"	.subsection 2					\n"
@@ -479,7 +479,7 @@ static __inline__ void atomic64_sub(long i, atomic64_t * v)
 		__asm__ __volatile__(
 		"	.set	mips3					\n"
 		"1:	lld	%0, %1		# atomic64_sub		\n"
-		"	subu	%0, %2					\n"
+		"	dsubu	%0, %2					\n"
 		"	scd	%0, %1					\n"
 		"	beqzl	%0, 1b					\n"
 		"	.set	mips0					\n"
@@ -491,7 +491,7 @@ static __inline__ void atomic64_sub(long i, atomic64_t * v)
 		__asm__ __volatile__(
 		"	.set	mips3					\n"
 		"1:	lld	%0, %1		# atomic64_sub		\n"
-		"	subu	%0, %2					\n"
+		"	dsubu	%0, %2					\n"
 		"	scd	%0, %1					\n"
 		"	beqz	%0, 2f					\n"
 		"	.subsection 2					\n"
@@ -524,10 +524,10 @@ static __inline__ long atomic64_add_return(long i, atomic64_t * v)
 		__asm__ __volatile__(
 		"	.set	mips3					\n"
 		"1:	lld	%1, %2		# atomic64_add_return	\n"
-		"	addu	%0, %1, %3				\n"
+		"	daddu	%0, %1, %3				\n"
 		"	scd	%0, %2					\n"
 		"	beqzl	%0, 1b					\n"
-		"	addu	%0, %1, %3				\n"
+		"	daddu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
 		: "=&r" (result), "=&r" (temp), "=m" (v->counter)
 		: "Ir" (i), "m" (v->counter)
@@ -538,10 +538,10 @@ static __inline__ long atomic64_add_return(long i, atomic64_t * v)
 		__asm__ __volatile__(
 		"	.set	mips3					\n"
 		"1:	lld	%1, %2		# atomic64_add_return	\n"
-		"	addu	%0, %1, %3				\n"
+		"	daddu	%0, %1, %3				\n"
 		"	scd	%0, %2					\n"
 		"	beqz	%0, 2f					\n"
-		"	addu	%0, %1, %3				\n"
+		"	daddu	%0, %1, %3				\n"
 		"	.subsection 2					\n"
 		"2:	b	1b					\n"
 		"	.previous					\n"
@@ -576,10 +576,10 @@ static __inline__ long atomic64_sub_return(long i, atomic64_t * v)
 		__asm__ __volatile__(
 		"	.set	mips3					\n"
 		"1:	lld	%1, %2		# atomic64_sub_return	\n"
-		"	subu	%0, %1, %3				\n"
+		"	dsubu	%0, %1, %3				\n"
 		"	scd	%0, %2					\n"
 		"	beqzl	%0, 1b					\n"
-		"	subu	%0, %1, %3				\n"
+		"	dsubu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
 		: "=&r" (result), "=&r" (temp), "=m" (v->counter)
 		: "Ir" (i), "m" (v->counter)
@@ -590,10 +590,10 @@ static __inline__ long atomic64_sub_return(long i, atomic64_t * v)
 		__asm__ __volatile__(
 		"	.set	mips3					\n"
 		"1:	lld	%1, %2		# atomic64_sub_return	\n"
-		"	subu	%0, %1, %3				\n"
+		"	dsubu	%0, %1, %3				\n"
 		"	scd	%0, %2					\n"
 		"	beqz	%0, 2f					\n"
-		"	subu	%0, %1, %3				\n"
+		"	dsubu	%0, %1, %3				\n"
 		"	.subsection 2					\n"
 		"2:	b	1b					\n"
 		"	.previous					\n"
-- 
1.7.3.3

