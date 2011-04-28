Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481Ab1D1ORT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 10:17:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42046 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760461Ab1D1ORS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 10:17:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] cpumask: alloc_cpumask_var() use NUMA_NO_NODE
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20110428231856.3D54.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 28 Apr 2011 23:17:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NUMA_NO_NODE and numa_node_id() are different meanings. NUMA_NO_NODE 
is obviously recomended fallback.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 lib/cpumask.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/cpumask.c b/lib/cpumask.c
index 4f6425d..af3e581 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -131,7 +131,7 @@ EXPORT_SYMBOL(zalloc_cpumask_var_node);
  */
 bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
 {
-	return alloc_cpumask_var_node(mask, flags, numa_node_id());
+	return alloc_cpumask_var_node(mask, flags, NUMA_NO_NODE);
 }
 EXPORT_SYMBOL(alloc_cpumask_var);
 
-- 
1.7.3.1



