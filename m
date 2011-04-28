Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669Ab1D1P1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:27:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41263 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab1D1P1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:27:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] cpumask: add cpumask_var_t documentation
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20110429002847.3D77.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Fri, 29 Apr 2011 00:27:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpumask_var_t has one nortable difference against cpumask_t.
This patch adds the explanation.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/cpumask.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 1e40dd0..471c98a 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -617,6 +617,20 @@ static inline size_t cpumask_size(void)
  *	  ... use 'tmpmask' like a normal struct cpumask * ...
  *
  *	free_cpumask_var(tmpmask);
+ *
+ *
+ * However, one notable exception is there. cpumask_var_t is allocated
+ * only nr_cpu_ids bits (in the other hand, real cpumask_t always has
+ * NR_CPUS bits). therefore You don't have to dereference cpumask_var_t.
+ *
+ *	cpumask_var_t tmpmask;
+ *	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL))
+ *		return -ENOMEM;
+ *
+ *	var = *tmpmask;
+ *
+ * This code makes NR_CPUS length memcopy and bring memroy corruption.
+ * You have to use cpumask_copy() instead.
  */
 #ifdef CONFIG_CPUMASK_OFFSTACK
 typedef struct cpumask *cpumask_var_t;
-- 
1.7.3.1



