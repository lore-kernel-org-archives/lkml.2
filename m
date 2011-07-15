Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab1GOOaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 10:30:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:41991 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab1GOO37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 10:29:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,535,1304319600"; 
   d="scan'208";a="26267125"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4/6] perf: Remove perf_event_attr::type check
Date: Fri, 15 Jul 2011 14:35:01 +0000
Message-Id: <1310740503-15608-5-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PMU type id can be allocated dynamically, so perf_event_attr::type check
when copying attribute from userspace to kernel is not valid.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 kernel/events/core.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9f4f463..7bd8d5d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5928,13 +5928,6 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	if (ret)
 		return -EFAULT;
 
-	/*
-	 * If the type exists, the corresponding creation will verify
-	 * the attr->config.
-	 */
-	if (attr->type >= PERF_TYPE_MAX)
-		return -EINVAL;
-
 	if (attr->__reserved_1)
 		return -EINVAL;
 
-- 
1.7.5.1

