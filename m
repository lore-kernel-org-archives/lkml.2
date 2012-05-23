Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019Ab2EWHxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 03:53:16 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:53674 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab2EWHxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 03:53:14 -0400
Date: Wed, 23 May 2012 12:11:09 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, peterz@infradead.org
Subject: [PATCH] Trivial sched: Pass domain_attr to build_sched_domains()
Message-ID: <20120523064109.GB5005@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12052220-5490-0000-0000-000001711C19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: Pass domain_attr to build_sched_domains()

build_sched_domains() is called from init_sched_domains()
by explicitly passing NULL as second argument, which is
of type sched_domain_attr. This patch calls build_sched_domains()
with dattr_cur instead of NULL, as dattr_cur is also NULL.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 22a19ae..32ccf13 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6735,7 +6735,7 @@ static int init_sched_domains(const struct cpumask *cpu_map)
 		doms_cur = &fallback_doms;
 	cpumask_andnot(doms_cur[0], cpu_map, cpu_isolated_map);
 	dattr_cur = NULL;
-	err = build_sched_domains(doms_cur[0], NULL);
+	err = build_sched_domains(doms_cur[0], dattr_cur);
 	register_sched_domain_sysctl();

 	return err;

