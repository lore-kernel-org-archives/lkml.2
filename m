Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab3AHXlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:41:18 -0500
Received: from mail.windriver.com ([147.11.1.11]:64296 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173Ab3AHXkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:40:23 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Matt Turner <mattst88@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 74/77] rwsem: Remove redundant asmregparm annotation
Date: Tue, 8 Jan 2013 18:35:53 -0500
Message-ID: <1357688156-25387-75-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d123375425d7df4b6081a631fc1203fceafa59b2 upstream.

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
[PG: fixes compile errors when using newer gcc on 2.6.34 baseline]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/include/asm/rwsem.h | 12 ++++--------
 lib/rwsem.c                  | 10 ++++------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index 606ede1..c46685c 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -45,14 +45,10 @@
 
 struct rwsem_waiter;
 
-extern asmregparm struct rw_semaphore *
- rwsem_down_read_failed(struct rw_semaphore *sem);
-extern asmregparm struct rw_semaphore *
- rwsem_down_write_failed(struct rw_semaphore *sem);
-extern asmregparm struct rw_semaphore *
- rwsem_wake(struct rw_semaphore *);
-extern asmregparm struct rw_semaphore *
- rwsem_downgrade_wake(struct rw_semaphore *sem);
+extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
+extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
+extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *);
+extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
 
 /*
  * the semaphore definition
diff --git a/lib/rwsem.c b/lib/rwsem.c
index ceba8e2..a112c06 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -188,8 +188,7 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 /*
  * wait for the read lock to be granted
  */
-asmregparm struct rw_semaphore __sched *
-rwsem_down_read_failed(struct rw_semaphore *sem)
+struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 {
 	struct rwsem_waiter waiter;
 
@@ -202,8 +201,7 @@ rwsem_down_read_failed(struct rw_semaphore *sem)
 /*
  * wait for the write lock to be granted
  */
-asmregparm struct rw_semaphore __sched *
-rwsem_down_write_failed(struct rw_semaphore *sem)
+struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 {
 	struct rwsem_waiter waiter;
 
@@ -217,7 +215,7 @@ rwsem_down_write_failed(struct rw_semaphore *sem)
  * handle waking up a waiter on the semaphore
  * - up_read/up_write has decremented the active part of count if we come here
  */
-asmregparm struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
+struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
@@ -237,7 +235,7 @@ asmregparm struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
  * - caller incremented waiting part of count and discovered it still negative
  * - just wake up any readers at the front of the queue
  */
-asmregparm struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
+struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
-- 
1.7.12.1

