Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab1F3IEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:04:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:38500 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758645Ab1F3ID4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:03:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,449,1304319600"; 
   d="scan'208";a="20764707"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] perf: Remove perf_event_attr::type check
Date: Thu, 30 Jun 2011 08:09:55 +0000
Message-Id: <1309421396-17438-4-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
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
index 5e70f62..eaaddbf 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5892,13 +5892,6 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
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

