Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab2HSDC0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:02:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:44069 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928Ab2HSC5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="204911351"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 45/74] lto: Mark rwsem functions that can be called from assembler asmlinkage
Date: Sat, 18 Aug 2012 19:56:41 -0700
Message-Id: <1345345030-22211-46-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 lib/rwsem.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 8337e1b..4a33b58 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -222,6 +222,7 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 /*
  * wait for the read lock to be granted
  */
+__visible
 struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 {
 	return rwsem_down_failed_common(sem, RWSEM_WAITING_FOR_READ,
@@ -231,6 +232,7 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 /*
  * wait for the write lock to be granted
  */
+__visible
 struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 {
 	return rwsem_down_failed_common(sem, RWSEM_WAITING_FOR_WRITE,
@@ -241,6 +243,7 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
  * handle waking up a waiter on the semaphore
  * - up_read/up_write has decremented the active part of count if we come here
  */
+__visible
 struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
@@ -261,6 +264,7 @@ struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
  * - caller incremented waiting part of count and discovered it still negative
  * - just wake up any readers at the front of the queue
  */
+__visible
 struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
-- 
1.7.7.6

