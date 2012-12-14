Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab2LNX2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:28:41 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34193 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932567Ab2LNX2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:28:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, cpufreq <cpufreq@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpufreq_stats: fix race between stats allocation and first usage
Date: Sat, 15 Dec 2012 00:33:46 +0100
Message-ID: <4367394.4dMqb5NnJH@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121214105921.5139.502.stgit@zurg>
References: <20121214105921.5139.502.stgit@zurg>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 14, 2012 02:59:21 PM Konstantin Khlebnikov wrote:
> This patch forces complete struct cpufreq_stats allocation for all cpus before
> registering CPUFREQ_TRANSITION_NOTIFIER notifier, otherwise in some conditions
> cpufreq_stat_notifier_trans() can be called in the middle of stats allocation,
> in this case cpufreq_stats_table already exists, but stat->freq_table is NULL.

I'll queue it up for submission as v3.8 material.

Does it need to be marked as -stable material too?

Rafael


> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: cpufreq <cpufreq@vger.kernel.org>
> Cc: linux-pm <linux-pm@vger.kernel.org>
> 
> ---
> 
> <1>[  363.116198] BUG: unable to handle kernel NULL pointer dereference at (null)
> <1>[  363.116668] IP: [<ffffffffa11a70e4>] cpufreq_stat_notifier_trans+0x64/0xf0 [cpufreq_stats]
> <4>[  363.116977] PGD 23177e067 PUD 2349c1067 PMD 0
> <4>[  363.117151] Oops: 0000 [#1] SMP
> <4>[  363.117151] last sysfs file: /sys/module/freq_table/initstate
> <4>[  363.117151] CPU 5
> <4>[  363.117151] Modules linked in: cpufreq_stats(+)(U) [a lot] [last unloaded: umc]
> <4>[  363.117151]
> <4>[  363.117151] Pid: 1690, comm: kondemand/5 veid: 0 Tainted: P        WC ---------------  T 2.6.32-279.5.1.el6-042stab061.7-vz #112 042stab061_7 System manufacturer System Product Name/Crosshair IV Formula
> <4>[  363.117151] RIP: 0010:[<ffffffffa11a70e4>]  [<ffffffffa11a70e4>] cpufreq_stat_notifier_trans+0x64/0xf0 [cpufreq_stats]
> <4>[  363.117151] RSP: 0018:ffff880234281920  EFLAGS: 00010246
> <4>[  363.117151] RAX: 00000000001e12e8 RBX: 0000000000000000 RCX: 00000000002ab980
> <4>[  363.117151] RDX: 0000000000000004 RSI: 0000000000000000 RDI: 0000000000000005
> <4>[  363.117151] RBP: ffff880234281940 R08: 0000000000000000 R09: 0000000000000000
> <4>[  363.117151] R10: 0000000000000000 R11: 2222222222222222 R12: ffff880218ce7400
> <4>[  363.117151] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> <4>[  363.117151] FS:  00007f499ffe0700(0000) GS:ffff880031000000(0000) knlGS:0000000000000000
> <4>[  363.117151] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> <4>[  363.117151] CR2: 0000000000000000 CR3: 0000000230af7000 CR4: 00000000000006e0
> <4>[  363.117151] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> <4>[  363.117151] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> <4>[  363.117151] Process kondemand/5 (pid: 1690, veid: 0, threadinfo ffff880234280000, task ffff8802330c48c0)
> <4>[  363.117151] Stack:
> <4>[  363.117151]  ffffffff810cf4f3 0000000000000001 00000000ffffffff ffffffffa11a7ac0
> <4>[  363.117151] <d> ffff880234281990 ffffffff815454a8 ffff880234281c80 0000000000000000
> <4>[  363.117151] <d> ffff880234281a10 ffffffff833be978 ffffffff833be8e0 0000000000000001
> <4>[  363.117151] Call Trace:
> <4>[  363.117151]  [<ffffffff810cf4f3>] ? is_module_text_address+0x23/0x30
> <4>[  363.117151]  [<ffffffff815454a8>] notifier_call_chain+0x58/0xb0
> <4>[  363.117151]  [<ffffffff810a5a8d>] __srcu_notifier_call_chain+0x5d/0x90
> <4>[  363.117151]  [<ffffffff810a5ad6>] srcu_notifier_call_chain+0x16/0x20
> <4>[  363.117151]  [<ffffffff81442a0a>] cpufreq_notify_transition+0x12a/0x190
> <4>[  363.117151]  [<ffffffffa026df08>] powernowk8_target+0x628/0xb30 [powernow_k8]
> <4>[  363.117151]  [<ffffffff8144289b>] __cpufreq_driver_target+0x8b/0x90
> <4>[  363.117151]  [<ffffffffa0279388>] do_dbs_timer+0x3b8/0x3bc [cpufreq_ondemand]
> <4>[  363.117151]  [<ffffffffa0278fd0>] ? do_dbs_timer+0x0/0x3bc [cpufreq_ondemand]
> <4>[  363.117151]  [<ffffffff81097df4>] worker_thread+0x264/0x440
> <4>[  363.117151]  [<ffffffff81097da3>] ? worker_thread+0x213/0x440
> <4>[  363.117151]  [<ffffffff81097b90>] ? worker_thread+0x0/0x440
> <4>[  363.117151]  [<ffffffff8109f050>] ? autoremove_wake_function+0x0/0x40
> <4>[  363.117151]  [<ffffffff81097b90>] ? worker_thread+0x0/0x440
> <4>[  363.117151]  [<ffffffff8109e986>] kthread+0x96/0xa0
> <4>[  363.117151]  [<ffffffff8100c34a>] child_rip+0xa/0x20
> <4>[  363.117151]  [<ffffffff8100bc90>] ? restore_args+0x0/0x30
> <4>[  363.117151]  [<ffffffff8109e8f0>] ? kthread+0x0/0xa0
> <4>[  363.117151]  [<ffffffff8100c340>] ? child_rip+0x0/0x20
> <4>[  363.117151] Code: 89 f9 48 8b 0c cd 20 53 9c 81 4c 8b 24 08 4d 85 e4 74 d3 8b 4a 08 41 8b 54 24 10 45 8b 6c 24 18 85 d2 74 22 49 8b 74 24 28 31 db <3b> 0e 75 10 eb 1a 66 0f 1f 44 00 00 48 63 c3 3b 0c 86 74 0c 83
> <1>[  363.117151] RIP  [<ffffffffa11a70e4>] cpufreq_stat_notifier_trans+0x64/0xf0 [cpufreq_stats]
> <4>[  363.117151]  RSP <ffff880234281920>
> <4>[  363.117151] CR2: 0000000000000000
> ---
>  drivers/cpufreq/cpufreq_stats.c |   11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
> index e40e508..9d7732b 100644
> --- a/drivers/cpufreq/cpufreq_stats.c
> +++ b/drivers/cpufreq/cpufreq_stats.c
> @@ -364,18 +364,21 @@ static int __init cpufreq_stats_init(void)
>  	if (ret)
>  		return ret;
>  
> +	register_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
> +	for_each_online_cpu(cpu)
> +		cpufreq_update_policy(cpu);
> +
>  	ret = cpufreq_register_notifier(&notifier_trans_block,
>  				CPUFREQ_TRANSITION_NOTIFIER);
>  	if (ret) {
>  		cpufreq_unregister_notifier(&notifier_policy_block,
>  				CPUFREQ_POLICY_NOTIFIER);
> +		unregister_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
> +		for_each_online_cpu(cpu)
> +			cpufreq_stats_free_table(cpu);
>  		return ret;
>  	}
>  
> -	register_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
> -	for_each_online_cpu(cpu) {
> -		cpufreq_update_policy(cpu);
> -	}
>  	return 0;
>  }
>  static void __exit cpufreq_stats_exit(void)
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
