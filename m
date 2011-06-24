Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab1FXR3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 13:29:30 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:62533 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab1FXR33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 13:29:29 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4E04C966.9080002@elka.pw.edu.pl>
Date: Fri, 24 Jun 2011 19:29:10 +0200
From: Wojtek Zabolotny <W.Zabolotny@elka.pw.edu.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110606 Icedove/3.1.10
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel 2.6.39.2 - incorrect calling of sleeping function and
  lockdep problem found
References: <4E04C82C.1090201@elka.pw.edu.pl>
In-Reply-To: <4E04C82C.1090201@elka.pw.edu.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yet another problems recorded in different boots:

 From the booting reported in the previous message:

[  368.921715] kobject: 'snd_hwdep' (f83f20c8): fill_kobj_path: path = '/module/snd_hwdep'
[  370.295518] BUG: sleeping function called from invalid context at mm/slab.c:3102
[  370.296646] in_atomic(): 0, irqs_disabled(): 1, pid: 1082, name: udevd
[  370.296646] INFO: lockdep is turned off.
[  370.296646] irq event stamp: 1111674
[  370.296646] hardirqs last  enabled at (1111673): [<c01839c6>] rcu_preempt_note_context_switch+0x66/0x150
[  370.296646] hardirqs last disabled at (1111674): [<c0461960>] _raw_spin_lock_irq+0x10/0x80
[  370.296646] softirqs last  enabled at (1111670): [<c0141e3c>] __do_softirq+0xdc/0x130
[  370.296646] softirqs last disabled at (1111653): [<c0104c07>] do_softirq+0x87/0xd0
[  370.296646] Pid: 1082, comm: udevd Tainted: G        W   2.6.39.2 #1
[  370.296646] Call Trace:
[  370.296646]  [<c0104c07>] ? do_softirq+0x87/0xd0
[  370.296646]  [<c04564c6>] __might_sleep.part.127+0x8f/0x95
[  370.296646]  [<c012fb11>] __might_sleep+0x71/0x90
[  370.296646]  [<c01be851>] kmem_cache_alloc+0xe1/0x110
[  370.296646]  [<c0462556>] ? ret_from_exception+0x6/0x6
[  370.296646]  [<c01c48b4>] get_empty_filp+0x54/0x210
[  370.296646]  [<c013007b>] ? scale_rt_power+0x5b/0xd0
[  370.296646]  [<c01c4a8b>] alloc_file+0x1b/0xd0
[  370.296646]  [<c01cc6cf>] create_write_pipe+0x6f/0xe0
[  370.296646]  [<c01cc808>] do_pipe_flags+0x28/0xd0
[  370.296646]  [<c01cc8c2>] sys_pipe2+0x12/0x60
[  370.296646]  [<c028d1a0>] ? trace_hardirqs_on_thunk+0xc/0x10
[  370.296646]  [<c0462e10>] sysenter_do_call+0x12/0x36
[  370.424622] ERROR: kmemcheck: Fatal error
[  370.428702]
[  370.430262] Pid: 1082, comm: udevd Tainted: G        W   2.6.39.2 #1                  /D865GBF
[  370.441208] EIP: 0060:[<c01d6557>] EFLAGS: 00010146 CPU: 0
[  370.446768] EIP is at d_set_d_op+0x17/0xb0
[  370.450933] EAX: 00000000 EBX: f3e70788 ECX: c0d7a869 EDX: c0471b80
[  370.457261] ESI: c0471b80 EDI: 00000002 EBP: f4a8ff44 ESP: c083430c
[  370.463588]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  370.469050] CR0: 80050033 CR2: f5c32dd8 CR3: 34a1d000 CR4: 000006d0
[  370.475386] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  370.481722] DR6: ffff4ff0 DR7: 00000400
[  370.485623]  [<c0126c38>] kmemcheck_error_save_bug+0x58/0x90
[  370.491438]  [<c0127294>] kmemcheck_show+0x64/0x70
[  370.496319]  [<c01274fd>] kmemcheck_fault+0x6d/0xc0
[  370.501346]  [<c0122df0>] do_page_fault+0x270/0x440
[  370.506304]  [<c0462b63>] error_code+0x5f/0x64
[  370.510896]  [<c01d8229>] d_alloc_pseudo+0x29/0x40
[  370.515770]  [<c01cc69f>] create_write_pipe+0x3f/0xe0
[  370.520969]  [<c01cc808>] do_pipe_flags+0x28/0xd0
[  370.525754]  [<c01cc8c2>] sys_pipe2+0x12/0x60
[  370.530264]  [<c0462e10>] sysenter_do_call+0x12/0x36
[  370.535308]  [<ffffffff>] 0xffffffff
[  371.110773] kobject: 'snd_pcm' (f8427568): kobject_add_internal: parent: 'module', set: 'module'

