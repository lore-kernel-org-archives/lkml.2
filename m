Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab0HaPwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:52:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab0HaPwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:52:32 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/3] h8300: IRQ flags should be stored in an unsigned long
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: ysato@users.sourceforge.jp, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Tue, 31 Aug 2010 16:52:11 +0100
Message-ID: <20100831155211.10885.62967.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix h8300's asm/atomic.h to store the IRQ flags in an unsigned long to deal
with warnings of the following type:

/warthog/nfs/linux-2.6-fscache/arch/h8300/include/asm/atomic.h: In function 'atomic_add_return':
/warthog/nfs/linux-2.6-fscache/arch/h8300/include/asm/atomic.h:22: warning: comparison of distinct pointer types lacks a cast
/warthog/nfs/linux-2.6-fscache/arch/h8300/include/asm/atomic.h:24: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/h8300/include/asm/atomic.h |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/h8300/include/asm/atomic.h b/arch/h8300/include/asm/atomic.h
index e936804..984221a 100644
--- a/arch/h8300/include/asm/atomic.h
+++ b/arch/h8300/include/asm/atomic.h
@@ -18,7 +18,8 @@
 
 static __inline__ int atomic_add_return(int i, atomic_t *v)
 {
-	int ret,flags;
+	unsigned long flags;
+	int ret;
 	local_irq_save(flags);
 	ret = v->counter += i;
 	local_irq_restore(flags);
@@ -30,7 +31,8 @@ static __inline__ int atomic_add_return(int i, atomic_t *v)
 
 static __inline__ int atomic_sub_return(int i, atomic_t *v)
 {
-	int ret,flags;
+	unsigned long flags;
+	int ret;
 	local_irq_save(flags);
 	ret = v->counter -= i;
 	local_irq_restore(flags);
@@ -42,7 +44,8 @@ static __inline__ int atomic_sub_return(int i, atomic_t *v)
 
 static __inline__ int atomic_inc_return(atomic_t *v)
 {
-	int ret,flags;
+	unsigned long flags;
+	int ret;
 	local_irq_save(flags);
 	v->counter++;
 	ret = v->counter;
@@ -64,7 +67,8 @@ static __inline__ int atomic_inc_return(atomic_t *v)
 
 static __inline__ int atomic_dec_return(atomic_t *v)
 {
-	int ret,flags;
+	unsigned long flags;
+	int ret;
 	local_irq_save(flags);
 	--v->counter;
 	ret = v->counter;
@@ -76,7 +80,8 @@ static __inline__ int atomic_dec_return(atomic_t *v)
 
 static __inline__ int atomic_dec_and_test(atomic_t *v)
 {
-	int ret,flags;
+	unsigned long flags;
+	int ret;
 	local_irq_save(flags);
 	--v->counter;
 	ret = v->counter;

