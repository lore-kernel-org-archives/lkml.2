Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab0EROtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 10:49:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:51264 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387Ab0EROtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 10:49:14 -0400
Date: Tue, 18 May 2010 14:48:43 GMT
From: tip-bot for Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       benh@kernel.crashing.org, akpm@linux-foundation.org, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <201005141841.o4EIfcl0015387@imap1.linux-foundation.org>
References: <201005141841.o4EIfcl0015387@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] kernel/mutex.c: Fix unused var warning
Message-ID: <tip-0f14452563e342637f9a3a2f036cac7315081b2b@git.kernel.org>
Git-Commit-ID: 0f14452563e342637f9a3a2f036cac7315081b2b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 May 2010 14:48:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f14452563e342637f9a3a2f036cac7315081b2b
Gitweb:     http://git.kernel.org/tip/0f14452563e342637f9a3a2f036cac7315081b2b
Author:     Andrew Morton <akpm@linux-foundation.org>
AuthorDate: Fri, 14 May 2010 11:13:48 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 May 2010 16:46:03 +0200

kernel/mutex.c: Fix unused var warning

kernel/mutex.c: In function '__mutex_lock_common':
 kernel/mutex.c:148: warning: unused variable 'timeout'

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <201005141841.o4EIfcl0015387@imap1.linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/mutex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index 7d4626b..b998c6e 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -145,7 +145,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
 	unsigned long flags;
-	unsigned long timeout;
+	unsigned long timeout __maybe_unused;
 
 	preempt_disable();
 	mutex_acquire(&lock->dep_map, subclass, 0, ip);