Another booting - now with kmemcheck errors:

[  339.361602] hub 5-0:1.0: 2 ports detected
[  370.530048] ERROR: kmemcheck: Fatal error
[  370.534146]
[  370.535640] Pid: 1593, comm: net.agent Tainted: G        W   2.6.39.2 #1                  /D865GBF
[  370.546969] EIP: 0060:[<c01970d0>] EFLAGS: 00010102 CPU: 0
[  370.552539] EIP is at filemap_fault+0x200/0x3b0
[  370.557145] EAX: 8002006d EBX: f587610c ECX: 00000008 EDX: f5876278
[  370.563487] ESI: f77f67a8 EDI: 00000008 EBP: f3a3de80 ESP: c083430c
[  370.569832]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  370.575309] CR0: 8005003b CR2: f5c32dc0 CR3: 3391e000 CR4: 000006d0
[  370.581656] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  370.588001] DR6: ffff4ff0 DR7: 00000400
[  370.591919]  [<c0126c38>] kmemcheck_error_save_bug+0x58/0x90
[  370.597759]  [<c0127294>] kmemcheck_show+0x64/0x70
[  370.602648]  [<c01274fd>] kmemcheck_fault+0x6d/0xc0
[  370.607699]  [<c0122df0>] do_page_fault+0x270/0x440
[  370.612676]  [<c0462b63>] error_code+0x5f/0x64
[  370.617302]  [<c01ab809>] __do_fault+0x39/0x410
[  370.621931]  [<c01ae7f8>] handle_pte_fault+0x88/0x1e0
[  370.627159]  [<c01ae9d1>] handle_mm_fault+0x81/0xb0
[  370.632132]  [<c0122ca1>] do_page_fault+0x121/0x440
[  370.637187]  [<c0462b63>] error_code+0x5f/0x64
[  370.641726]  [<ffffffff>] 0xffffffff
[  457.433569] BUG: sleeping function called from invalid context at mm/memory.c:780
[  457.436638] in_atomic(): 0, irqs_disabled(): 1, pid: 1866, name: net.agent
[  457.436638] 2 locks held by net.agent/1866:
[  457.436638]  #0:  (&mm->mmap_sem){++++++}, at: [<c0139c5c>] dup_mmap+0x1c/0x280
[  457.436638]  #1:  (&mm->mmap_sem/1){+.+.+.}, at: [<c0139c6f>] dup_mmap+0x2f/0x280
[  457.436638] irq event stamp: 26954
[  457.436638] hardirqs last  enabled at (26953): [<c0462638>] restore_all_notrace+0x0/0x18
[  457.436638] hardirqs last disabled at (26954): [<c0462b5f>] error_code+0x5b/0x64
[  457.436638] softirqs last  enabled at (25006): [<c0141e3c>] __do_softirq+0xdc/0x130
[  457.436638] softirqs last disabled at (24989): [<c0104c07>] do_softirq+0x87/0xd0
[  457.436638] Pid: 1866, comm: net.agent Tainted: G        W   2.6.39.2 #1
[  457.436638] Call Trace:
[  457.436638]  [<c0104c07>] ? do_softirq+0x87/0xd0
[  457.436638]  [<c04564c6>] __might_sleep.part.127+0x8f/0x95
[  457.436638]  [<c012fb11>] __might_sleep+0x71/0x90
[  457.436638]  [<c01ad798>] copy_pte_range+0x238/0x350
[  457.436638]  [<c01ad969>] copy_page_range+0xb9/0x180
[  457.436638]  [<c0139de5>] dup_mmap+0x1a5/0x280
[  457.436638]  [<c013a5bd>] dup_mm+0x9d/0x170
[  457.436638]  [<c0456809>] copy_mm+0x76/0xc3
[  457.436638]  [<c013abd8>] copy_process.part.47+0x528/0xb00
[  457.436638]  [<c0122d23>] ? do_page_fault+0x1a3/0x440
[  457.436638]  [<c013b229>] copy_process+0x79/0x80
[  457.436638]  [<c013b2fa>] do_fork+0xaa/0x270
[  457.436638]  [<c01abe60>] ? might_fault+0x90/0xa0
[  457.436638]  [<c010aa0f>] sys_clone+0x2f/0x40
[  457.436638]  [<c0462ef1>] ptregs_clone+0x15/0x24
[  457.436638]  [<c0462e10>] ? sysenter_do_call+0x12/0x36
[  741.399946] BUG: sleeping function called from invalid context at mm/mmap.c:234
[  741.399946] in_atomic(): 0, irqs_disabled(): 1, pid: 3061, name: sleep
[  741.399946] no locks held by sleep/3061.
[  741.399946] irq event stamp: 43048
[  741.399946] hardirqs last  enabled at (43047): [<c0462638>] restore_all_notrace+0x0/0x18
[  741.399946] hardirqs last disabled at (43048): [<c0462b5f>] error_code+0x5b/0x64
[  741.399946] softirqs last  enabled at (42356): [<c0141e3c>] __do_softirq+0xdc/0x130
[  741.399946] softirqs last disabled at (42339): [<c0104c07>] do_softirq+0x87/0xd0
[  741.399946] Pid: 3061, comm: sleep Tainted: G        W   2.6.39.2 #1
[  741.399946] Call Trace:
[  741.399946]  [<c0104c07>] ? do_softirq+0x87/0xd0
[  741.399946]  [<c04564c6>] __might_sleep.part.127+0x8f/0x95
[  741.399946]  [<c012fb11>] __might_sleep+0x71/0x90
[  741.399946]  [<c01b062b>] remove_vma+0x1b/0x70
[  741.399946]  [<c01b2aaf>] exit_mmap+0x11f/0x180
[  741.399946]  [<c013a129>] mmput.part.45+0x19/0x90
[  741.399946]  [<c013a1c9>] mmput+0x29/0x30
[  741.399946]  [<c013de4a>] exit_mm+0xea/0x120
[  741.399946]  [<c017e3e7>] ? acct_collect+0x127/0x170
[  741.399946]  [<c013fef2>] do_exit+0x212/0x310
[  741.399946]  [<c01c5577>] ? fput+0x7/0x20
[  741.399946]  [<c01c163f>] ? filp_close+0x4f/0x70
[  741.399946]  [<c0140133>] do_group_exit+0x33/0x90
[  741.399946]  [<c01401a3>] sys_exit_group+0x13/0x20
[  741.399946]  [<c0462e10>] sysenter_do_call+0x12/0x36
[  741.531841] ERROR: kmemcheck: Fatal error
[  741.535933]
[  741.537510] Pid: 3061, comm: sleep Tainted: G        W   2.6.39.2 #1                  /D865GBF
[  741.548411] EIP: 0060:[<c01ad4a5>] EFLAGS: 00010187 CPU: 0
[  741.553979] EIP is at unmap_page_range+0x35/0xf0
[  741.558674] EAX: b7707000 EBX: f3afbeec ECX: b7707000 EDX: f4ba864c
[  741.565019] ESI: f4ba864c EDI: 00000000 EBP: f3afbeb8 ESP: c0834430
[  741.571362]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  741.576862] CR0: 8005003b CR2: f5c32dc0 CR3: 0082a000 CR4: 000006d0
[  741.583202] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  741.589545] DR6: ffff4ff0 DR7: 00000400
[  741.593463]  [<c0126c38>] kmemcheck_error_save_bug+0x58/0x90
[  741.599227]  [<c0127294>] kmemcheck_show+0x64/0x70
[  741.604203]  [<c01274fd>] kmemcheck_fault+0x6d/0xc0
[  741.609186]  [<c0122df0>] do_page_fault+0x270/0x440
[  741.614240]  [<c0462b63>] error_code+0x5f/0x64
[  741.618790]  [<c01adb17>] unmap_vmas+0xe7/0x290
[  741.623503]  [<c01b2a56>] exit_mmap+0xc6/0x180
[  741.628036]  [<c013a129>] mmput.part.45+0x19/0x90
[  741.632837]  [<c013a1c9>] mmput+0x29/0x30
[  741.637023]  [<c013de4a>] exit_mm+0xea/0x120
[  741.641382]  [<c013fef2>] do_exit+0x212/0x310
[  741.645836]  [<c0140133>] do_group_exit+0x33/0x90
[  741.650717]  [<c01401a3>] sys_exit_group+0x13/0x20
[  741.655604]  [<c0462e10>] sysenter_do_call+0x12/0x36
[  741.660744]  [<ffffffff>] 0xffffffff

The above error was the last one displayed in the console. The machine got frozen afterwards.

-- 
Regards,
WZab


