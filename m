Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab0EDRFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:05:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:49614 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932286Ab0EDRFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:05:39 -0400
Date: Tue, 4 May 2010 17:04:46 GMT
From: tip-bot for Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, tom.leiming@gmail.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tglx@linutronix.de, tom.leiming@gmail.com,
       mingo@elte.hu
In-Reply-To: <1272988872-2347-1-git-send-email-tom.leiming@gmail.com>
References: <1272988872-2347-1-git-send-email-tom.leiming@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep, fork: Fix dependency of hardirqs_enabled and softirqs_enabled
Message-ID: <tip-9ca79f1559dc54268bdf129c0b2a1e2bcebeb0d5@git.kernel.org>
Git-Commit-ID: 9ca79f1559dc54268bdf129c0b2a1e2bcebeb0d5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 17:04:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ca79f1559dc54268bdf129c0b2a1e2bcebeb0d5
Gitweb:     http://git.kernel.org/tip/9ca79f1559dc54268bdf129c0b2a1e2bcebeb0d5
Author:     Ming Lei <tom.leiming@gmail.com>
AuthorDate: Wed, 5 May 2010 00:01:12 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 May 2010 18:33:20 +0200

lockdep, fork: Fix dependency of hardirqs_enabled and softirqs_enabled

The defination of hardirqs_enabled and softirqs_enabled in
task_struct depends on CONFIG_TRACE_IRQFLAGS instead of
CONFIG_PROVE_LOCKING.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1272988872-2347-1-git-send-email-tom.leiming@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/fork.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 44b0791..038a8fd 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1004,7 +1004,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	rt_mutex_init_task(p);
 
-#ifdef CONFIG_PROVE_LOCKING
+#ifdef CONFIG_TRACE_IRQFLAGS
 	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
