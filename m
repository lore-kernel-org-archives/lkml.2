Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab2GFGVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:21:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48989 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab2GFGVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:21:50 -0400
Date: Thu, 5 Jul 2012 23:21:33 -0700
From: tip-bot for Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Message-ID: <tip-95f302e4d0833dd604210fbb415629ac3662cd39@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        prashanth@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, prashanth@linux.vnet.ibm.com
In-Reply-To: <4FE06DDE.7000403@linux.vnet.ibm.com>
References: <4FE06DDE.7000403@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Reorder 'struct lb_env'
  members to reduce its size
Git-Commit-ID: 95f302e4d0833dd604210fbb415629ac3662cd39
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 05 Jul 2012 23:21:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  95f302e4d0833dd604210fbb415629ac3662cd39
Gitweb:     http://git.kernel.org/tip/95f302e4d0833dd604210fbb415629ac3662cd39
Author:     Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
AuthorDate: Tue, 19 Jun 2012 17:47:34 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jul 2012 21:09:08 +0200

sched: Reorder 'struct lb_env' members to reduce its size

Members of 'struct lb_env' are not in appropriate order to reuse compiler
added padding on 64bit architectures. In this patch we reorder those struct
members and help reduce the size of the structure from 96 bytes to 80
bytes on 64 bit architectures.

Suggested-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4FE06DDE.7000403@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3704ad3..39b5771 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3088,18 +3088,18 @@ static unsigned long __read_mostly max_load_balance_interval = HZ/10;
 struct lb_env {
 	struct sched_domain	*sd;
 
-	int			src_cpu;
 	struct rq		*src_rq;
+	int			src_cpu;
 
 	int			dst_cpu;
 	struct rq		*dst_rq;
 
 	enum cpu_idle_type	idle;
 	long			imbalance;
-	unsigned int		flags;
 
 	struct list_head	*tasks;
 
+	unsigned int		flags;
 	unsigned int		loop;
 	unsigned int		loop_break;
 	unsigned int		loop_max;
