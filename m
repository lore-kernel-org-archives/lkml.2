Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab2EVOwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:52:51 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42168 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab2EVOwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:52:50 -0400
Date: Tue, 22 May 2012 17:52:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] sched/numa: checking for NULL instead of IS_ERR()
Message-ID: <20120522145233.GA17419@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If mpol_new() is called with MPOL_BIND then it can't return a NULL
pointer.  We should be checking IS_ERR() here.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/kernel/sched/numa.c b/kernel/sched/numa.c
index 1149993..36d27ac 100644
--- a/kernel/sched/numa.c
+++ b/kernel/sched/numa.c
@@ -1481,9 +1481,9 @@ SYSCALL_DEFINE4(numa_mbind, unsigned long, addr, unsigned long, len,
 
 	mask = nodemask_of_node(ng->numa_entity.node);
 	mpol = mpol_new(MPOL_BIND, 0, &mask);
-	if (!mpol) {
+	if (IS_ERR(mpol)) {
 		ng_put(ng);
-		return -ENOMEM;
+		return PTR_ERR(mpol);
 	}
 	mpol->flags |= MPOL_MF_LAZY;
 	mpol->numa_group = ng;
