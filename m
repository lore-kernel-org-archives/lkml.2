Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1GDXVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 19:21:32 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:48942 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab1GDXVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 19:21:30 -0400
Subject: [PATCH 4/4] futex: warning corrections
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Reply-To: vitalivanov@gmail.com
To: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jul 2011 02:21:28 +0300
Message-ID: <1309821688.4527.10.camel@vitaliy-Vostro-1400>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3f7997d71fe2b5cb16e2913928f68023855d786d Mon Sep 17 00:00:00 2001
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Date: Tue, 5 Jul 2011 02:07:42 +0300
Subject: [PATCH 4/4] futex: warning corrections
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

kernel/futex.c: In function ‘fixup_pi_state_owner.clone.17’:
kernel/futex.c:1582:6: warning: ‘curval’ may be used uninitialized in this function
kernel/futex.c: In function ‘handle_futex_death’:
kernel/futex.c:2486:6: warning: ‘nval’ may be used uninitialized in this function
kernel/futex.c: In function ‘do_futex’:
kernel/futex.c:863:11: warning: ‘curval’ may be used uninitialized in this function
kernel/futex.c:828:6: note: ‘curval’ was declared here
kernel/futex.c:898:5: warning: ‘oldval’ may be used uninitialized in this function
kernel/futex.c:890:6: note: ‘oldval’ was declared here

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
---
 kernel/futex.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index fe28dc2..516ebf9 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -825,7 +825,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 {
 	struct task_struct *new_owner;
 	struct futex_pi_state *pi_state = this->pi_state;
-	u32 curval, newval;
+	u32 curval = 0, newval;
 
 	if (!pi_state)
 		return -EINVAL;
@@ -887,7 +887,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 
 static int unlock_futex_pi(u32 __user *uaddr, u32 uval)
 {
-	u32 oldval;
+	u32 oldval = 0;
 
 	/*
 	 * There is no waiter, so we unlock the futex. The owner died
@@ -1546,7 +1546,7 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	u32 newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
 	struct futex_pi_state *pi_state = q->pi_state;
 	struct task_struct *oldowner = pi_state->owner;
-	u32 uval, curval, newval;
+	u32 uval, curval = 0, newval;
 	int ret;
 
 	/* Owner died? */
@@ -2451,7 +2451,7 @@ err_unlock:
  */
 int handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi)
 {
-	u32 uval, nval, mval;
+	u32 uval, nval = 0, mval;
 
 retry:
 	if (get_user(uval, uaddr))
-- 
1.7.4.1



