Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab1FMVwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 17:52:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33512 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab1FMVwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 17:52:02 -0400
Date: Mon, 13 Jun 2011 17:51:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Tobias Diedrich <ranma+xen@tdiedrich.de>, xen-users@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: 3.0.0-rc2: Xen: powernow-k8: Kernel panic - not syncing:
 Attempted to kill init!
Message-ID: <20110613215123.GA19117@dumpdata.com>
References: <20110613202622.GC20616@yumi.tdiedrich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110613202622.GC20616@yumi.tdiedrich.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DF68679.00E5:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [    5.523199] rtc_cmos 00:05: setting system clock to 2011-06-13 20:20:00 UTC (1307996400)
> [    5.523400] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3700+ (1 cpu cores) (version 2.20.00)
> [    5.530956] powernow-k8: fid 0x2 (1000 MHz), vid 0x12
> [    5.531072] powernow-k8: fid 0xa (1800 MHz), vid 0xa
> [    5.531187] powernow-k8: fid 0xc (2000 MHz), vid 0x8
> [    5.531301] powernow-k8: fid 0xe (2200 MHz), vid 0x8
> [    5.531460] Marking TSC unstable due to cpufreq changes
> [    5.531680] powernow-k8: fid trans failed, fid 0x2, curr 0x0
> [    5.531802] BUG: unable to handle kernel paging request at ffff880807e07b78
> [    5.531982] IP: [<ffffffff81479163>] cpufreq_stats_update+0x46/0x5b

For this one, you will have to fire out gdb and disassemble the code to
figure out where it failed. Look for 'gdb vmlinux' and 'disassembly' on this
mailing list - that should provide some hints.


> [    5.532207] PGD 1a18067 PUD 0 
> [    5.532450] Oops: 0002 [#1] SMP 
> [    5.532623] CPU 0 
> [    5.532724] Modules linked in:
> [    5.532972] 
> [    5.533151] Pid: 1, comm: swapper Not tainted 3.0.0-rc2 #45 MICRO-STAR INTERNATIONAL CO., LTD MS-7094/MS-7094
> [    5.533506] RIP: e030:[<ffffffff81479163>]  [<ffffffff81479163>] cpufreq_stats_update+0x46/0x5b
> [    5.533733] RSP: e02b:ffff880008c61a30  EFLAGS: 00010246
> [    5.533849] RAX: ffff880007e07b00 RBX: 00000000ffff8cf9 RCX: 00000000ffffffff
> [    5.534034] RDX: ffff880007e07b80 RSI: 0000000000000000 RDI: ffffffff81be934c
> [    5.534151] RBP: ffff880008c61a40 R08: 0000000000000003 R09: ffff8800075267c0
> [    5.534268] R10: 0000000000000020 R11: 0000000000000020 R12: 0000000000000000
> [    5.534384] R13: 0000000000000000 R14: 00000000ffffffff R15: 00000000000c3500
> [    5.534572] FS:  0000000000000000(0000) GS:ffff88000ff22000(0000) knlGS:0000000000000000
> [    5.534767] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    5.534881] CR2: ffff880807e07b78 CR3: 0000000001a17000 CR4: 0000000000000660
> [    5.534998] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    5.535183] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    5.535301] Process swapper (pid: 1, threadinfo ffff880008c60000, task ffff880008c5e040)
> [    5.535493] Stack:
> [    5.535602]  ffff880007e07b00 00000000ffffffff ffff880008c61a70 ffffffff81479248
> [    5.536051]  ffff880008c61b90 0000000000000001 00000000fffffffe 0000000000000000
> [    5.536434]  ffff880008c61ab0 ffffffff81095d68 0000000000000001 0000000000000000
> [    5.536814] Call Trace:
> [    5.536929]  [<ffffffff81479248>] cpufreq_stat_notifier_trans+0x48/0x7c
> [    5.537116]  [<ffffffff81095d68>] notifier_call_chain+0x32/0x5e
> [    5.537235]  [<ffffffff81095e6b>] __srcu_notifier_call_chain+0x47/0x63
> [    5.537353]  [<ffffffff81095e96>] srcu_notifier_call_chain+0xf/0x11
> [    5.537472]  [<ffffffff81477e7a>] cpufreq_notify_transition+0x111/0x134
> [    5.537657]  [<ffffffff8147b0d4>] powernowk8_target+0x53b/0x617
> [    5.537776]  [<ffffffff8147723a>] __cpufreq_driver_target+0x2e/0x30
> [    5.537894]  [<ffffffff8147a127>] cpufreq_governor_dbs+0x339/0x356
> [    5.538012]  [<ffffffff81477394>] __cpufreq_governor+0xa8/0xe9
> [    5.538197]  [<ffffffff81477525>] __cpufreq_set_policy+0x132/0x13e
> [    5.538316]  [<ffffffff8147848d>] cpufreq_add_dev_interface+0x272/0x28c
> [    5.538435]  [<ffffffff81478c70>] ? cpufreq_update_policy+0xdc/0xdc
> [    5.538553]  [<ffffffff814788d0>] cpufreq_add_dev+0x429/0x439
> [    5.538738]  [<ffffffff8136bab4>] sysdev_driver_register+0xcf/0x13e
> [    5.538859]  [<ffffffff81477b50>] cpufreq_register_driver+0x9a/0x139
> [    5.538979]  [<ffffffff815f3dab>] powernowk8_init+0x177/0x1bf
> [    5.539096]  [<ffffffff815f3c34>] ? powernowk8_cpu_init+0x8d3/0x8d3
> [    5.539282]  [<ffffffff81002155>] do_one_initcall+0x7a/0x135
> [    5.539402]  [<ffffffff81ab7c52>] kernel_init+0xd8/0x159
> [    5.539519]  [<ffffffff815f7f24>] kernel_thread_helper+0x4/0x10
> [    5.539636]  [<ffffffff815f73f6>] ? int_ret_from_sys_call+0x7/0x1b
> [    5.539821]  [<ffffffff815f6b61>] ? retint_restore_args+0x5/0x6
> [    5.539939]  [<ffffffff815f7f20>] ? gs_change+0x13/0x13
