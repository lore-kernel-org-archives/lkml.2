Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab1CDLwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:52:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:41910 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab1CDLwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:52:13 -0500
Date: Fri, 4 Mar 2011 11:51:43 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4D6F347E.2010806@cn.fujitsu.com>
References: <4D6F347E.2010806@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf cgroup: Clean up perf_cgroup_create()
Message-ID: <tip-1b15d0558e82df9b3659804ceb44187b98eda354@git.kernel.org>
Git-Commit-ID: 1b15d0558e82df9b3659804ceb44187b98eda354
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 04 Mar 2011 11:51:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b15d0558e82df9b3659804ceb44187b98eda354
Gitweb:     http://git.kernel.org/tip/1b15d0558e82df9b3659804ceb44187b98eda354
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 3 Mar 2011 14:26:06 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Mar 2011 11:32:51 +0100

perf cgroup: Clean up perf_cgroup_create()

- Use kzalloc() to replace kmalloc() + memset().

- Remove redundant initialization, since alloc_percpu() returns
  zero-filled percpu memory.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4D6F347E.2010806@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index b002095..193b190 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -7346,26 +7346,17 @@ static struct cgroup_subsys_state *perf_cgroup_create(
 	struct cgroup_subsys *ss, struct cgroup *cont)
 {
 	struct perf_cgroup *jc;
-	struct perf_cgroup_info *t;
-	int c;
 
-	jc = kmalloc(sizeof(*jc), GFP_KERNEL);
+	jc = kzalloc(sizeof(*jc), GFP_KERNEL);
 	if (!jc)
 		return ERR_PTR(-ENOMEM);
 
-	memset(jc, 0, sizeof(*jc));
-
 	jc->info = alloc_percpu(struct perf_cgroup_info);
 	if (!jc->info) {
 		kfree(jc);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	for_each_possible_cpu(c) {
-		t = per_cpu_ptr(jc->info, c);
-		t->time = 0;
-		t->timestamp = 0;
-	}
 	return &jc->css;
 }
 
