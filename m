Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156Ab0IXQf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:35:58 -0400
Received: from kroah.org ([198.145.64.141]:37445 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932984Ab0IXQf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:56 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:49 2010
Message-Id: <20100924163349.342404390@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-mips@linux-mips.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Daney <ddaney@caviumnetworks.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [60/68] MIPS: Quit using undefined behavior of ADDU in 64-bit atomic operations.
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Daney <ddaney@caviumnetworks.com>

commit f2a68272d799bf4092443357142f63b74f7669a1 upstream.

For 64-bit, we must use DADDU and DSUBU.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/1483/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/mips/include/asm/atomic.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -434,7 +434,7 @@ static __inline__ void atomic64_add(long
 		__asm__ __volatile__(
 		"	.set	mips3					\n"
 		"1:	lld	%0, %1		# atomic64_add		\n"
-		"	addu	%0, %2					\n"
+		"	daddu	%0, %2					\n"
 		"	scd	%0, %1					\n"
 		"	beqzl	%0, 1b					\n"
 		"	.set	mips0					\n"
@@ -446,7 +446,7 @@ static __inline__ void atomic64_add(long
 		__asm__ __volatile__(
 		"	.set	mips3					\n"
 		"1:	lld	%0, %1		# atomic64_add		\n"
-		"	addu	%0, %2					\n"
+		"	daddu	%0, %2					\n"
 		"	scd	%0, %1					\n"
 		"	beqz	%0, 2f					\n"
 		"	.subsection 2					\n"
@@ -479,7 +479,7 @@ static __inline__ void atomic64_sub(long
 		__asm__ __volatile__(
 		"	.set	mips3					\n"
 		"1:	lld	%0, %1		# atomic64_sub		\n"
-		"	subu	%0, %2					\n"
+		"	dsubu	%0, %2					\n"
 		"	scd	%0, %1					\n"
 		"	beqzl	%0, 1b					\n"
 		"	.set	mips0					\n"
@@ -491,7 +491,7 @@ static __inline__ void atomic64_sub(long
 		__asm__ __volatile__(
 		"	.set	mips3					\n"
 		"1:	lld	%0, %1		# atomic64_sub		\n"
-		"	subu	%0, %2					\n"
+		"	dsubu	%0, %2					\n"
 		"	scd	%0, %1					\n"
 		"	beqz	%0, 2f					\n"
 		"	.subsection 2					\n"
@@ -524,10 +524,10 @@ static __inline__ long atomic64_add_retu
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
@@ -538,10 +538,10 @@ static __inline__ long atomic64_add_retu
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
@@ -576,10 +576,10 @@ static __inline__ long atomic64_sub_retu
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
@@ -590,10 +590,10 @@ static __inline__ long atomic64_sub_retu
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


