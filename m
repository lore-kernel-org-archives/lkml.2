Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab2EXRWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:22:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab2EXRWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:22:30 -0400
Date: Thu, 24 May 2012 13:22:23 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: tracing ring_buffer_resize oops.
Message-ID: <20120524172223.GA10689@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@redhat.com>
References: <20120524160146.GA6226@redhat.com>
 <1337876398.13348.178.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337876398.13348.178.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 12:19:58PM -0400, Steven Rostedt wrote:
 > On Thu, 2012-05-24 at 12:01 -0400, Dave Jones wrote:
 > > Hit this while trying to configure the irq-tracer.
 > > I ran cat trace before doing a "echo 0 > tracing_on" by mistake.
 > > Shot myself in the foot, but it still shouldn't oops.
 > > 
 > 
 > Hi Dave,
 > 
 > Thanks for reporting. Could you try this patch to see if it fixes it for
 > you.
 > 
 > http://groups.google.com/group/linux.kernel/msg/4294e8d564d66997?dmode=source
 > 
 > Below is the patch again, as the one in the link has GPG tags that might
 > screw with patch.

hmm, this time I didn't even get past 'echo irqsoff > current_tracer'

	Dave

[ 1013.243754] BUG: unable to handle kernel NULL pointer dereference at 0000000000000002
[ 1013.272665] IP: [<ffff880145cc0000>] 0xffff880145cbffff
[ 1013.285186] PGD 1401b2067 PUD 14324c067 PMD 0 
[ 1013.298832] Oops: 0010 [#1] PREEMPT SMP 
[ 1013.310600] CPU 2 
[ 1013.317904] Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables crc32c_intel ghash_clmulni_intel microcode usb_debug serio_raw pcspkr iTCO_wdt i2c_i801 iTCO_vendor_support e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
[ 1013.401848] 
[ 1013.407399] Pid: 112, comm: kworker/2:1 Not tainted 3.4.0+ #30 
[ 1013.437943] RIP: 8eb8:[<ffff88014630a000>]  [<ffff88014630a000>] 0xffff880146309fff
[ 1013.459871] RSP: ffffffff8165e919:ffff88014780f408  EFLAGS: 00010046
[ 1013.477909] RAX: 0000000000000001 RBX: ffffffff81104020 RCX: 0000000000000000
[ 1013.499458] RDX: ffff880148008ea8 RSI: ffffffff8131ef40 RDI: ffffffff82203b20
[ 1013.521612] RBP: ffffffff81005751 R08: 0000000000000000 R09: 0000000000000000
[ 1013.543121] R10: ffffffff82cdc318 R11: 0000000000000000 R12: ffff880145cc0000
[ 1013.564614] R13: ffff880148008eb8 R14: 0000000000000002 R15: ffff88014780cb40
[ 1013.586108] FS:  0000000000000000(0000) GS:ffff880148000000(0000) knlGS:0000000000000000
[ 1013.609458] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1013.627420] CR2: 0000000000000002 CR3: 0000000141f10000 CR4: 00000000001407e0
[ 1013.649051] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1013.670724] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1013.692376] Process kworker/2:1 (pid: 112, threadinfo ffff88013fe0e000, task ffff88014020a6a0)
[ 1013.717028] Stack:
[ 1013.724131]  ffff88014780f570 ffff880145cc0000 0000400000004000 0000000000000000
[ 1013.745918]  cccccccccccccccc ffff88014780cca8 ffffffff811072bb ffffffff81651627
[ 1013.767870]  ffffffff8118f8a7 ffffffff811072bb ffffffff81f2b6c5 ffffffff81f11bdb
[ 1013.790021] Call Trace:
[ 1013.800701] Code: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a <e7> d7 64 81 ff ff ff ff 01 00 00 00 00 00 00 00 65 d9 64 81 ff 
[ 1013.861443] RIP  [<ffff88014630a000>] 0xffff880146309fff
[ 1013.884466]  RSP <ffff88014780f408>
[ 1013.901507] CR2: 0000000000000002
[ 1013.918628] ---[ end trace d0e6e5741aaf56ac ]---
[ 1013.940297] BUG: sleeping function called from invalid context at kernel/rwsem.c:20
[ 1013.972340] in_atomic(): 0, irqs_disabled(): 1, pid: 112, name: kworker/2:1
[ 1014.001470] INFO: lockdep is turned off.
[ 1014.021285] irq event stamp: 146784
[ 1014.039375] hardirqs last  enabled at (146783): [<ffffffff8165b4f4>] paranoid_restore+0x10/0x66
[ 1014.074744] hardirqs last disabled at (146784): [<ffffffff8165b380>] int3+0x10/0x40
[ 1014.106164] softirqs last  enabled at (146418): [<ffffffff81052054>] __do_softirq+0x144/0x3d0
[ 1014.141604] softirqs last disabled at (146407): [<ffffffff81663e4c>] call_softirq+0x1c/0x30
[ 1014.174829] Pid: 112, comm: kworker/2:1 Tainted: G      D      3.4.0+ #30
[ 1014.204753] Call Trace:
[ 1014.220719]  <#DB>  [<ffffffff810b3eb0>] ? print_irqtrace_events+0xd0/0xe0
[ 1014.251033]  [<ffffffff8107f5c0>] __might_sleep+0x140/0x1f0
[ 1014.276482]  [<ffffffff81657fc6>] down_read+0x26/0x93
[ 1014.301499]  [<ffffffff810624e4>] exit_signals+0x24/0x130
[ 1014.326264]  [<ffffffff8104e95c>] do_exit+0xbc/0xb70
[ 1014.348709]  [<ffffffff8104b8b3>] ? kmsg_dump+0x83/0x2b0
[ 1014.373726]  [<ffffffff8164d5e3>] ? printk+0x61/0x63
[ 1014.396878]  [<ffffffff8165c007>] oops_end+0x97/0xe0
[ 1014.420306]  [<ffffffff8164cece>] no_context+0x258/0x283
[ 1014.446640]  [<ffffffff8164d0bd>] __bad_area_nosemaphore+0x1c4/0x1e3
[ 1014.474615]  [<ffffffff8164d0ef>] bad_area_nosemaphore+0x13/0x15
[ 1014.505249]  [<ffffffff8165e540>] do_page_fault+0x3c0/0x4b0
[ 1014.531368]  [<ffffffff8106f708>] ? __kernel_text_address+0x58/0x80
[ 1014.560247]  [<ffffffff810057cf>] ? print_context_stack+0x8f/0xf0
[ 1014.589070]  [<ffffffff810860f1>] ? get_parent_ip+0x11/0x50
[ 1014.614948]  [<ffffffff8165b613>] ? error_sti+0x5/0x6
[ 1014.641105]  [<ffffffff810b0b38>] ? trace_hardirqs_off_caller+0x28/0xc0
[ 1014.671882]  [<ffffffff81005751>] ? print_context_stack+0x11/0xf0
[ 1014.700148]  [<ffffffff8131ac5d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 1014.730928]  [<ffffffff81005751>] ? print_context_stack+0x11/0xf0
[ 1014.759028]  [<ffffffff8165b42f>] page_fault+0x1f/0x30
[ 1014.784924]  [<ffffffff81005751>] ? print_context_stack+0x11/0xf0
[ 1014.812910]  [<ffffffff81104020>] ? __add_hash_entry+0x90/0x90
[ 1014.840108]  [<ffffffff8131ef40>] ? bsearch+0x60/0x90
[ 1014.864867]  [<ffffffff81104020>] ? __add_hash_entry+0x90/0x90
[ 1014.891647]  [<ffffffff8165e919>] ? sub_preempt_count+0x9/0xd0
[ 1014.918212]  [<ffffffff8165b466>] ? paranoid_exit+0x6/0x1b
[ 1014.942506]  [<ffffffff810b0b38>] ? trace_hardirqs_off_caller+0x28/0xc0
[ 1014.971053]  [<ffffffff8131ac5d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 1014.999788]  [<ffffffff81104020>] ? __add_hash_entry+0x90/0x90
[ 1015.026354]  [<ffffffff8165e919>] ? sub_preempt_count+0x9/0xd0
[ 1015.052818]  [<ffffffff8165b466>] ? paranoid_exit+0x6/0x1b
[ 1015.077099]  [<ffffffff81005751>] ? print_context_stack+0x11/0xf0
[ 1015.103546]  [<ffffffff8165e91e>] ? sub_preempt_count+0xe/0xd0
[ 1015.131390]  <<EOE>> 
[ 1015.145014] BUG: unable to handle kernel paging request at fffffffffffffff8
[ 1015.169954] IP: [<ffffffff81072ee1>] kthread_data+0x11/0x20
[ 1015.190713] PGD 1c0d067 PUD 1c0e067 PMD 0 
[ 1015.207586] Oops: 0000 [#2] PREEMPT SMP 
[ 1015.224452] CPU 2 
[ 1015.236313] Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables crc32c_intel ghash_clmulni_intel microcode usb_debug serio_raw pcspkr iTCO_wdt i2c_i801 iTCO_vendor_support e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
[ 1015.339235] 
[ 1015.349349] Pid: 112, comm: kworker/2:1 Tainted: G      D      3.4.0+ #30 
[ 1015.389489] RIP: 0010:[<ffffffff81072ee1>]  [<ffffffff81072ee1>] kthread_data+0x11/0x20
[ 1015.419063] RSP: 0018:ffff880148008aa0  EFLAGS: 00010092
[ 1015.440762] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000002
[ 1015.468267] RDX: ffffffff820a0940 RSI: 0000000000000002 RDI: ffff88014020a6a0
[ 1015.495782] RBP: ffff880148008ab8 R08: ffff88014020a710 R09: 0000000000000400
[ 1015.523231] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8801481d3080
[ 1015.550722] R13: 0000000000000002 R14: ffff8801480086c0 R15: ffff88014020a690
[ 1015.578205] FS:  0000000000000000(0000) GS:ffff880148000000(0000) knlGS:0000000000000000
[ 1015.607725] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1015.631370] CR2: fffffffffffffff8 CR3: 0000000141f10000 CR4: 00000000001407e0
[ 1015.658912] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1015.686428] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1015.713990] Process kworker/2:1 (pid: 112, threadinfo ffff88013fe0e000, task ffff88014020a6a0)
[ 1015.744998] Stack:
[ 1015.756808]  ffffffff8106d615 ffff880148008ab8 ffff88014020ac60 ffff880148008b38
[ 1015.784512]  ffffffff81658ca8 ffff880148008ae8 ffffffff8165add2 ffff88014020a6a0
[ 1015.812232]  ffff88013fe0ffd8 ffff88013fe0ffd8 ffff88013fe0ffd8 ffff880148008b18
[ 1015.839896] Call Trace:
[ 1015.853916]  <#DB> 
[ 1015.866497]  [<ffffffff8106d615>] ? wq_worker_sleeping+0x15/0xa0
[ 1015.891848]  [<ffffffff81658ca8>] __schedule+0x758/0x9d0
[ 1015.915078]  [<ffffffff8165add2>] ? _raw_spin_unlock_irqrestore+0x42/0x80
[ 1015.942459]  [<ffffffff81658fa9>] schedule+0x29/0x70
[ 1015.963674]  [<ffffffff8104ef00>] do_exit+0x660/0xb70
[ 1015.987893]  [<ffffffff8104b8b3>] ? kmsg_dump+0x83/0x2b0
[ 1016.011435]  [<ffffffff8164d5e3>] ? printk+0x61/0x63
[ 1016.032614]  [<ffffffff8165c007>] oops_end+0x97/0xe0
[ 1016.053714]  [<ffffffff8164cece>] no_context+0x258/0x283
[ 1016.076944]  [<ffffffff8164d0bd>] __bad_area_nosemaphore+0x1c4/0x1e3
[ 1016.102353]  [<ffffffff8164d0ef>] bad_area_nosemaphore+0x13/0x15
[ 1016.127714]  [<ffffffff8165e540>] do_page_fault+0x3c0/0x4b0
[ 1016.150977]  [<ffffffff8106f708>] ? __kernel_text_address+0x58/0x80
[ 1016.176389]  [<ffffffff810057cf>] ? print_context_stack+0x8f/0xf0
[ 1016.201792]  [<ffffffff810860f1>] ? get_parent_ip+0x11/0x50
[ 1016.225106]  [<ffffffff8165b613>] ? error_sti+0x5/0x6
[ 1016.248342]  [<ffffffff810b0b38>] ? trace_hardirqs_off_caller+0x28/0xc0
[ 1016.275871]  [<ffffffff81005751>] ? print_context_stack+0x11/0xf0
[ 1016.301182]  [<ffffffff8131ac5d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 1016.328674]  [<ffffffff81005751>] ? print_context_stack+0x11/0xf0
[ 1016.354020]  [<ffffffff8165b42f>] page_fault+0x1f/0x30
[ 1016.377291]  [<ffffffff81005751>] ? print_context_stack+0x11/0xf0
[ 1016.402573]  [<ffffffff81104020>] ? __add_hash_entry+0x90/0x90
[ 1016.427845]  [<ffffffff8131ef40>] ? bsearch+0x60/0x90
[ 1016.451031]  [<ffffffff81104020>] ? __add_hash_entry+0x90/0x90
[ 1016.476310]  [<ffffffff8165e919>] ? sub_preempt_count+0x9/0xd0
[ 1016.501673]  [<ffffffff8165b466>] ? paranoid_exit+0x6/0x1b
[ 1016.524849]  [<ffffffff810b0b38>] ? trace_hardirqs_off_caller+0x28/0xc0
[ 1016.552487]  [<ffffffff8131ac5d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 1016.579892]  [<ffffffff81104020>] ? __add_hash_entry+0x90/0x90
[ 1016.605229]  [<ffffffff8165e919>] ? sub_preempt_count+0x9/0xd0
[ 1016.630546]  [<ffffffff8165b466>] ? paranoid_exit+0x6/0x1b
[ 1016.653694]  [<ffffffff81005751>] ? print_context_stack+0x11/0xf0
[ 1016.679048]  [<ffffffff8165e91e>] ? sub_preempt_count+0xe/0xd0
[ 1016.704311]  <<EOE>> 
[ 1016.718280] Code: 81 e8 34 e9 03 00 85 c0 0f 85 6c fe ff ff eb a1 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 cc f7 f7 5e 00 48 8b 87 68 05 00 00 5d <48> 8b 40 f8 c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 cc d7 
[ 1016.780403] RIP  [<ffffffff81072ee1>] kthread_data+0x11/0x20
[ 1016.801375]  RSP <ffff880148008aa0>
[ 1016.816881] CR2: fffffffffffffff8
[ 1016.832146] ---[ end trace d0e6e5741aaf56ad ]---
[ 1016.851464] Fixing recursive fault but reboot is needed!
[ 1034.086221] ------------[ cut here ]------------
[ 1034.095568] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9a/0xc0()
[ 1034.105026] Hardware name: 2012 Client Platform
[ 1034.114418] Watchdog detected hard LOCKUP on cpu 2
[ 1034.118880] Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables crc32c_intel ghash_clmulni_intel microcode usb_debug serio_raw pcspkr iTCO_wdt i2c_i801 iTCO_vendor_support e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
[ 1034.132195] Pid: 112, comm: kworker/2:1 Tainted: G      D      3.4.0+ #30
[ 1034.136525] Call Trace:
[ 1034.140761]  <NMI>  [<ffffffff8104891f>] warn_slowpath_common+0x7f/0xc0
[ 1034.150641]  [<ffffffff81048a16>] warn_slowpath_fmt+0x46/0x50
[ 1034.160462]  [<ffffffff810f2689>] ? watchdog_overflow_callback+0x9/0xc0
[ 1034.170299]  [<ffffffff810f2680>] ? touch_nmi_watchdog+0x90/0x90
[ 1034.180139]  [<ffffffff810f271a>] watchdog_overflow_callback+0x9a/0xc0
[ 1034.189984]  [<ffffffff81133d0d>] __perf_event_overflow+0x9d/0x310
[ 1034.199783]  [<ffffffff81014385>] ? x86_perf_event_set_period+0xd5/0x150
[ 1034.209617]  [<ffffffff81134f84>] perf_event_overflow+0x14/0x20
[ 1034.219422]  [<ffffffff8101960f>] intel_pmu_handle_irq+0x18f/0x310
[ 1034.229257]  [<ffffffff8165cc3d>] perf_event_nmi_handler+0x1d/0x20
[ 1034.239042]  [<ffffffff8165c1fe>] nmi_handle.isra.2+0xae/0x1f0
[ 1034.248822]  [<ffffffff8165c150>] ? __die+0x100/0x100
[ 1034.258550]  [<ffffffff810fe40e>] ? rcu_nmi_enter+0xe/0x80
[ 1034.268345]  [<ffffffff8165c458>] do_nmi+0x118/0x380
[ 1034.278104]  [<ffffffff8165b7b2>] end_repeat_nmi+0x1a/0x1e
[ 1034.287916]  [<ffffffff81319834>] ? delay_tsc+0x74/0xe0
[ 1034.297662]  [<ffffffff81319834>] ? delay_tsc+0x74/0xe0
[ 1034.307432]  [<ffffffff81319834>] ? delay_tsc+0x74/0xe0
[ 1034.317208]  <<EOE>>  <#DB>  [<ffffffff8131971f>] __delay+0xf/0x20
[ 1034.326979]  [<ffffffff81320d2e>] do_raw_spin_lock+0x7e/0x140
[ 1034.336743]  [<ffffffff8165a236>] _raw_spin_lock_irq+0x66/0x80
[ 1034.340966]  [<ffffffff8165863f>] ? __schedule+0xef/0x9d0
[ 1034.345181]  [<ffffffff8165863f>] __schedule+0xef/0x9d0
[ 1034.349398]  [<ffffffff81658fa9>] schedule+0x29/0x70
[ 1034.353579]  [<ffffffff8104f301>] do_exit+0xa61/0xb70
[ 1034.357772]  [<ffffffff8104b8b3>] ? kmsg_dump+0x83/0x2b0
[ 1034.361953]  [<ffffffff8164d5e3>] ? printk+0x61/0x63
[ 1034.366148]  [<ffffffff8165c007>] oops_end+0x97/0xe0
[ 1034.370331]  [<ffffffff8164cece>] no_context+0x258/0x283
[ 1034.374540]  [<ffffffff8164d0bd>] __bad_area_nosemaphore+0x1c4/0x1e3
[ 1034.384325]  [<ffffffff8164d0ef>] bad_area_nosemaphore+0x13/0x15
[ 1034.394059]  [<ffffffff8165e540>] do_page_fault+0x3c0/0x4b0
[ 1034.403809]  [<ffffffff8118ea9f>] ? cmpxchg_double_slab.isra.40+0x13f/0x220
[ 1034.413576]  [<ffffffff8165b613>] ? error_sti+0x5/0x6
[ 1034.423289]  [<ffffffff810b0b38>] ? trace_hardirqs_off_caller+0x28/0xc0
[ 1034.433070]  [<ffffffff8131ac5d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 1034.442850]  [<ffffffff8165b42f>] page_fault+0x1f/0x30
[ 1034.452588]  [<ffffffff81072ee1>] ? kthread_data+0x11/0x20
[ 1034.462311]  [<ffffffff8106d615>] ? wq_worker_sleeping+0x15/0xa0
[ 1034.472070]  [<ffffffff81658ca8>] __schedule+0x758/0x9d0
[ 1034.481826]  [<ffffffff8165add2>] ? _raw_spin_unlock_irqrestore+0x42/0x80
[ 1034.491606]  [<ffffffff81658fa9>] schedule+0x29/0x70
[ 1034.495794]  [<ffffffff8104ef00>] do_exit+0x660/0xb70
[ 1034.499982]  [<ffffffff8104b8b3>] ? kmsg_dump+0x83/0x2b0
[ 1034.504171]  [<ffffffff8164d5e3>] ? printk+0x61/0x63
[ 1034.508381]  [<ffffffff8165c007>] oops_end+0x97/0xe0
[ 1034.518107]  [<ffffffff8164cece>] no_context+0x258/0x283
[ 1034.527863]  [<ffffffff8164d0bd>] __bad_area_nosemaphore+0x1c4/0x1e3
[ 1034.537539]  [<ffffffff8164d0ef>] bad_area_nosemaphore+0x13/0x15
[ 1034.541512]  [<ffffffff8165e540>] do_page_fault+0x3c0/0x4b0
[ 1034.545475]  [<ffffffff8106f708>] ? __kernel_text_address+0x58/0x80
[ 1034.549465]  [<ffffffff810057cf>] ? print_context_stack+0x8f/0xf0
[ 1034.553452]  [<ffffffff810860f1>] ? get_parent_ip+0x11/0x50
[ 1034.562960]  [<ffffffff8165b613>] ? error_sti+0x5/0x6
[ 1034.572446]  [<ffffffff810b0b38>] ? trace_hardirqs_off_caller+0x28/0xc0
[ 1034.581996]  [<ffffffff81005751>] ? print_context_stack+0x11/0xf0
[ 1034.591538]  [<ffffffff8131ac5d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 1034.595562]  [<ffffffff81005751>] ? print_context_stack+0x11/0xf0
[ 1034.599553]  [<ffffffff8165b42f>] page_fault+0x1f/0x30
[ 1034.603473]  [<ffffffff81005751>] ? print_context_stack+0x11/0xf0
[ 1034.612922]  [<ffffffff81104020>] ? __add_hash_entry+0x90/0x90
[ 1034.616813]  [<ffffffff8131ef40>] ? bsearch+0x60/0x90
[ 1034.620667]  [<ffffffff81104020>] ? __add_hash_entry+0x90/0x90
[ 1034.624529]  [<ffffffff8165e9e9>] ? add_preempt_count+0x9/0xe0
[ 1034.628378]  [<ffffffff8165b466>] ? paranoid_exit+0x6/0x1b
[ 1034.637760]  [<ffffffff810b0b38>] ? trace_hardirqs_off_caller+0x28/0xc0
[ 1034.647158]  [<ffffffff8131ac5d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 1034.651037]  [<ffffffff81104020>] ? __add_hash_entry+0x90/0x90
[ 1034.654882]  [<ffffffff8165e9e9>] ? add_preempt_count+0x9/0xe0
[ 1034.658726]  [<ffffffff8165b466>] ? paranoid_exit+0x6/0x1b
[ 1034.662576]  [<ffffffff8165e9ee>] ? add_preempt_count+0xe/0xe0
[ 1034.671903]  <<EOE>> 
[ 1034.671903] ---[ end trace d0e6e5741aaf56ae ]---
[ 1042.542768] BUG: soft lockup - CPU#4 stuck for 22s! [bash:736]
[ 1042.550033] Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables crc32c_intel ghash_clmulni_intel microcode usb_debug serio_raw pcspkr iTCO_wdt i2c_i801 iTCO_vendor_support e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
[ 1042.562286] irq event stamp: 109562
[ 1042.569389] hardirqs last  enabled at (109561): [<ffffffff8165b4f4>] paranoid_restore+0x10/0x66
[ 1042.576591] hardirqs last disabled at (109562): [<ffffffff8165a1e9>] _raw_spin_lock_irq+0x19/0x80
[ 1042.583959] softirqs last  enabled at (109554): [<ffffffff81052054>] __do_softirq+0x144/0x3d0
[ 1042.591204] softirqs last disabled at (109533): [<ffffffff81663e4c>] call_softirq+0x1c/0x30
[ 1042.598508] CPU 4 
[ 1042.606084] Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables crc32c_intel ghash_clmulni_intel microcode usb_debug serio_raw pcspkr iTCO_wdt i2c_i801 iTCO_vendor_support e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
[ 1042.622155] 
[ 1042.629673] Pid: 736, comm: bash Tainted: G      D W    3.4.0+ #30 
[ 1042.637406] RIP: 0010:[<ffffffff810be800>]  [<ffffffff810be800>] smp_call_function_many+0x1f0/0x260
[ 1042.645077] RSP: 0018:ffff88014251bbf8  EFLAGS: 00000202
[ 1042.652634] RAX: 0000000000000001 RBX: ffffffff8165b21d RCX: 0000000000000000
[ 1042.660277] RDX: 0000000000000004 RSI: ffffffff8118eab5 RDI: ffffffff810b6edd
[ 1042.667798] RBP: ffff88014251bc38 R08: ffff880143a1f2d8 R09: 0000000000000000
[ 1042.675538] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88014251bb68
[ 1042.683235] R13: ffff8801485d3080 R14: ffff88014251a000 R15: ffff88014251bfd8
[ 1042.690960] FS:  00007f206db43740(0000) GS:ffff880148400000(0000) knlGS:0000000000000000
[ 1042.698725] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1042.706516] CR2: 00000037682bad10 CR3: 0000000141f10000 CR4: 00000000001407e0
[ 1042.714256] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1042.722048] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1042.729836] Process bash (pid: 736, threadinfo ffff88014251a000, task ffff880145834d40)
[ 1042.734323] Stack:
[ 1042.741936]  0000000000000000 ffffffff81029970 0000000000000296 ffffffff81029970
[ 1042.746452]  0000000000000000 0000000000000001 00000000000062f9 ffffffff816626d0
[ 1042.750989]  ffff88014251bc68 ffffffff810be976 ffff88014251bc68 0000000000000001
[ 1042.755485] Call Trace:
[ 1042.759885]  [<ffffffff81029970>] ? apic_send_IPI_self+0x50/0x50
[ 1042.764367]  [<ffffffff81029970>] ? apic_send_IPI_self+0x50/0x50
[ 1042.768858]  [<ffffffff816626d0>] ? mcount+0x10/0x10
[ 1042.773295]  [<ffffffff810be976>] smp_call_function+0x46/0x80
[ 1042.777761]  [<ffffffff81029970>] ? apic_send_IPI_self+0x50/0x50
[ 1042.785902]  [<ffffffff810bea1c>] on_each_cpu+0x3c/0xb0
[ 1042.794051]  [<ffffffff81029bde>] run_sync+0x1e/0x50
[ 1042.802138]  [<ffffffff8102a021>] ftrace_replace_code+0x291/0x380
[ 1042.806621]  [<ffffffff811079ca>] ftrace_modify_all_code+0x6a/0x80
[ 1042.811074]  [<ffffffff8102a120>] arch_ftrace_update_code+0x10/0x20
[ 1042.815520]  [<ffffffff81107a42>] ftrace_run_update_code+0x22/0xa0
[ 1042.819982]  [<ffffffff81107af9>] ftrace_startup_enable+0x39/0x50
[ 1042.824413]  [<ffffffff811081b6>] ftrace_startup+0x46/0x80
[ 1042.828836]  [<ffffffff81108233>] register_ftrace_function+0x43/0x70
[ 1042.833253]  [<ffffffff81118299>] start_irqsoff_tracer.isra.1+0x19/0x70
[ 1042.837695]  [<ffffffff8111833c>] __irqsoff_tracer_init+0x4c/0x70
[ 1042.842104]  [<ffffffff811183b3>] irqsoff_tracer_init+0x13/0x20
[ 1042.846508]  [<ffffffff81113f46>] tracer_init+0x26/0x30
[ 1042.850913]  [<ffffffff811144dd>] tracing_set_tracer+0x27d/0x320
[ 1042.855332]  [<ffffffff81114645>] tracing_set_trace_write+0xc5/0x100
[ 1042.859768]  [<ffffffff810b0b38>] ? trace_hardirqs_off_caller+0x28/0xc0
[ 1042.864194]  [<ffffffff810860f1>] ? get_parent_ip+0x11/0x50
[ 1042.868600]  [<ffffffff812ad58c>] ? security_file_permission+0x2c/0xb0
[ 1042.873036]  [<ffffffff811a728f>] vfs_write+0xaf/0x190
[ 1042.877429]  [<ffffffff811a75cd>] sys_write+0x4d/0x90
[ 1042.881836]  [<ffffffff81662952>] system_call_fastpath+0x16/0x1b
[ 1042.886746] Code: c0 81 e8 b4 c5 59 00 0f ae f0 49 8b 7e 30 ff 15 7f df b5 00 45 84 ff 0f 84 91 fe ff ff 41 f6 46 20 01 0f 84 86 fe ff ff 0f 1f 00 <f3> 90 41 f6 46 20 01 75 f7 e9 75 fe ff ff 66 90 48 8b 55 c0 48 
[ 1070.519234] BUG: soft lockup - CPU#4 stuck for 22s! [bash:736]
[ 1070.527311] Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables crc32c_intel ghash_clmulni_intel microcode usb_debug serio_raw pcspkr iTCO_wdt i2c_i801 iTCO_vendor_support e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
[ 1070.541727] irq event stamp: 109562
[ 1070.546312] hardirqs last  enabled at (109561): [<ffffffff8165b4f4>] paranoid_restore+0x10/0x66
[ 1070.551010] hardirqs last disabled at (109562): [<ffffffff8165a1e9>] _raw_spin_lock_irq+0x19/0x80
[ 1070.558796] softirqs last  enabled at (109554): [<ffffffff81052054>] __do_softirq+0x144/0x3d0
[ 1070.566674] softirqs last disabled at (109533): [<ffffffff81663e4c>] call_softirq+0x1c/0x30
[ 1070.574547] CPU 4 
[ 1070.582620] Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables crc32c_intel ghash_clmulni_intel microcode usb_debug serio_raw pcspkr iTCO_wdt i2c_i801 iTCO_vendor_support e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
[ 1070.600333] 
[ 1070.608261] Pid: 736, comm: bash Tainted: G      D W    3.4.0+ #30 
[ 1070.616428] RIP: 0010:[<ffffffff810be807>]  [<ffffffff810be807>] smp_call_function_many+0x1f7/0x260
[ 1070.624512] RSP: 0018:ffff88014251bbf8  EFLAGS: 00000202
[ 1070.632485] RAX: 0000000000000001 RBX: ffffffff8165b21d RCX: 0000000000000000
[ 1070.640481] RDX: 0000000000000004 RSI: ffffffff8118eab5 RDI: ffffffff810b6edd
[ 1070.648436] RBP: ffff88014251bc38 R08: ffff880143a1f2d8 R09: 0000000000000000
[ 1070.656434] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88014251bb68
[ 1070.661106] R13: ffff8801485d3080 R14: ffff88014251a000 R15: ffff88014251bfd8
[ 1070.665787] FS:  00007f206db43740(0000) GS:ffff880148400000(0000) knlGS:0000000000000000
[ 1070.673817] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1070.681771] CR2: 00000037682bad10 CR3: 0000000141f10000 CR4: 00000000001407e0
[ 1070.686462] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1070.691116] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1070.695776] Process bash (pid: 736, threadinfo ffff88014251a000, task ffff880145834d40)
[ 1070.703590] Stack:
[ 1070.711420]  0000000000000000 ffffffff81029970 0000000000000296 ffffffff81029970
[ 1070.719481]  0000000000000000 0000000000000001 00000000000062f9 ffffffff816626d0
[ 1070.727507]  ffff88014251bc68 ffffffff810be976 ffff88014251bc68 0000000000000001
[ 1070.732175] Call Trace:
[ 1070.736713]  [<ffffffff81029970>] ? apic_send_IPI_self+0x50/0x50
[ 1070.741355]  [<ffffffff81029970>] ? apic_send_IPI_self+0x50/0x50
[ 1070.745956]  [<ffffffff816626d0>] ? mcount+0x10/0x10
[ 1070.750539]  [<ffffffff810be976>] smp_call_function+0x46/0x80
[ 1070.755146]  [<ffffffff81029970>] ? apic_send_IPI_self+0x50/0x50
[ 1070.759755]  [<ffffffff810bea1c>] on_each_cpu+0x3c/0xb0
[ 1070.768201]  [<ffffffff81029bde>] run_sync+0x1e/0x50
[ 1070.776475]  [<ffffffff8102a021>] ftrace_replace_code+0x291/0x380
[ 1070.781125]  [<ffffffff811079ca>] ftrace_modify_all_code+0x6a/0x80
[ 1070.785743]  [<ffffffff8102a120>] arch_ftrace_update_code+0x10/0x20
[ 1070.790372]  [<ffffffff81107a42>] ftrace_run_update_code+0x22/0xa0
[ 1070.794988]  [<ffffffff81107af9>] ftrace_startup_enable+0x39/0x50
[ 1070.799614]  [<ffffffff811081b6>] ftrace_startup+0x46/0x80
[ 1070.804221]  [<ffffffff81108233>] register_ftrace_function+0x43/0x70
[ 1070.808842]  [<ffffffff81118299>] start_irqsoff_tracer.isra.1+0x19/0x70
[ 1070.813494]  [<ffffffff8111833c>] __irqsoff_tracer_init+0x4c/0x70
[ 1070.821897]  [<ffffffff811183b3>] irqsoff_tracer_init+0x13/0x20
[ 1070.830209]  [<ffffffff81113f46>] tracer_init+0x26/0x30
[ 1070.838475]  [<ffffffff811144dd>] tracing_set_tracer+0x27d/0x320
[ 1070.846763]  [<ffffffff81114645>] tracing_set_trace_write+0xc5/0x100
[ 1070.851413]  [<ffffffff810b0b38>] ? trace_hardirqs_off_caller+0x28/0xc0
[ 1070.856060]  [<ffffffff810860f1>] ? get_parent_ip+0x11/0x50
[ 1070.860663]  [<ffffffff812ad58c>] ? security_file_permission+0x2c/0xb0
[ 1070.865317]  [<ffffffff811a728f>] vfs_write+0xaf/0x190
[ 1070.869913]  [<ffffffff811a75cd>] sys_write+0x4d/0x90
[ 1070.874531]  [<ffffffff81662952>] system_call_fastpath+0x16/0x1b
[ 1070.883313] Code: 0f ae f0 49 8b 7e 30 ff 15 7f df b5 00 45 84 ff 0f 84 91 fe ff ff 41 f6 46 20 01 0f 84 86 fe ff ff 0f 1f 00 f3 90 41 f6 46 20 01 <75> f7 e9 75 fe ff ff 66 90 48 8b 55 c0 48 8b 75 c8 41 0f b6 cf 
[ 1098.495701] BUG: soft lockup - CPU#4 stuck for 23s! [bash:736]
[ 1098.503796] Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables crc32c_intel ghash_clmulni_intel microcode usb_debug serio_raw pcspkr iTCO_wdt i2c_i801 iTCO_vendor_support e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
[ 1098.521248] irq event stamp: 109562
[ 1098.529054] hardirqs last  enabled at (109561): [<ffffffff8165b4f4>] paranoid_restore+0x10/0x66
[ 1098.533770] hardirqs last disabled at (109562): [<ffffffff8165a1e9>] _raw_spin_lock_irq+0x19/0x80
[ 1098.538489] softirqs last  enabled at (109554): [<ffffffff81052054>] __do_softirq+0x144/0x3d0
[ 1098.543228] softirqs last disabled at (109533): [<ffffffff81663e4c>] call_softirq+0x1c/0x30
[ 1098.551115] CPU 4 
[ 1098.559187] Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables crc32c_intel ghash_clmulni_intel microcode usb_debug serio_raw pcspkr iTCO_wdt i2c_i801 iTCO_vendor_support e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
[ 1098.576879] 
[ 1098.584800] Pid: 736, comm: bash Tainted: G      D W    3.4.0+ #30 
[ 1098.589602] RIP: 0010:[<ffffffff810be807>]  [<ffffffff810be807>] smp_call_function_many+0x1f7/0x260
[ 1098.594390] RSP: 0018:ffff88014251bbf8  EFLAGS: 00000202
[ 1098.602434] RAX: 0000000000000001 RBX: ffffffff8165b21d RCX: 0000000000000000
[ 1098.610433] RDX: 0000000000000004 RSI: ffffffff8118eab5 RDI: ffffffff810b6edd
[ 1098.618362] RBP: ffff88014251bc38 R08: ffff880143a1f2d8 R09: 0000000000000000
[ 1098.626485] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88014251bb68
[ 1098.631200] R13: ffff8801485d3080 R14: ffff88014251a000 R15: ffff88014251bfd8
[ 1098.635898] FS:  00007f206db43740(0000) GS:ffff880148400000(0000) knlGS:0000000000000000
[ 1098.640604] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1098.645262] CR2: 00000037682bad10 CR3: 0000000141f10000 CR4: 00000000001407e0
[ 1098.649957] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1098.657983] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1098.662678] Process bash (pid: 736, threadinfo ffff88014251a000, task ffff880145834d40)
[ 1098.667361] Stack:
[ 1098.671941]  0000000000000000 ffffffff81029970 0000000000000296 ffffffff81029970
[ 1098.680070]  0000000000000000 0000000000000001 00000000000062f9 ffffffff816626d0
[ 1098.688135]  ffff88014251bc68 ffffffff810be976 ffff88014251bc68 0000000000000001
[ 1098.696133] Call Trace:
[ 1098.704135]  [<ffffffff81029970>] ? apic_send_IPI_self+0x50/0x50
[ 1098.708787]  [<ffffffff81029970>] ? apic_send_IPI_self+0x50/0x50
[ 1098.713402]  [<ffffffff816626d0>] ? mcount+0x10/0x10
[ 1098.717993]  [<ffffffff810be976>] smp_call_function+0x46/0x80
[ 1098.726269]  [<ffffffff81029970>] ? apic_send_IPI_self+0x50/0x50
[ 1098.730928]  [<ffffffff810bea1c>] on_each_cpu+0x3c/0xb0
[ 1098.735545]  [<ffffffff81029bde>] run_sync+0x1e/0x50
[ 1098.743887]  [<ffffffff8102a021>] ftrace_replace_code+0x291/0x380
[ 1098.752191]  [<ffffffff811079ca>] ftrace_modify_all_code+0x6a/0x80
[ 1098.756840]  [<ffffffff8102a120>] arch_ftrace_update_code+0x10/0x20
[ 1098.761471]  [<ffffffff81107a42>] ftrace_run_update_code+0x22/0xa0
[ 1098.769736]  [<ffffffff81107af9>] ftrace_startup_enable+0x39/0x50
[ 1098.778035]  [<ffffffff811081b6>] ftrace_startup+0x46/0x80
[ 1098.786299]  [<ffffffff81108233>] register_ftrace_function+0x43/0x70
[ 1098.794641]  [<ffffffff81118299>] start_irqsoff_tracer.isra.1+0x19/0x70
[ 1098.799297]  [<ffffffff8111833c>] __irqsoff_tracer_init+0x4c/0x70
[ 1098.803952]  [<ffffffff811183b3>] irqsoff_tracer_init+0x13/0x20
[ 1098.808601]  [<ffffffff81113f46>] tracer_init+0x26/0x30
[ 1098.816936]  [<ffffffff811144dd>] tracing_set_tracer+0x27d/0x320
[ 1098.825254]  [<ffffffff81114645>] tracing_set_trace_write+0xc5/0x100
[ 1098.833579]  [<ffffffff810b0b38>] ? trace_hardirqs_off_caller+0x28/0xc0
[ 1098.841906]  [<ffffffff810860f1>] ? get_parent_ip+0x11/0x50
[ 1098.846546]  [<ffffffff812ad58c>] ? security_file_permission+0x2c/0xb0
[ 1098.851204]  [<ffffffff811a728f>] vfs_write+0xaf/0x190
[ 1098.855838]  [<ffffffff811a75cd>] sys_write+0x4d/0x90
[ 1098.864166]  [<ffffffff81662952>] system_call_fastpath+0x16/0x1b
[ 1098.872969] Code: 0f ae f0 49 8b 7e 30 ff 15 7f df b5 00 45 84 ff 0f 84 91 fe ff ff 41 f6 46 20 01 0f 84 86 fe ff ff 0f 1f 00 f3 90 41 f6 46 20 01 <75> f7 e9 75 fe ff ff 66 90 48 8b 55 c0 48 8b 75 c8 41 0f b6 cf 
[ 1126.472169] BUG: soft lockup - CPU#4 stuck for 23s! [bash:736]
[ 1126.480251] Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables crc32c_intel ghash_clmulni_intel microcode usb_debug serio_raw pcspkr iTCO_wdt i2c_i801 iTCO_vendor_support e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
[ 1126.494669] irq event stamp: 109562
[ 1126.502447] hardirqs last  enabled at (109561): [<ffffffff8165b4f4>] paranoid_restore+0x10/0x66
[ 1126.507139] hardirqs last disabled at (109562): [<ffffffff8165a1e9>] _raw_spin_lock_irq+0x19/0x80
[ 1126.511860] softirqs last  enabled at (109554): [<ffffffff81052054>] __do_softirq+0x144/0x3d0
[ 1126.519665] softirqs last disabled at (109533): [<ffffffff81663e4c>] call_softirq+0x1c/0x30
[ 1126.527532] CPU 4 
[ 1126.535574] Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables crc32c_intel ghash_clmulni_intel microcode usb_debug serio_raw pcspkr iTCO_wdt i2c_i801 iTCO_vendor_support e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
[ 1126.553312] 
[ 1126.561265] Pid: 736, comm: bash Tainted: G      D W    3.4.0+ #30 
[ 1126.566064] RIP: 0010:[<ffffffff810be800>]  [<ffffffff810be800>] smp_call_function_many+0x1f0/0x260
[ 1126.570845] RSP: 0018:ffff88014251bbf8  EFLAGS: 00000202
[ 1126.575491] RAX: 0000000000000001 RBX: ffffffff8165b21d RCX: 0000000000000000
[ 1126.580161] RDX: 0000000000000004 RSI: ffffffff8118eab5 RDI: ffffffff810b6edd
[ 1126.584818] RBP: ffff88014251bc38 R08: ffff880143a1f2d8 R09: 0000000000000000
[ 1126.592642] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88014251bb68
[ 1126.600621] R13: ffff8801485d3080 R14: ffff88014251a000 R15: ffff88014251bfd8
[ 1126.608614] FS:  00007f206db43740(0000) GS:ffff880148400000(0000) knlGS:0000000000000000
[ 1126.616664] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1126.621333] CR2: 00000037682bad10 CR3: 0000000141f10000 CR4: 00000000001407e0
[ 1126.626014] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1126.630706] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1126.635392] Process bash (pid: 736, threadinfo ffff88014251a000, task ffff880145834d40)
[ 1126.640072] Stack:
[ 1126.644634]  0000000000000000 ffffffff81029970 0000000000000296 ffffffff81029970
[ 1126.652702]  0000000000000000 0000000000000001 00000000000062f9 ffffffff816626d0
[ 1126.657407]  ffff88014251bc68 ffffffff810be976 ffff88014251bc68 0000000000000001
[ 1126.662081] Call Trace:
[ 1126.666629]  [<ffffffff81029970>] ? apic_send_IPI_self+0x50/0x50
[ 1126.674930]  [<ffffffff81029970>] ? apic_send_IPI_self+0x50/0x50
[ 1126.679558]  [<ffffffff816626d0>] ? mcount+0x10/0x10
[ 1126.684141]  [<ffffffff810be976>] smp_call_function+0x46/0x80
[ 1126.688747]  [<ffffffff81029970>] ? apic_send_IPI_self+0x50/0x50
[ 1126.693382]  [<ffffffff810bea1c>] on_each_cpu+0x3c/0xb0
[ 1126.697991]  [<ffffffff81029bde>] run_sync+0x1e/0x50
[ 1126.702594]  [<ffffffff8102a021>] ftrace_replace_code+0x291/0x380
[ 1126.707242]  [<ffffffff811079ca>] ftrace_modify_all_code+0x6a/0x80
[ 1126.711867]  [<ffffffff8102a120>] arch_ftrace_update_code+0x10/0x20
[ 1126.720179]  [<ffffffff81107a42>] ftrace_run_update_code+0x22/0xa0
[ 1126.724823]  [<ffffffff81107af9>] ftrace_startup_enable+0x39/0x50
[ 1126.729459]  [<ffffffff811081b6>] ftrace_startup+0x46/0x80
[ 1126.734078]  [<ffffffff81108233>] register_ftrace_function+0x43/0x70
[ 1126.742457]  [<ffffffff81118299>] start_irqsoff_tracer.isra.1+0x19/0x70
[ 1126.747139]  [<ffffffff8111833c>] __irqsoff_tracer_init+0x4c/0x70
[ 1126.751772]  [<ffffffff811183b3>] irqsoff_tracer_init+0x13/0x20
[ 1126.756408]  [<ffffffff81113f46>] tracer_init+0x26/0x30
[ 1126.764618]  [<ffffffff811144dd>] tracing_set_tracer+0x27d/0x320
[ 1126.772879]  [<ffffffff81114645>] tracing_set_trace_write+0xc5/0x100
[ 1126.781233]  [<ffffffff810b0b38>] ? trace_hardirqs_off_caller+0x28/0xc0
[ 1126.789573]  [<ffffffff810860f1>] ? get_parent_ip+0x11/0x50
[ 1126.797825]  [<ffffffff812ad58c>] ? security_file_permission+0x2c/0xb0
[ 1126.806145]  [<ffffffff811a728f>] vfs_write+0xaf/0x190
[ 1126.810757]  [<ffffffff811a75cd>] sys_write+0x4d/0x90
[ 1126.815386]  [<ffffffff81662952>] system_call_fastpath+0x16/0x1b
[ 1126.820508] Code: c0 81 e8 b4 c5 59 00 0f ae f0 49 8b 7e 30 ff 15 7f df b5 00 45 84 ff 0f 84 91 fe ff ff 41 f6 46 20 01 0f 84 86 fe ff ff 0f 1f 00 <f3> 90 41 f6 46 20 01 75 f7 e9 75 fe ff ff 66 90 48 8b 55 c0 48 


and then a bunch more CPU stuck for the other cpus..

