Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab1KRXaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:30:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53281 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757156Ab1KRXaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:30:13 -0500
Date: Fri, 18 Nov 2011 15:29:56 -0800
From: "tip-bot for J. Bruce Fields" <bfields@redhat.com>
Message-ID: <tip-c6dc7f055d333ef35f397b8d7c3abcd1918bf8cb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, bfields@redhat.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, bfields@redhat.com,
        mingo@elte.hu
In-Reply-To: <20111006192246.GB28026@fieldses.org>
References: <20111006192246.GB28026@fieldses.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Document wait_for_completion_*() return values
Git-Commit-ID: c6dc7f055d333ef35f397b8d7c3abcd1918bf8cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:30:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c6dc7f055d333ef35f397b8d7c3abcd1918bf8cb
Gitweb:     http://git.kernel.org/tip/c6dc7f055d333ef35f397b8d7c3abcd1918bf8cb
Author:     J. Bruce Fields <bfields@redhat.com>
AuthorDate: Thu, 6 Oct 2011 15:22:46 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Nov 2011 12:50:37 +0100

sched: Document wait_for_completion_*() return values

The return-value convention for these functions varies depending on
whether they're interruptible or can timeout.  It can be a little
confusing--document it.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20111006192246.GB28026@fieldses.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0e9344a..3d2c436 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4810,6 +4810,9 @@ EXPORT_SYMBOL(wait_for_completion);
  * This waits for either a completion of a specific task to be signaled or for a
  * specified timeout to expire. The timeout is in jiffies. It is not
  * interruptible.
+ *
+ * The return value is 0 if timed out, and positive (at least 1, or number of
+ * jiffies left till timeout) if completed.
  */
 unsigned long __sched
 wait_for_completion_timeout(struct completion *x, unsigned long timeout)
@@ -4824,6 +4827,8 @@ EXPORT_SYMBOL(wait_for_completion_timeout);
  *
  * This waits for completion of a specific task to be signaled. It is
  * interruptible.
+ *
+ * The return value is -ERESTARTSYS if interrupted, 0 if completed.
  */
 int __sched wait_for_completion_interruptible(struct completion *x)
 {
@@ -4841,6 +4846,9 @@ EXPORT_SYMBOL(wait_for_completion_interruptible);
  *
  * This waits for either a completion of a specific task to be signaled or for a
  * specified timeout to expire. It is interruptible. The timeout is in jiffies.
+ *
+ * The return value is -ERESTARTSYS if interrupted, 0 if timed out,
+ * positive (at least 1, or number of jiffies left till timeout) if completed.
  */
 long __sched
 wait_for_completion_interruptible_timeout(struct completion *x,
@@ -4856,6 +4864,8 @@ EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);
  *
  * This waits to be signaled for completion of a specific task. It can be
  * interrupted by a kill signal.
+ *
+ * The return value is -ERESTARTSYS if interrupted, 0 if completed.
  */
 int __sched wait_for_completion_killable(struct completion *x)
 {
@@ -4874,6 +4884,9 @@ EXPORT_SYMBOL(wait_for_completion_killable);
  * This waits for either a completion of a specific task to be
  * signaled or for a specified timeout to expire. It can be
  * interrupted by a kill signal. The timeout is in jiffies.
+ *
+ * The return value is -ERESTARTSYS if interrupted, 0 if timed out,
+ * positive (at least 1, or number of jiffies left till timeout) if completed.
  */
 long __sched
 wait_for_completion_killable_timeout(struct completion *x,
