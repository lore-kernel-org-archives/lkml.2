Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325Ab2EQIqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:46:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33315 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2EQIqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:46:38 -0400
Date: Thu, 17 May 2012 10:46:32 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fix
Message-ID: <20120517084632.GA25475@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: 30b4e9eb783d94e9f5d503b15eb31720679ae1c7 sched: Fix KVM and ia64 boot crash due to sched_groups circular linked list assumption

 Thanks,

	Ingo

------------------>
Igor Mammedov (1):
      sched: Fix KVM and ia64 boot crash due to sched_groups circular linked list assumption


 kernel/sched/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0533a68..e5212ae 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6382,6 +6382,8 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 			if (!sg)
 				return -ENOMEM;
 
+			sg->next = sg;
+
 			*per_cpu_ptr(sdd->sg, j) = sg;
 
 			sgp = kzalloc_node(sizeof(struct sched_group_power),
