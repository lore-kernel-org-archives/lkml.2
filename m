Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab2FSMSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 08:18:30 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42596 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab2FSMS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 08:18:28 -0400
Message-ID: <4FE06DDE.7000403@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2012 17:47:34 +0530
From: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, efault@gmx.de,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] sched: reorder lb_env struct members to reduce its size
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061912-1780-0000-0000-000006963A7B
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000282; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00149396; UDB=6.00033989; UTC=2012-06-19
 12:18:27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Members of lb_env struct are not in appropriate order to reuse compiler
added padding on 64bit architectures. In this patch we reorder those struct
members and help reduce the size of the structure from 96 bytes to 80
bytes on 64 bit architectures.

Suggested-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
---

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 939fd63..96e36fb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3102,18 +3102,18 @@ static unsigned long __read_mostly max_load_balance_interval = HZ/10;
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

