Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab1FKQPh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 12:15:37 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:37517 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1FKQPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 12:15:36 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4DF3949F.9070901@ise.pw.edu.pl>
Date: Sat, 11 Jun 2011 18:15:27 +0200
From: wzab <wzab@ise.pw.edu.pl>
Reply-To: wzab@ise.pw.edu.pl
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Icedove/3.1.10
MIME-Version: 1.0
To: wzab <wzab@ise.pw.edu.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: kmemcheck error and panic when booting 2.6.39.1 , however acpi=off
 allows to boot
References: <4DEA8FDD.1060905@elektron.elka.pw.edu.pl> <4DEAA677.2010404@elektron.elka.pw.edu.pl> <4DEAAB42.8070704@elektron.elka.pw.edu.pl> <4DEB4EF2.5050102@elektron.elka.pw.edu.pl> <4DEBE579.1070508@ise.pw.edu.pl> <4DF3885B.2080900@ise.pw.edu.pl>
In-Reply-To: <4DF3885B.2080900@ise.pw.edu.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 11.06.2011 17:23, wzab pisze:
>
> Only with "acpi=off" the system started completely, and I was able to 
> log in
> into gdm, and later switch it off in normal way (crash8.txt).
> With other parameters kernel panicked during the boot.
>
Of course I've mistaken.
The log from correct booting and shutdown is crash9.txt, not crash8.txt

However even in this run there is yet another kmemcheck error:

