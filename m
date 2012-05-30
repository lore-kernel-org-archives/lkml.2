Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab2E3NhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 09:37:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38408 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab2E3NhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 09:37:24 -0400
Date: Wed, 30 May 2012 06:37:07 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-epfc1io9whb7o22bcujf31vn@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tony.luck@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, anton@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, tony.luck@intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Don'
 t try allocating memory from offline nodes
Git-Commit-ID: 2ea45800d8e1c3c51c45a233d6bd6289a297a386
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 06:37:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ea45800d8e1c3c51c45a233d6bd6289a297a386
Gitweb:     http://git.kernel.org/tip/2ea45800d8e1c3c51c45a233d6bd6289a297a386
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 25 May 2012 09:26:43 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 30 May 2012 14:02:23 +0200

sched: Don't try allocating memory from offline nodes

Allocators don't appreciate it when you try and allocate memory from
offline nodes.

Reported-and-tested-by: Tony Luck <tony.luck@intel.com>
Reported-and-tested-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-epfc1io9whb7o22bcujf31vn@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 75844a8..5573361 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6436,7 +6436,7 @@ static void sched_init_numa(void)
 			return;
 
 		for (j = 0; j < nr_node_ids; j++) {
-			struct cpumask *mask = kzalloc_node(cpumask_size(), GFP_KERNEL, j);
+			struct cpumask *mask = kzalloc(cpumask_size(), GFP_KERNEL);
 			if (!mask)
 				return;
 
