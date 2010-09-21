Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab0IUON7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:13:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:46454 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756095Ab0IUON5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:13:57 -0400
Date: Tue, 21 Sep 2010 14:13:26 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tj@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tj@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20100917093009.252867712@chello.nl>
References: <20100917093009.252867712@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] percpu: Add {get,put}_cpu_ptr
Message-ID: <tip-8b8e2ec1eeca7f6941bc81cefc9663018d6ceb57@git.kernel.org>
Git-Commit-ID: 8b8e2ec1eeca7f6941bc81cefc9663018d6ceb57
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 21 Sep 2010 14:13:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b8e2ec1eeca7f6941bc81cefc9663018d6ceb57
Gitweb:     http://git.kernel.org/tip/8b8e2ec1eeca7f6941bc81cefc9663018d6ceb57
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 16 Sep 2010 19:21:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Sep 2010 13:55:43 +0200

percpu: Add {get,put}_cpu_ptr

These are similar to {get,put}_cpu_var() except for dynamically
allocated per-cpu memory.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Tejun Heo <tj@kernel.org>
LKML-Reference: <20100917093009.252867712@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/percpu.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 49466b1..0eb5083 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -39,6 +39,15 @@
 	preempt_enable();				\
 } while (0)
 
+#define get_cpu_ptr(var) ({				\
+	preempt_disable();				\
+	this_cpu_ptr(var); })
+
+#define put_cpu_ptr(var) do {				\
+	(void)(var);					\
+	preempt_enable();				\
+} while (0)
+
 #ifdef CONFIG_SMP
 
 /* minimum unit size, also is the maximum supported allocation size */
