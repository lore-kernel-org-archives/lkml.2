Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab1GGP2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:28:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35213 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab1GGP2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:28:42 -0400
Subject: [TRIVIAL][PATCH v2 2/2] futex: uninitialized warning corrections
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: trivial@kernel.org, Darren Hart <dvhart@linux.intel.com>,
        vitalivanov@gmail.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jul 2011 18:30:20 +0300
Message-ID: <1310052620.3528.44.camel@vivanov>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5478e18008a7f144b70931f38cc30a177e14c930 Mon Sep 17 00:00:00 2001
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Date: Thu, 7 Jul 2011 15:10:31 +0300
Subject: [PATCH 2/2] futex: uninitialized warning corrections

The variables here are really not used uninitialized.

kernel/futex.c: In function 'fixup_pi_state_owner.clone.17':
kernel/futex.c:1582:6: warning: 'curval' may be used uninitialized in this function
kernel/futex.c: In function 'handle_futex_death':
kernel/futex.c:2486:6: warning: 'nval' may be used uninitialized in this function
kernel/futex.c: In function 'do_futex':
kernel/futex.c:863:11: warning: 'curval' may be used uninitialized in this function
kernel/futex.c:828:6: note: 'curval' was declared here
kernel/futex.c:898:5: warning: 'oldval' may be used uninitialized in this function
kernel/futex.c:890:6: note: 'oldval' was declared here

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
Acked-by: Darren Hart <dvhart@linux.intel.com>
---
 kernel/futex.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index fe28dc2..efb8e5b 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -825,7 +825,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 {
 	struct task_struct *new_owner;
 	struct futex_pi_state *pi_state = this->pi_state;
-	u32 curval, newval;
+	u32 uninitialized_var(curval), newval;
 
 	if (!pi_state)
 		return -EINVAL;
@@ -887,7 +887,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 
 static int unlock_futex_pi(u32 __user *uaddr, u32 uval)
 {
-	u32 oldval;
+	u32 uninitialized_var(oldval);
 
 	/*
 	 * There is no waiter, so we unlock the futex. The owner died
@@ -1546,7 +1546,7 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	u32 newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
 	struct futex_pi_state *pi_state = q->pi_state;
 	struct task_struct *oldowner = pi_state->owner;
-	u32 uval, curval, newval;
+	u32 uval, uninitialized_var(curval), newval;
 	int ret;
 
 	/* Owner died? */
@@ -2451,7 +2451,7 @@ err_unlock:
  */
 int handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi)
 {
-	u32 uval, nval, mval;
+	u32 uval, uninitialized_var(nval), mval;
 
 retry:
 	if (get_user(uval, uaddr))
-- 
1.7.0.4



