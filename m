Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab3ADMxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 07:53:22 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:36417 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab3ADMxT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 07:53:19 -0500
MIME-Version: 1.0
In-Reply-To: <87bod8rmxm.fsf@sejong.aot.lge.com>
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
	<1356799386-4212-22-git-send-email-fweisbec@gmail.com>
	<87bod8rmxm.fsf@sejong.aot.lge.com>
Date: Fri, 4 Jan 2013 13:53:19 +0100
Message-ID: <CAFTL4hz9uErzuHkWDPj-SzA83uh52gjUCmU+cNgq9gaRTrUHFg@mail.gmail.com>
Subject: Re: [PATCH 21/27] nohz: Only stop the tick on RCU nocb CPUs
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
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
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/2 Namhyung Kim <namhyung@kernel.org>:
> You may want to add the following also to shut up the gcc:
>
>       CC      kernel/rcutree.o
>     In file included from /home/namhyung/project/linux/kernel/rcutree.c:58:0:
>     /home/namhyung/project/linux/kernel/rcutree.h:539:13: warning: ‘is_nocb_cpu’ declared ‘static’ but never defined [-Wunused-function]
>
>
> Thanks,
> Namhyung
>
>
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 4b69291b093d..fbbad931c36a 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -536,7 +536,6 @@ static void print_cpu_stall_info(struct rcu_state *rsp, int cpu);
>  static void print_cpu_stall_info_end(void);
>  static void zero_cpu_stall_ticks(struct rcu_data *rdp);
>  static void increment_cpu_stall_ticks(void);
> -static bool is_nocb_cpu(int cpu);
>  static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
>                             bool lazy);
>  static bool rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,

I'm folding that fix for the next version.

Thanks Namhyung!
