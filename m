Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab1A0L62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 06:58:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:40729 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab1A0L60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 06:58:26 -0500
Date: Thu, 27 Jan 2011 11:58:07 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, chris@zankel.net, lethal@linux-sh.org,
        tony.luck@intel.com, davem@davemloft.net, dhowells@redhat.com,
        benh@kernel.crashing.org, mattst88@gmail.com,
        heiko.carstens@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tony.luck@intel.com, lethal@linux-sh.org,
        chris@zankel.net, davem@davemloft.net, dhowells@redhat.com,
        benh@kernel.crashing.org, mattst88@gmail.com,
        heiko.carstens@de.ibm.com, tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.00.1101262130450.31804@localhost6.localdomain6>
References: <alpine.LFD.2.00.1101262130450.31804@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] rwsem: Remove redundant asmregparm annotation
Message-ID: <tip-d123375425d7df4b6081a631fc1203fceafa59b2@git.kernel.org>
Git-Commit-ID: d123375425d7df4b6081a631fc1203fceafa59b2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 27 Jan 2011 11:58:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d123375425d7df4b6081a631fc1203fceafa59b2
Gitweb:     http://git.kernel.org/tip/d123375425d7df4b6081a631fc1203fceafa59b2
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 26 Jan 2011 21:32:01 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 27 Jan 2011 12:30:40 +0100

rwsem: Remove redundant asmregparm annotation

Peter Zijlstra pointed out, that the only user of asmregparm (x86) is
compiling the kernel already with -mregparm=3. So the annotation of
the rwsem functions is redundant. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David Miller <davem@davemloft.net>
Cc: Chris Zankel <chris@zankel.net>
LKML-Reference: <alpine.LFD.2.00.1101262130450.31804@localhost6.localdomain6>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/rwsem.h |    8 ++++----
 lib/rwsem.c           |   10 ++++------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index f7c957f..a8afe9c 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
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
diff --git a/lib/rwsem.c b/lib/rwsem.c
index f236d7c..aa7c305 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -222,8 +222,7 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 /*
  * wait for the read lock to be granted
  */
-asmregparm struct rw_semaphore __sched *
-rwsem_down_read_failed(struct rw_semaphore *sem)
+struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 {
 	return rwsem_down_failed_common(sem, RWSEM_WAITING_FOR_READ,
 					-RWSEM_ACTIVE_READ_BIAS);
@@ -232,8 +231,7 @@ rwsem_down_read_failed(struct rw_semaphore *sem)
 /*
  * wait for the write lock to be granted
  */
-asmregparm struct rw_semaphore __sched *
-rwsem_down_write_failed(struct rw_semaphore *sem)
+struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 {
 	return rwsem_down_failed_common(sem, RWSEM_WAITING_FOR_WRITE,
 					-RWSEM_ACTIVE_WRITE_BIAS);
@@ -243,7 +241,7 @@ rwsem_down_write_failed(struct rw_semaphore *sem)
  * handle waking up a waiter on the semaphore
  * - up_read/up_write has decremented the active part of count if we come here
  */
-asmregparm struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
+struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
@@ -263,7 +261,7 @@ asmregparm struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
  * - caller incremented waiting part of count and discovered it still negative
  * - just wake up any readers at the front of the queue
  */
-asmregparm struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
+struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
