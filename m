Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab1FGW1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 18:27:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:16433 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757005Ab1FGW1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 18:27:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,335,1304319600"; 
   d="scan'208";a="15212962"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, paulmck@linux.vnet.ibm.com
Subject: [PATCH 2/5] Fix mismatched variable in rcutree_trace.c
Date: Tue,  7 Jun 2011 15:26:30 -0700
Message-Id: <1307485593-27196-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307485593-27196-1-git-send-email-andi@firstfloor.org>
References: <1307485593-27196-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

rcutree.c defines rcu_cpu_kthread_cpu as int, not unsigned int,
so the extern has to follow that.

Cc: paulmck@linux.vnet.ibm.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/rcutree_trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 9678cc3..91c56e5 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -47,7 +47,7 @@
 #include "rcutree.h"
 
 DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
-DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_cpu);
+DECLARE_PER_CPU(int, rcu_cpu_kthread_cpu);
 DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
 DECLARE_PER_CPU(char, rcu_cpu_has_work);
 
-- 
1.7.4.4