[  369.213324] ERROR: kmemcheck: Fatal error
[  369.217356]
[  369.218847] Pid: 1125, comm: udevd Tainted: G        W   2.6.39.1 
#3                  /D865GBF
[  369.229624] EIP: 0060:[<c0295950>] EFLAGS: 00010146 CPU: 0
[  369.235130] EIP is at strncpy+0x20/0x40
[  369.238983] EAX: eeff9a00 EBX: eeff9ae8 ECX: 00000005 EDX: eef79254
[  369.245257] ESI: eef7925a EDI: eeff9af3 EBP: eef7bcec ESP: c083528c
[  369.251533]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  369.256941] CR0: 8005003b CR2: f5cb98d8 CR3: 2eff3000 CR4: 000006d0
[  369.263217] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  369.269493] DR6: ffff4ff0 DR7: 00000400
[  369.273340]  [<c0128417>] kmemcheck_error_save_bug+0x57/0x90
[  369.279035]  [<c0128a34>] kmemcheck_show+0x64/0x70
[  369.283869]  [<c0128cad>] kmemcheck_fault+0x6d/0xc0
[  369.288776]  [<c0124480>] do_page_fault+0x270/0x440
[  369.293702]  [<c04663f3>] error_code+0x5f/0x64
[  369.298182]  [<c01c687a>] create_object+0xda/0x230
[  369.303001]  [<c04543a7>] kmemleak_alloc+0x27/0x50
[  369.307838]  [<c01c3b79>] kmem_cache_alloc+0xc9/0x110
[  369.312924]  [<c02a5ed8>] __debug_object_init+0x318/0x330
[  369.318378]  [<c02a5f07>] debug_object_init+0x17/0x20
[  369.323466]  [<c01567c2>] rcuhead_fixup_activate+0x82/0xa0
[  369.328987]  [<c02a6037>] debug_object_activate+0x107/0x120
[  369.334603]  [<c01883a9>] __call_rcu+0x19/0x140
[  369.339173]  [<c01884dd>] call_rcu+0xd/0x10
[  369.343401]  [<c01c52c4>] put_object+0x24/0x40
[  369.347875]  [<c01c554d>] delete_object_full+0x1d/0x30
[  369.353040]  [<c0454280>] kmemleak_free+0x20/0x50
[  369.357789]  [<c01c3457>] kmem_cache_free+0x97/0xc0
[  369.362694]  [<c01b959f>] anon_vma_chain_free+0xf/0x20
[  369.367877]  [<c01ba8b6>] unlink_anon_vmas+0x36/0xa0
[  369.372871]  [<c01b1414>] free_pgtables+0x64/0xc0
[  369.377620]  [<c01b7df5>] exit_mmap+0xf5/0x180
[  369.382093]  [<c013be6c>] mmput+0x4c/0xc0
[  369.386128]  [<c01cf346>] exec_mmap+0x126/0x360
[  369.390708]  [<c01cffd5>] flush_old_exec+0x55/0x90
[  369.395526]  [<c020888c>] load_elf_binary+0x20c/0x9f0
[  369.400621]  [<c01cecd1>] search_binary_handler+0xe1/0x2b0
[  369.406134]  [<c01d08c7>] do_execve+0x1d7/0x250
[  369.410710]  [<c010ab22>] sys_execve+0x32/0x70
[  369.415189]  [<c0466706>] ptregs_execve+0x12/0x18
[  369.419922]  [<ffffffff>] 0xffffffff
[  369.423556] WARNING: kmemcheck: Caught 32-bit read from uninitialized 
memory (eeff9a70)
[  369.431562] 
5c9affee649affee649affee349bffeeb076ffeec776ffee0101010101010101
[  369.439186]  i i i i i i i i i i i i i i i i u u u u u u u u u u u u 
u u u u
[  369.446832]                                  ^
[  369.451287]
[  369.452777] Pid: 1125, comm: udevd Tainted: G        W   2.6.39.1 
#3                  /D865GBF
[  369.463563] EIP: 0060:[<c028f6e9>] EFLAGS: 00010046 CPU: 0
[  369.469061] EIP is at prio_tree_insert+0xd9/0x190
[  369.473783] EAX: eeff7698 EBX: 00000000 ECX: eeff9a64 EDX: eeff9a64
[  369.480057] ESI: eeff76af EDI: c0d7b1fc EBP: eef7bcec ESP: c08353b0
[  369.486333]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  369.491743] CR0: 8005003b CR2: f5cb98d8 CR3: 2eff3000 CR4: 000006d0
[  369.498019] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  369.504295] DR6: ffff4ff0 DR7: 00000400
[  369.508141]  [<c01c68e0>] create_object+0x140/0x230
[  369.513046]  [<c04543a7>] kmemleak_alloc+0x27/0x50
[  369.517885]  [<c01c3b79>] kmem_cache_alloc+0xc9/0x110
[  369.522963]  [<c02a5ed8>] __debug_object_init+0x318/0x330
[  369.528408]  [<c02a5f07>] debug_object_init+0x17/0x20
[  369.533487]  [<c01567c2>] rcuhead_fixup_activate+0x82/0xa0
[  369.539000]  [<c02a6037>] debug_object_activate+0x107/0x120
[  369.544617]  [<c01883a9>] __call_rcu+0x19/0x140
[  369.549177]  [<c01884dd>] call_rcu+0xd/0x10
[  369.553408]  [<c01c52c4>] put_object+0x24/0x40
[  369.557879]  [<c01c554d>] delete_object_full+0x1d/0x30
[  369.563047]  [<c0454280>] kmemleak_free+0x20/0x50
[  369.567796]  [<c01c3457>] kmem_cache_free+0x97/0xc0
[  369.572709]  [<c01b959f>] anon_vma_chain_free+0xf/0x20
[  369.577893]  [<c01ba8b6>] unlink_anon_vmas+0x36/0xa0
[  369.582884]  [<c01b1414>] free_pgtables+0x64/0xc0
[  369.587633]  [<c01b7df5>] exit_mmap+0xf5/0x180
[  369.592104]  [<c013be6c>] mmput+0x4c/0xc0
[  369.596141]  [<c01cf346>] exec_mmap+0x126/0x360
[  369.600719]  [<c01cffd5>] flush_old_exec+0x55/0x90
[  369.605537]  [<c020888c>] load_elf_binary+0x20c/0x9f0
[  369.610634]  [<c01cecd1>] search_binary_handler+0xe1/0x2b0
[  369.616144]  [<c01d08c7>] do_execve+0x1d7/0x250
[  369.620720]  [<c010ab22>] sys_execve+0x32/0x70
[  369.625202]  [<c0466706>] ptregs_execve+0x12/0x18
[  369.629933]  [<ffffffff>] 0xffffffff
done.


