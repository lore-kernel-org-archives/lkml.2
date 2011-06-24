Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab1FXRdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 13:33:53 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:62581 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab1FXRdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 13:33:52 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4E04CA6E.2080805@elka.pw.edu.pl>
Date: Fri, 24 Jun 2011 19:33:34 +0200
From: Wojtek Zabolotny <W.Zabolotny@elka.pw.edu.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110606 Icedove/3.1.10
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel 2.6.39.2 - incorrect calling of sleeping function and
  lockdep problem found
References: <4E04C82C.1090201@elka.pw.edu.pl> <4E04C966.9080002@elka.pw.edu.pl>
In-Reply-To: <4E04C966.9080002@elka.pw.edu.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And yet another attempt to boot the afffected machine:

[  356.830062] IR NEC protocol handler initialized
[  367.507094] IR RC5(x) protocol handler initialized
[  377.053379] ERROR: kmemcheck: Fatal error
[  377.057471]
[  377.058967] Pid: 1194, comm: udevd Tainted: G        W   2.6.39.2 #1                  /D865GBF
[  377.069867] EIP: 0060:[<c01be039>] EFLAGS: 00000186 CPU: 0
[  377.075437] EIP is at kmem_cache_free+0x49/0xc0
[  377.080044] EAX: 0000002f EBX: f5c06a80 ECX: 00000038 EDX: c01b4250
[  377.086387] ESI: f5c94c00 EDI: f036ae10 EBP: efc41de8 ESP: c083430c
[  377.092733]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  377.098211] CR0: 8005003b CR2: f5c342c8 CR3: 2fe53000 CR4: 000006d0
[  377.104557] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  377.110900] DR6: ffff4ff0 DR7: 00000400
[  377.114820]  [<c0126c38>] kmemcheck_error_save_bug+0x58/0x90
[  377.120582]  [<c012735b>] kmemcheck_hide+0xbb/0xe0
[  377.125463]  [<c0127568>] kmemcheck_trap+0x18/0x30
[  377.130437]  [<c01037ec>] do_debug+0x11c/0x1a0
[  377.134972]  [<c0462bb6>] debug_stack_correct+0x2e/0x34
[  377.140303]  [<c01b551b>] __put_anon_vma+0x3b/0x40
[  377.145200]  [<c01b5701>] unlink_anon_vmas+0x91/0xa0
[  377.150270]  [<c01ac0f4>] free_pgtables+0x64/0xc0
[  377.155081]  [<c01b2a85>] exit_mmap+0xf5/0x180
[  377.159614]  [<c013a129>] mmput.part.45+0x19/0x90
[  377.164504]  [<c013a1c9>] mmput+0x29/0x30
[  377.168611]  [<c01c94ba>] exec_mmap+0x12a/0x380
[  377.173241]  [<c01ca275>] flush_old_exec+0x55/0xa0
[  377.178216]  [<c02016b4>] load_elf_binary+0x214/0x9f0
[  377.183374]  [<c01c8e51>] search_binary_handler+0xd1/0x2b0
[  377.188955]  [<c01cab47>] do_execve+0x1d7/0x250
[  377.193662]  [<c010aa52>] sys_execve+0x32/0x70
[  377.198205]  [<c0462e86>] ptregs_execve+0x12/0x18
[  377.203000]  [<ffffffff>] 0xffffffff
[  381.643766] bttv: driver version 0.9.18 loaded
[...]
[  463.006917] INFO: task udevd:1087 blocked for more than 120 seconds.
[  463.070046] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  463.180300] udevd           D 00000000     0  1087   1066 0x00000000
[  463.229429]  f2943d94
[  463.296974]  00000046 0000004f 00000000 c0823a80 f6146a80 c05f14a0 c06dd000
[  463.380057]  f2914a80 0000004f f6146480 f2940d10 f1341210 00000086 f2943d48 f2941180
[  463.483632]  f2941180 f2943d54 f2940d10 00000006 00000000 f2940d10 00000006 f2943d7c
[  463.547713] Call Trace:
[  463.617235]  [<c016d273>] ? mark_held_locks+0x53/0x80
[  463.691036]  [<c0135d8b>] ? get_parent_ip+0xb/0x40
[  463.750599]  [<c0135dfb>] ? sub_preempt_count.part.142+0x3b/0x80
[  463.823394]  [<c04608f7>] mutex_lock_nested+0x157/0x340
[  463.904144]  [<c02fbcce>] ? tty_open+0x4e/0x400
[  463.940375]  [<c02fbcce>] ? tty_open+0x4e/0x400
[  464.013398]  [<c02fbcce>] tty_open+0x4e/0x400
[  464.060061]  [<c01c763a>] chrdev_open+0xea/0x1e0
[  464.126782]  [<c01c13a6>] __dentry_open+0x176/0x320
[  464.184828]  [<c0462187>] ? _raw_spin_unlock+0x27/0x50
[  464.263390]  [<c01c2656>] nameidata_to_filp+0x66/0x80
[  464.323422]  [<c01c7550>] ? cdev_put+0x20/0x20
[  464.377192]  [<c01d07a5>] do_last.isra.34+0x255/0x600
[  464.436805]  [<c01d10ad>] path_openat+0x8d/0x350
[  464.496728]  [<c0135e5f>] ? sub_preempt_count+0x1f/0x50
[  464.570441]  [<c01d139c>] do_filp_open+0x2c/0x80
[  464.633406]  [<c0462187>] ? _raw_spin_unlock+0x27/0x50
[  464.706777]  [<c01dd747>] ? alloc_fd+0x157/0x1a0
[  464.754254]  [<c01c2751>] do_sys_open+0xe1/0x1b0
[  464.816927]  [<c01c2849>] sys_open+0x29/0x40
[  464.874339]  [<c0462e10>] sysenter_do_call+0x12/0x36
[  464.956993] 1 lock held by udevd/1087:
[  465.010113]  #0:  (tty_mutex){+.+.+.}, at: [<c02fbcce>] tty_open+0x4e/0x400
[  465.103384] Kernel panic - not syncing: hung_task: blocked tasks
[  465.109476] Pid: 351, comm: khungtaskd Tainted: G        W   2.6.39.2 #1
[  465.116265] Call Trace:
[  465.118808]  [<c0456a7c>] ? printk+0x18/0x1a
[  465.123162]  [<c04568b7>] panic+0x61/0x156
[  465.127356]  [<c017f5df>] ? touch_nmi_watchdog+0x4f/0x90
[  465.132748]  [<c017edc1>] check_hung_task+0xa1/0xb0
[  465.137707]  [<c017efb4>] check_hung_uninterruptible_tasks+0x134/0x180
[  465.144325]  [<c017eeb8>] ? check_hung_uninterruptible_tasks+0x38/0x180
[  465.151020]  [<c017f000>] ? check_hung_uninterruptible_tasks+0x180/0x180
[  465.157802]  [<c017f039>] watchdog+0x39/0x40
[  465.162158]  [<c0156938>] kthread+0x68/0x70
[  465.166430]  [<c01568d0>] ? __init_kthread_worker+0x60/0x60
[  465.172122]  [<c046333a>] kernel_thread_helper+0x6/0xd

Configuration of kernel still the same as reported in the first message.
-- 
Regards,
WZab

