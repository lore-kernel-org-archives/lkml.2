Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab0JNHla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 03:41:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:37671 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab0JNHl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 03:41:28 -0400
Date: Thu, 14 Oct 2010 07:40:44 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rusty@rustcorp.com.au, peterz@infradead.org, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, tj@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: ananth@in.ibm.com, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        rusty@rustcorp.com.au, peterz@infradead.org, tj@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101014031030.4100.34156.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101014031030.4100.34156.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] stopmachine: Define __stop_machine when CONFIG_STOP_MACHINE=n
Message-ID: <tip-087a4eb55971dfcc8df18312faf9393d0a479f3a@git.kernel.org>
Git-Commit-ID: 087a4eb55971dfcc8df18312faf9393d0a479f3a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Oct 2010 07:40:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  087a4eb55971dfcc8df18312faf9393d0a479f3a
Gitweb:     http://git.kernel.org/tip/087a4eb55971dfcc8df18312faf9393d0a479f3a
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 14 Oct 2010 12:10:30 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Oct 2010 08:55:28 +0200

stopmachine: Define __stop_machine when CONFIG_STOP_MACHINE=n

Define dummy __stop_machine() function even when
CONFIG_STOP_MACHINE=n. This getcpu-required version of
stop_machine() will be used from poke_text_smp().

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20101014031030.4100.34156.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/stop_machine.h |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 6b524a0..1808960 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -126,8 +126,8 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
 
 #else	 /* CONFIG_STOP_MACHINE && CONFIG_SMP */
 
-static inline int stop_machine(int (*fn)(void *), void *data,
-			       const struct cpumask *cpus)
+static inline int __stop_machine(int (*fn)(void *), void *data,
+				 const struct cpumask *cpus)
 {
 	int ret;
 	local_irq_disable();
@@ -136,5 +136,11 @@ static inline int stop_machine(int (*fn)(void *), void *data,
 	return ret;
 }
 
+static inline int stop_machine(int (*fn)(void *), void *data,
+			       const struct cpumask *cpus)
+{
+	return __stop_machine(fn, data, cpus);
+}
+
 #endif	/* CONFIG_STOP_MACHINE && CONFIG_SMP */
 #endif	/* _LINUX_STOP_MACHINE */
