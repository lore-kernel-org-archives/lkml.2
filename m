Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338Ab2GFVGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:06:39 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60827 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758293Ab2GFVGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:06:36 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 01/36] atomic64_test: Simplify the #ifdef for atomic64_dec_if_positive() test
Date: Fri,  6 Jul 2012 22:05:42 +0100
Message-Id: <1341608777-12982-2-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 06 Jul 2012 21:07:29.0204 (UTC) FILETIME=[5A165F40:01CD5BBB]
X-MC-Unique: 112070622063502201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q66L6ipc005307

This patch introduces ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE and uses this
instead of the multitude of #if defined() checks in atomic64_test.c

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/atomic.h      |    1 +
 arch/mips/include/asm/atomic.h     |    1 +
 arch/powerpc/include/asm/atomic.h  |    1 +
 arch/s390/include/asm/atomic.h     |    1 +
 arch/x86/include/asm/atomic64_32.h |    1 +
 arch/x86/include/asm/atomic64_64.h |    1 +
 lib/atomic64_test.c                |    3 +--
 7 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index 68374ba..a2f5a44 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -395,6 +395,7 @@ static inline u64 atomic64_xchg(atomic64_t *ptr, u64 new)
 	return result;
 }
 
+#define ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 static inline u64 atomic64_dec_if_positive(atomic64_t *v)
 {
 	u64 result;
diff --git a/arch/mips/include/asm/atomic.h b/arch/mips/include/asm/atomic.h
index 3f4c5cb..4af30f2 100644
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -736,6 +736,7 @@ static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
  * atomic64_dec_if_positive - decrement by 1 if old value positive
  * @v: pointer of type atomic64_t
  */
+#define ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 #define atomic64_dec_if_positive(v)	atomic64_sub_if_positive(1, v)
 
 /*
diff --git a/arch/powerpc/include/asm/atomic.h b/arch/powerpc/include/asm/atomic.h
index da29032..e235d76 100644
--- a/arch/powerpc/include/asm/atomic.h
+++ b/arch/powerpc/include/asm/atomic.h
@@ -439,6 +439,7 @@ static __inline__ long atomic64_dec_return(atomic64_t *v)
  * Atomically test *v and decrement if it is greater than 0.
  * The function returns the old value of *v minus 1.
  */
+#define ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 static __inline__ long atomic64_dec_if_positive(atomic64_t *v)
 {
 	long t;
diff --git a/arch/s390/include/asm/atomic.h b/arch/s390/include/asm/atomic.h
index 748347b..dcd174f 100644
--- a/arch/s390/include/asm/atomic.h
+++ b/arch/s390/include/asm/atomic.h
@@ -297,6 +297,7 @@ static inline int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 	return c != u;
 }
 
+#define ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 static inline long long atomic64_dec_if_positive(atomic64_t *v)
 {
 	long long c, old, dec;
diff --git a/arch/x86/include/asm/atomic64_32.h b/arch/x86/include/asm/atomic64_32.h
index b154de7..4690ce2 100644
--- a/arch/x86/include/asm/atomic64_32.h
+++ b/arch/x86/include/asm/atomic64_32.h
@@ -302,6 +302,7 @@ static inline int atomic64_inc_not_zero(atomic64_t *v)
 	return r;
 }
 
+#define ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 static inline long long atomic64_dec_if_positive(atomic64_t *v)
 {
 	long long r;
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
index 0e1cbfc..2dd1ae3 100644
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -224,6 +224,7 @@ static inline int atomic64_add_unless(atomic64_t *v, long a, long u)
  * The function returns the old value of *v minus 1, even if
  * the atomic variable, v, was not decremented.
  */
+#define ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 static inline long atomic64_dec_if_positive(atomic64_t *v)
 {
 	long c, old, dec;
diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
index cb99b91..4f8429d 100644
--- a/lib/atomic64_test.c
+++ b/lib/atomic64_test.c
@@ -114,8 +114,7 @@ static __init int test_atomic64(void)
 	r += one;
 	BUG_ON(v.counter != r);
 
-#if defined(CONFIG_X86) || defined(CONFIG_MIPS) || defined(CONFIG_PPC) || \
-    defined(CONFIG_S390) || defined(_ASM_GENERIC_ATOMIC64_H) || defined(CONFIG_ARM)
+#if defined(ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE) || defined(CONFIG_GENERIC_ATOMIC64)
 	INIT(onestwos);
 	BUG_ON(atomic64_dec_if_positive(&v) != (onestwos - 1));
 	r -= one;

