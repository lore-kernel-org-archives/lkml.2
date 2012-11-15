Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768502Ab2KOQyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:54:38 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:34710 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768413Ab2KOQyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:54:36 -0500
Subject: [RFC v2 PATCH 0/2] sched: Integrating Per-entity-load-tracking with
 the core scheduler
To: paulmck@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        a.p.zijlstra@chello.nl, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, amit.kucheria@linaro.org,
        Morten.Rasmussen@arm.com, paul.mckenney@linaro.org,
        akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org, pjt@google.com
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: venki@google.com, robin.randhawa@arm.com, linaro-dev@lists.linaro.org,
        suresh.b.siddha@intel.com, mjg59@srcf.ucam.org,
        deepthi@linux.vnet.ibm.com, srivatsa.bhat@linux.vnet.ibm.com,
        Arvind.Chauhan@arm.com, linux-arm-kernel@lists.infradead.org
Date: Thu, 15 Nov 2012 22:23:52 +0530
Message-ID: <20121115164730.17426.36051.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12111516-2674-0000-0000-000006BE9EFA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This approach aims to retain the current behavior of load balancer with the
change being only in the metric consumed during load balancing,
without unnecessary introduction of new variables.This RFC has been posted to
evaluate its design;to see if this is the right way to go about introducing
per-entity-load-tracking metric for the consumers of the same; in this
specific case,the load balancer.Once the design has been approved off,I can
go around to testing it.

The patch has been based out of tip-master:HEAD at commit 8a1d31c703d
Subject:Merge branch 'x86/urgent'

Grateful to Peter Zijlstra and Ingo Molnar for their valuable feedback on v1
of the RFC which was the foundation for this version.

PATCH[1/2] Aims at enabling usage of Per-Entity-Load-Tracking for load balacing
PATCH[2/2] The crux of the patchset lies here.
---

Preeti U Murthy (2):
      sched: Revert temporary FAIR_GROUP_SCHED dependency for load-tracking
      sched: Use Per-Entity-Load-Tracking metric for load balancing


 include/linux/sched.h |    9 +-----
 kernel/sched/core.c   |   19 +++++-------
 kernel/sched/fair.c   |   76 +++++++++++++++++++++----------------------------
 kernel/sched/sched.h  |    9 +-----
 4 files changed, 43 insertions(+), 70 deletions(-)

-- 
Preeti U Murthy

