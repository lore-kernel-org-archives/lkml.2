Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab0LPMdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 07:33:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:36380 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667Ab0LPMc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 07:32:56 -0500
Date: Thu, 16 Dec 2010 12:32:36 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101117222056.206992649@chello.nl>
References: <20101117222056.206992649@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] init: Initialized IDR earlier
Message-ID: <tip-9f58a205c62d0dad1df38d076324a89b1a0f1d65@git.kernel.org>
Git-Commit-ID: 9f58a205c62d0dad1df38d076324a89b1a0f1d65
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Dec 2010 12:32:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f58a205c62d0dad1df38d076324a89b1a0f1d65
Gitweb:     http://git.kernel.org/tip/9f58a205c62d0dad1df38d076324a89b1a0f1d65
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 17 Nov 2010 23:17:35 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 16 Dec 2010 11:36:43 +0100

init: Initialized IDR earlier

perf_event_init() wants to start using IDR trees, its needs in turn
are satisfied by mm_init().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101117222056.206992649@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 init/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index 559e862..ea51770 100644
--- a/init/main.c
+++ b/init/main.c
@@ -604,6 +604,7 @@ asmlinkage void __init start_kernel(void)
 				"enabled *very* early, fixing it\n");
 		local_irq_disable();
 	}
+	idr_init_cache();
 	perf_event_init();
 	rcu_init();
 	radix_tree_init();
@@ -660,7 +661,6 @@ asmlinkage void __init start_kernel(void)
 	enable_debug_pagealloc();
 	kmemleak_init();
 	debug_objects_mem_init();
-	idr_init_cache();
 	setup_per_cpu_pageset();
 	numa_policy_init();
 	if (late_time_init)
