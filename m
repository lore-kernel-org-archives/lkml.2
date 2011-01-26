Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab1AZUch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:32:37 -0500
Received: from www.tglx.de ([62.245.132.106]:36220 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab1AZUcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:32:35 -0500
Date: Wed, 26 Jan 2011 21:32:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, David Howells <dhowells@redhat.com>,
        x86@kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Henderson <rth@twiddle.net>, Tony Luck <tony.luck@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>
Subject: rwsem: rwsem: Remove redundant asmregparm annotation
In-Reply-To: <20110126195833.970840140@linutronix.de>
Message-ID: <alpine.LFD.2.00.1101262130450.31804@localhost6.localdomain6>
References: <20110126195810.247325792@linutronix.de> <20110126195833.970840140@linutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra pointed out, that the only user of asmregparm (x86) is
compiling the kernel already with -mregparm=3. So the annotation of
the rwsem functions is redundant. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/rwsem.h |    8 ++++----
 lib/rwsem.c           |   10 ++++------
 2 files changed, 8 insertions(+), 10 deletions(-)

Index: linux-2.6/include/linux/rwsem.h
===================================================================
--- linux-2.6.orig/include/linux/rwsem.h
+++ linux-2.6/include/linux/rwsem.h
@@ -32,10 +32,10 @@ struct rw_semaphore {
 #endif
 };
 
-extern asmregparm struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
-extern asmregparm struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
-extern asmregparm struct rw_semaphore *rwsem_wake(struct rw_semaphore *);
-extern asmregparm struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
+extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
+extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
+extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *);
+extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
 
 /* Include the arch specific part */
 #include <asm/rwsem.h>
Index: linux-2.6/lib/rwsem.c
===================================================================
--- linux-2.6.orig/lib/rwsem.c
+++ linux-2.6/lib/rwsem.c
@@ -222,8 +222,7 @@ rwsem_down_failed_common(struct rw_semap
 /*
  * wait for the read lock to be granted
  */
-asmregparm struct rw_semaphore __sched *
-rwsem_down_read_failed(struct rw_semaphore *sem)
+struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 {
 	return rwsem_down_failed_common(sem, RWSEM_WAITING_FOR_READ,
 					-RWSEM_ACTIVE_READ_BIAS);
@@ -232,8 +231,7 @@ rwsem_down_read_failed(struct rw_semapho
 /*
  * wait for the write lock to be granted
  */
-asmregparm struct rw_semaphore __sched *
-rwsem_down_write_failed(struct rw_semaphore *sem)
+struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 {
 	return rwsem_down_failed_common(sem, RWSEM_WAITING_FOR_WRITE,
 					-RWSEM_ACTIVE_WRITE_BIAS);
@@ -243,7 +241,7 @@ rwsem_down_write_failed(struct rw_semaph
  * handle waking up a waiter on the semaphore
  * - up_read/up_write has decremented the active part of count if we come here
  */
-asmregparm struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
+struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
@@ -263,7 +261,7 @@ asmregparm struct rw_semaphore *rwsem_wa
  * - caller incremented waiting part of count and discovered it still negative
  * - just wake up any readers at the front of the queue
  */
-asmregparm struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
+struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
