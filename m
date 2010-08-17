Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab0HQHZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:25:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:2003 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab0HQHZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:25:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,381,1278313200"; 
   d="scan'208";a="648465328"
Subject: [PATCH] kfifo, Add parenthesis for macro parameter reference
From: Huang Ying <ying.huang@intel.com>
To: Stefani Seibold <stefani@seibold.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 15:25:13 +0800
Message-ID: <1282029913.2744.1511.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some macro parameter references inside typeof() operator are not enclosed
with parenthesis. It should be safer to add them.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 include/linux/kfifo.h |   58 +++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -214,7 +214,7 @@ __kfifo_must_check_helper(unsigned int v
  */
 #define kfifo_reset(fifo) \
 (void)({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	__tmp->kfifo.in = __tmp->kfifo.out = 0; \
 })
 
@@ -228,7 +228,7 @@ __kfifo_must_check_helper(unsigned int v
  */
 #define kfifo_reset_out(fifo)	\
 (void)({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	__tmp->kfifo.out = __tmp->kfifo.in; \
 })
 
@@ -238,7 +238,7 @@ __kfifo_must_check_helper(unsigned int v
  */
 #define kfifo_len(fifo) \
 ({ \
-	typeof(fifo + 1) __tmpl = (fifo); \
+	typeof((fifo) + 1) __tmpl = (fifo); \
 	__tmpl->kfifo.in - __tmpl->kfifo.out; \
 })
 
@@ -248,7 +248,7 @@ __kfifo_must_check_helper(unsigned int v
  */
 #define	kfifo_is_empty(fifo) \
 ({ \
-	typeof(fifo + 1) __tmpq = (fifo); \
+	typeof((fifo) + 1) __tmpq = (fifo); \
 	__tmpq->kfifo.in == __tmpq->kfifo.out; \
 })
 
@@ -258,7 +258,7 @@ __kfifo_must_check_helper(unsigned int v
  */
 #define	kfifo_is_full(fifo) \
 ({ \
-	typeof(fifo + 1) __tmpq = (fifo); \
+	typeof((fifo) + 1) __tmpq = (fifo); \
 	kfifo_len(__tmpq) > __tmpq->kfifo.mask; \
 })
 
@@ -269,7 +269,7 @@ __kfifo_must_check_helper(unsigned int v
 #define	kfifo_avail(fifo) \
 __kfifo_must_check_helper( \
 ({ \
-	typeof(fifo + 1) __tmpq = (fifo); \
+	typeof((fifo) + 1) __tmpq = (fifo); \
 	const size_t __recsize = sizeof(*__tmpq->rectype); \
 	unsigned int __avail = kfifo_size(__tmpq) - kfifo_len(__tmpq); \
 	(__recsize) ? ((__avail <= __recsize) ? 0 : \
@@ -284,7 +284,7 @@ __kfifo_must_check_helper( \
  */
 #define	kfifo_skip(fifo) \
 (void)({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
 	if (__recsize) \
@@ -302,7 +302,7 @@ __kfifo_must_check_helper( \
 #define kfifo_peek_len(fifo) \
 __kfifo_must_check_helper( \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
 	(!__recsize) ? kfifo_len(__tmp) * sizeof(*__tmp->type) : \
@@ -325,7 +325,7 @@ __kfifo_must_check_helper( \
 #define kfifo_alloc(fifo, size, gfp_mask) \
 __kfifo_must_check_helper( \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
 	__is_kfifo_ptr(__tmp) ? \
 	__kfifo_alloc(__kfifo, size, sizeof(*__tmp->type), gfp_mask) : \
@@ -339,7 +339,7 @@ __kfifo_must_check_helper( \
  */
 #define kfifo_free(fifo) \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
 	if (__is_kfifo_ptr(__tmp)) \
 		__kfifo_free(__kfifo); \
@@ -358,7 +358,7 @@ __kfifo_must_check_helper( \
  */
 #define kfifo_init(fifo, buffer, size) \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
 	__is_kfifo_ptr(__tmp) ? \
 	__kfifo_init(__kfifo, buffer, size, sizeof(*__tmp->type)) : \
@@ -379,8 +379,8 @@ __kfifo_must_check_helper( \
  */
 #define	kfifo_put(fifo, val) \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
-	typeof(val + 1) __val = (val); \
+	typeof((fifo) + 1) __tmp = (fifo); \
+	typeof((val) + 1) __val = (val); \
 	unsigned int __ret; \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
@@ -421,8 +421,8 @@ __kfifo_must_check_helper( \
 #define	kfifo_get(fifo, val) \
 __kfifo_must_check_helper( \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
-	typeof(val + 1) __val = (val); \
+	typeof((fifo) + 1) __tmp = (fifo); \
+	typeof((val) + 1) __val = (val); \
 	unsigned int __ret; \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
@@ -462,8 +462,8 @@ __kfifo_must_check_helper( \
 #define	kfifo_peek(fifo, val) \
 __kfifo_must_check_helper( \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
-	typeof(val + 1) __val = (val); \
+	typeof((fifo) + 1) __tmp = (fifo); \
+	typeof((val) + 1) __val = (val); \
 	unsigned int __ret; \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
@@ -501,8 +501,8 @@ __kfifo_must_check_helper( \
  */
 #define	kfifo_in(fifo, buf, n) \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
-	typeof(buf + 1) __buf = (buf); \
+	typeof((fifo) + 1) __tmp = (fifo); \
+	typeof((buf) + 1) __buf = (buf); \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
@@ -554,8 +554,8 @@ __kfifo_must_check_helper( \
 #define	kfifo_out(fifo, buf, n) \
 __kfifo_must_check_helper( \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
-	typeof(buf + 1) __buf = (buf); \
+	typeof((fifo) + 1) __tmp = (fifo); \
+	typeof((buf) + 1) __buf = (buf); \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
@@ -611,7 +611,7 @@ __kfifo_must_check_helper( \
 #define	kfifo_from_user(fifo, from, len, copied) \
 __kfifo_must_check_helper( \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	const void __user *__from = (from); \
 	unsigned int __len = (len); \
 	unsigned int *__copied = (copied); \
@@ -639,7 +639,7 @@ __kfifo_must_check_helper( \
 #define	kfifo_to_user(fifo, to, len, copied) \
 __kfifo_must_check_helper( \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	void __user *__to = (to); \
 	unsigned int __len = (len); \
 	unsigned int *__copied = (copied); \
@@ -666,7 +666,7 @@ __kfifo_must_check_helper( \
  */
 #define	kfifo_dma_in_prepare(fifo, sgl, nents, len) \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	struct scatterlist *__sgl = (sgl); \
 	int __nents = (nents); \
 	unsigned int __len = (len); \
@@ -690,7 +690,7 @@ __kfifo_must_check_helper( \
  */
 #define kfifo_dma_in_finish(fifo, len) \
 (void)({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	unsigned int __len = (len); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
@@ -717,7 +717,7 @@ __kfifo_must_check_helper( \
  */
 #define	kfifo_dma_out_prepare(fifo, sgl, nents, len) \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo);  \
 	struct scatterlist *__sgl = (sgl); \
 	int __nents = (nents); \
 	unsigned int __len = (len); \
@@ -741,7 +741,7 @@ __kfifo_must_check_helper( \
  */
 #define kfifo_dma_out_finish(fifo, len) \
 (void)({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	unsigned int __len = (len); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
@@ -766,8 +766,8 @@ __kfifo_must_check_helper( \
 #define	kfifo_out_peek(fifo, buf, n) \
 __kfifo_must_check_helper( \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
-	typeof(buf + 1) __buf = (buf); \
+	typeof((fifo) + 1) __tmp = (fifo); \
+	typeof((buf) + 1) __buf = (buf); \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \


