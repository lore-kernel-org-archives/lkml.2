Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab3ABIri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 03:47:38 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61555 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3ABIrf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 03:47:35 -0500
X-AuditID: 9c930197-b7c5bae000000e31-c4-50e3f42508e2
From: Namhyung Kim <namhyung@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 21/27] nohz: Only stop the tick on RCU nocb CPUs
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
	<1356799386-4212-22-git-send-email-fweisbec@gmail.com>
Date: Wed, 02 Jan 2013 17:47:33 +0900
In-Reply-To: <1356799386-4212-22-git-send-email-fweisbec@gmail.com> (Frederic
	Weisbecker's message of "Sat, 29 Dec 2012 17:43:00 +0100")
Message-ID: <87bod8rmxm.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Sat, 29 Dec 2012 17:43:00 +0100, Frederic Weisbecker wrote:
> On a full dynticks CPU, we want the RCU callbacks to be
> offlined to another CPU, otherwise we need to keep
> the tick to wait for the grace period completion.
>
> Ensure the full dynticks CPU is also an rcu_nocb one.
[snip]
> -static bool is_nocb_cpu(int cpu)
> -{
> -	return false;
> -}
> -

You may want to add the following also to shut up the gcc:

      CC      kernel/rcutree.o
    In file included from /home/namhyung/project/linux/kernel/rcutree.c:58:0:
    /home/namhyung/project/linux/kernel/rcutree.h:539:13: warning: ‘is_nocb_cpu’ declared ‘static’ but never defined [-Wunused-function]


Thanks,
Namhyung


diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 4b69291b093d..fbbad931c36a 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -536,7 +536,6 @@ static void print_cpu_stall_info(struct rcu_state *rsp, int cpu);
 static void print_cpu_stall_info_end(void);
 static void zero_cpu_stall_ticks(struct rcu_data *rdp);
 static void increment_cpu_stall_ticks(void);
-static bool is_nocb_cpu(int cpu);
 static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
                            bool lazy);
 static bool rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
