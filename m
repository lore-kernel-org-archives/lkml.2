Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab0IOKDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:03:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:39858 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147Ab0IOKDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:03:14 -0400
Date: Wed, 15 Sep 2010 10:02:42 GMT
From: tip-bot for Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, matt@console-pimps.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, matt@console-pimps.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20100913191729.GA6440@console-pimps.org>
References: <20100913191729.GA6440@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, sh: Fix patch merge foul-up
Message-ID: <tip-64a48d90149bb7007275fac13eaa4cb8d8ce12ea@git.kernel.org>
Git-Commit-ID: 64a48d90149bb7007275fac13eaa4cb8d8ce12ea
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Sep 2010 10:02:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  64a48d90149bb7007275fac13eaa4cb8d8ce12ea
Gitweb:     http://git.kernel.org/tip/64a48d90149bb7007275fac13eaa4cb8d8ce12ea
Author:     Matt Fleming <matt@console-pimps.org>
AuthorDate: Mon, 13 Sep 2010 20:17:29 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 15 Sep 2010 10:43:59 +0200

perf, sh: Fix patch merge foul-up

3f6da390 ("perf: Rework and fix the arch CPU-hotplug hooks") introduced
this breakage. sh_pmu_setup() is missing an opening curly brace.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100913191729.GA6440@console-pimps.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/sh/kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index cf39c48..036f7a9 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -338,7 +338,7 @@ static struct pmu pmu = {
 };
 
 static void sh_pmu_setup(int cpu)
-
+{
 	struct cpu_hw_events *cpuhw = &per_cpu(cpu_hw_events, cpu);
 
 	memset(cpuhw, 0, sizeof(struct cpu_hw_events));
