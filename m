Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319Ab2FAJbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:31:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51981 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758794Ab2FAJbD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:31:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120601034114.GA9248@localhost>
References: <20120601034114.GA9248@localhost>
Date: Fri, 1 Jun 2012 17:31:02 +0800
Message-ID: <CABawtvPsWFN+hpSDXpCdtWE+f8fHDkYDXJVBo50Zm=9uCTv3pA@mail.gmail.com>
Subject: Re: BUG in __key_instantiate_and_link(): unable to handle kernel
 paging request at 0000632e6472616f
From: ethan zhao <ethan.kernel@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following code of __key_instantiate_and_link() tried to request a
invalid function pointer ?

<ff> 50 18  callq  *0x18(%rax)
ret = key->type->instantiate(key, data, datalen);

So may be the key/type  is not initialized or freed. not found the
same code in 3.3. should be bug with 3.4 only.

Just FYI,
Ethan

On Fri, Jun 1, 2012 at 11:41 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Hi David,
>
> It's the second time the machine oops in __key_instantiate_and_link() on
> 3.4 kernel.  This bug only happens after several days of run. Do you
> have any advices or debug patches? For now I can try older (or newer)
> kernels and see if it's any better.
>
> Thanks,
> Fengguang
> ---
>
> [53056.100019] BUG: unable to handle kernel paging request at 0000632e6472616f
> [53056.108072] IP: [<0000632e6472616f>] 0x632e6472616e
> [53056.113702] PGD 0
> [53056.116119] Oops: 0010 [#1] SMP
> [53056.119982] CPU 0
> [53056.122111] Modules linked in:
> [53056.125969]
> [53056.127713] Pid: 3502, comm: rpc.idmapd Not tainted 3.4.0 #130 Intel Corporation S2600CP/S2600CP
> [53056.137880] RIP: 0010:[<0000632e6472616f>]  [<0000632e6472616f>] 0x632e6472616e
> [53056.146228] RSP: 0018:ffff880421d2fd30  EFLAGS: 00010246
> [53056.152249] RAX: ffff8803bef69100 RBX: ffff8803bef690d0 RCX: ffffffff81f0f440
> [53056.160309] RDX: 0000000000000005 RSI: ffff880421d2fe8d RDI: ffff8803bef690d0
> [53056.168371] RBP: ffff880421d2fd88 R08: ffff880421d2fcd8 R09: 0000000000000000
> [53056.176435] R10: ffffffff81f0f468 R11: ffffffff813bbdbf R12: ffff880421d2fe8d
> [53056.184504] R13: ffff8805c9957b00 R14: ffff8804287b9c00 R15: 0000000000000000
> [53056.192564] FS:  00007f87fbce5700(0000) GS:ffff88042fa00000(0000) knlGS:0000000000000000
> [53056.202451] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [53056.209343] CR2: 0000632e6472616f CR3: 000000042951a000 CR4: 00000000000407f0
> [53056.217784] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [53056.226226] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [53056.234675] Process rpc.idmapd (pid: 3502, threadinfo ffff880421d2e000, task ffff880427865e20)
> [53056.245144] Stack:
> [53056.247841]  ffffffff813bbde2 ffff880416c54820 0000000000000005 ffff880421d2fdb0
> [53056.257281]  fffffff0287b9c28 ffff8803bef690b0 ffff8803bef690d0 ffff8804287b9c00
> [53056.266725]  0000000000000005 ffff880421d2fe8d 00007f87fbaea800 ffff880421d2fdd8
> [53056.276172] Call Trace:
> [53056.279363]  [<ffffffff813bbde2>] ? __key_instantiate_and_link+0x5e/0xe4
> [53056.287316]  [<ffffffff813bbec5>] key_instantiate_and_link+0x5d/0x85
> [53056.294888]  [<ffffffff81262c29>] idmap_pipe_downcall+0x14a/0x18f
> [53056.302176]  [<ffffffff81958071>] rpc_pipe_write+0x5d/0x77
> [53056.308782]  [<ffffffff8114bfbd>] vfs_write+0xb2/0x142
> [53056.315000]  [<ffffffff8114c247>] sys_write+0x4a/0x71
> [53056.321108]  [<ffffffff819bc329>] system_call_fastpath+0x16/0x1b
> [53056.328278] Code:  Bad RIP value.
> [53056.332599] RIP  [<0000632e6472616f>] 0x632e6472616e
> [53056.338687]  RSP <ffff880421d2fd30>
> [53056.343035] CR2: 0000632e6472616f
> [53056.347640] ---[ end trace ee5d4100fdd3e1d2 ]---
>
>
> [293850.014215] general protection fault: 0000 [#1] SMP
> [293850.020521] CPU 0
> [293850.022749] Modules linked in:
> [293850.027564]
> [293850.029790] Pid: 3487, comm: rpc.idmapd Not tainted 3.4.0 #130 Intel Corporation S2600CP/S2600CP
> [293850.040833] RIP: 0010:[<ffffffff813bbddf>]  [<ffffffff813bbddf>] __key_instantiate_and_link+0x5b/0xe4
> [293850.052196] RSP: 0018:ffff880421d3bd38  EFLAGS: 00010246
> [293850.058696] RAX: ffff8803044aac10 RBX: ffff8803044aac00 RCX: ffffffff81f0f440
> [293850.067637] RDX: 0000000000000005 RSI: ffff880421d3be8d RDI: ffff8803044aac00
> [293850.076670] RBP: ffff880421d3bd88 R08: ffff880421d3bcd8 R09: 0000000000000000
> [293850.085601] R10: ffffffff81f0f468 R11: ffffffff813bbdbf R12: ffff880421d3be8d
> [293850.094538] R13: ffff88036cc14d00 R14: ffff88042816dc00 R15: 0000000000000000
> [293850.103477] FS:  00007f0954695700(0000) GS:ffff88042fa00000(0000) knlGS:0000000000000000
> [293850.113492] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [293850.120494] CR2: 00007f09546b8000 CR3: 0000000421d55000 CR4: 00000000000407f0
> [293850.129431] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [293850.138376] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [293850.147324] Process rpc.idmapd (pid: 3487, threadinfo ffff880421d3a000, task ffff880421cdbec0)
> [293850.157919] Stack:
> [293850.160740]  ffff880540d037a0 0000000000000005 ffff880421d3bdb0 fffffff02816dc28
> [293850.170396]  ffff8803044aacf0 ffff8803044aac00 ffff88042816dc00 0000000000000005
> [293850.179978]  ffff880421d3be8d 00007f095449a800 ffff880421d3bdd8 ffffffff813bbec5
> [293850.189571] Call Trace:
> [293850.192880]  [<ffffffff813bbec5>] key_instantiate_and_link+0x5d/0x85
> [293850.200559]  [<ffffffff81262c29>] idmap_pipe_downcall+0x14a/0x18f
> [293850.207951]  [<ffffffff81958071>] rpc_pipe_write+0x5d/0x77
> [293850.214668]  [<ffffffff8114bfbd>] vfs_write+0xb2/0x142
> [293850.221001]  [<ffffffff8114c247>] sys_write+0x4a/0x71
> [293850.227225]  [<ffffffff819bc329>] system_call_fastpath+0x16/0x1b
> [293850.234517] Code: 89 c5 4c 89 4d c0 e8 bc 70 5f 00 48 8b 83 c0 00 00 00 c7 45 cc f0 ff ff ff 48 8b 55 b8 a8 01 75 5f 48 8b 43 20 4c 89 e6 48 89 df <ff> 50 18 85 c0 89 45 cc 75 4b 48 8b 83 98 00 00 00 f0 ff 80 e0
> [293850.262891] RIP  [<ffffffff813bbddf>] __key_instantiate_and_link+0x5b/0xe4
> [293850.271249]  RSP <ffff880421d3bd38>
> [293850.276003] ---[ end trace 5e5f70d6ba42fdc4 ]---
>
> After the oops, lots of tasks get stuck:
>
> [302954.158127] SysRq : Show Blocked State
> [302954.164055]   task                        PC stack   pid father
> [302954.171284] rpc.idmapd      D 0000000000000000  3912  3487      1 0x00000000
> [302954.179917]  ffff880421d3b938 0000000000000046 ffff880421cdbec0 ffff880421d3bfd8
> [302954.189481]  ffff880421d3bfd8 0000000000012f00 ffff88080e400000 ffff880421cdbec0
> [302954.199053]  ffffffff8117fe4c 0000000000000000 ffff880421cdbec0 0000000000000000
> [302954.208615] Call Trace:
> [302954.211916]  [<ffffffff8117fe4c>] ? fsnotify_clear_marks_by_inode+0x31/0xd4
> [302954.220272]  [<ffffffff81958b73>] ? rpc_pipe_release+0x2d/0x155
> [302954.227456]  [<ffffffff819b4393>] schedule+0x64/0x66
> [302954.233567]  [<ffffffff819b4618>] schedule_preempt_disabled+0xe/0x10
> [302954.241236]  [<ffffffff819b3006>] mutex_lock_nested+0x18b/0x2c9
> [302954.248415]  [<ffffffff81958b73>] ? rpc_pipe_release+0x2d/0x155
> [302954.255595]  [<ffffffff81958b73>] rpc_pipe_release+0x2d/0x155
> [302954.262587]  [<ffffffff8114d7f1>] fput+0x10e/0x25b
> [302954.268506]  [<ffffffff8114a4b3>] filp_close+0x6e/0x7a
> [302954.274816]  [<ffffffff81067dac>] put_files_struct+0xb0/0x142
> [302954.281802]  [<ffffffff81067d23>] ? put_files_struct+0x27/0x142
> [302954.288980]  [<ffffffff81067ed9>] exit_files+0x49/0x51
> [302954.295286]  [<ffffffff81068431>] do_exit+0x27a/0x7e5
> [302954.301497]  [<ffffffff81066440>] ? kmsg_dump+0x116/0x126
> [302954.308091]  [<ffffffff810663c5>] ? kmsg_dump+0x9b/0x126
> [302954.314591]  [<ffffffff819b6655>] oops_end+0xbd/0xc6
> [302954.320704]  [<ffffffff81038de9>] die+0x5a/0x65
> [302954.326328]  [<ffffffff819b620f>] do_general_protection+0x138/0x140
> [302954.333897]  [<ffffffff819b5b15>] general_protection+0x25/0x30
> [302954.340983]  [<ffffffff813bbdbf>] ? __key_instantiate_and_link+0x3b/0xe4
> [302954.349040]  [<ffffffff813bbddf>] ? __key_instantiate_and_link+0x5b/0xe4
> [302954.357096]  [<ffffffff813bbde2>] ? __key_instantiate_and_link+0x5e/0xe4
> [302954.365151]  [<ffffffff813bbec5>] key_instantiate_and_link+0x5d/0x85
> [302954.382213]  [<ffffffff81262c29>] idmap_pipe_downcall+0x14a/0x18f
> [302954.389590]  [<ffffffff81958071>] rpc_pipe_write+0x5d/0x77
> [302954.396282]  [<ffffffff8114bfbd>] vfs_write+0xb2/0x142
> [302954.402585]  [<ffffffff8114c247>] sys_write+0x4a/0x71
> [302954.408787]  [<ffffffff819bc329>] system_call_fastpath+0x16/0x1b
> [302954.416067] zsh             D 0000000000000000  3728  4242   4239 0x00000000
> [302954.424689]  ffff8804296ab458 0000000000000046 ffff8804253a8000 ffff8804296abfd8
> [302954.434255]  ffff8804296abfd8 0000000000012f00 ffffffff81ea3020 ffff8804253a8000
> [302954.443819]  0000000100000000 ffff8804280b6900 0000000000000001 fffffffffffffff5
> [302954.453389] Call Trace:
> [302954.456688]  [<ffffffff813c06ae>] ? request_key_and_link+0x103/0x39b
> [302954.464354]  [<ffffffff813bc185>] ? key_user_lookup+0x3c/0x18c
> [302954.471439]  [<ffffffff819b4393>] schedule+0x64/0x66
> [302954.477548]  [<ffffffff819b4618>] schedule_preempt_disabled+0xe/0x10
> [302954.485215]  [<ffffffff819b3006>] mutex_lock_nested+0x18b/0x2c9
> [302954.492509]  [<ffffffff813c06ae>] ? request_key_and_link+0x103/0x39b
> [302954.500176]  [<ffffffff813c06ae>] request_key_and_link+0x103/0x39b
> [302954.507646]  [<ffffffff813c0a1a>] request_key+0x41/0x73
> [302954.514046]  [<ffffffff8126287d>] nfs_idmap_request_key+0xea/0x1bf
> [302954.521519]  [<ffffffff810983b7>] ? idle_balance+0x12c/0x157
> [302954.528410]  [<ffffffff8108e121>] ? finish_task_switch+0x4c/0xf6
> [302954.535686]  [<ffffffff81262a42>] nfs_idmap_lookup_id+0x4c/0xac
> [302954.542867]  [<ffffffff819b54c5>] ? _raw_spin_unlock_irq+0x2e/0x3a
> [302954.550337]  [<ffffffff81262c96>] ? nfs_map_string_to_numeric+0x28/0x76
> [302954.558292]  [<ffffffff8108e15d>] ? finish_task_switch+0x88/0xf6
> [302954.565568]  [<ffffffff8108e121>] ? finish_task_switch+0x4c/0xf6
> [302954.572836]  [<ffffffff8126325f>] nfs_map_name_to_uid+0x58/0x61
> [302954.580020]  [<ffffffff8125b17f>] decode_getfattr_attrs+0x51f/0x985
> [302954.587589]  [<ffffffff8125e5e7>] decode_getfattr_generic.constprop.60+0x8c/0xbe
> [302954.596800]  [<ffffffff8125ea93>] ? nfs4_xdr_dec_lookup+0x6e/0x6e
> [302954.604173]  [<ffffffff8125e62c>] decode_getfattr+0x13/0x15
> [302954.610966]  [<ffffffff8125ead6>] nfs4_xdr_dec_getattr+0x43/0x4c
> [302954.618244]  [<ffffffff8125ea93>] ? nfs4_xdr_dec_lookup+0x6e/0x6e
> [302954.625619]  [<ffffffff8194d701>] rpcauth_unwrap_resp+0x57/0x60
> [302954.632790]  [<ffffffff8194490f>] call_decode+0x34c/0x3a9
> [302954.639388]  [<ffffffff81084d42>] ? autoremove_wake_function+0x3d/0x3d
> [302954.647246]  [<ffffffff819445c3>] ? call_transmit_status+0x8f/0x8f
> [302954.654714]  [<ffffffff8194c78c>] __rpc_execute+0x9b/0x204
> [302954.661407]  [<ffffffff81084a68>] ? wake_up_bit+0x25/0x2a
> [302954.668001]  [<ffffffff8194c98a>] rpc_execute+0x67/0x70
> [302954.674402]  [<ffffffff81945e6c>] rpc_run_task+0x7e/0x86
> [302954.680899]  [<ffffffff81945f61>] rpc_call_sync+0x45/0x66
> [302954.687501]  [<ffffffff81253e96>] _nfs4_call_sync+0x13/0x15
> [302954.694292]  [<ffffffff81254c29>] _nfs4_proc_getattr+0x9f/0xad
> [302954.701375]  [<ffffffff81257e9f>] nfs4_proc_getattr+0x36/0x55
> [302954.708350]  [<ffffffff81244cc0>] __nfs_revalidate_inode+0x8b/0xef
> [302954.715817]  [<ffffffff81244e26>] nfs_revalidate_inode+0x4a/0x51
> [302954.723095]  [<ffffffff81240999>] nfs_check_verifier+0x51/0x77
> [302954.730175]  [<ffffffff81240ab1>] nfs_lookup_revalidate+0xf2/0x32c
> [302954.737643]  [<ffffffff8124220f>] nfs_open_revalidate+0x225/0x238
> [302954.745019]  [<ffffffff81155c8f>] ? inode_permission+0x78/0xd5
> [302954.752101]  [<ffffffff81156ecb>] ? link_path_walk+0x7e/0x74a
> [302954.759089]  [<ffffffff81155171>] complete_walk+0xfa/0x124
> [302954.765781]  [<ffffffff81157bb2>] path_lookupat+0x55e/0x5d4
> [302954.772574]  [<ffffffff8113f9cc>] ? kmem_cache_alloc+0x39/0x124
> [302954.779754]  [<ffffffff81157c50>] do_path_lookup+0x28/0xa3
> [302954.786447]  [<ffffffff811590c7>] user_path_at_empty+0x53/0x92
> [302954.793530]  [<ffffffff810889ea>] ? up_read+0x20/0x37
> [302954.799736]  [<ffffffff819b8be0>] ? do_page_fault+0x3d3/0x42a
> [302954.806719]  [<ffffffff81159117>] user_path_at+0x11/0x13
> [302954.813216]  [<ffffffff811500e7>] vfs_fstatat+0x3a/0x64
> [302954.819613]  [<ffffffff8115014c>] vfs_stat+0x1b/0x1d
> [302954.825722]  [<ffffffff8115024b>] sys_newstat+0x1a/0x33
> [302954.832127]  [<ffffffff813fdffe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [302954.839893]  [<ffffffff819bc329>] system_call_fastpath+0x16/0x1b
> [302954.847176] kworker/11:5    D 000000000000000b  4528 61345      2 0x00000000
> [302954.855802]  ffff880679387c00 0000000000000046 ffff8807eb0a5e20 ffff880679387fd8
> [302954.865365]  ffff880679387fd8 0000000000012f00 ffff880429b71f60 ffff8807eb0a5e20
> [302954.874904]  0000000000000000 0000000000000000 ffff8807eb0a5e20 0000000000000000
> [302954.884461] Call Trace:
> [302954.887751]  [<ffffffff819b4dd1>] ? rwsem_down_failed_common+0x41/0x103
> [302954.895707]  [<ffffffff819b4393>] schedule+0x64/0x66
> [302954.901816]  [<ffffffff819b4e63>] rwsem_down_failed_common+0xd3/0x103
> [302954.909579]  [<ffffffff819b4ea6>] rwsem_down_write_failed+0x13/0x15
> [302954.917146]  [<ffffffff813fdf63>] call_rwsem_down_write_failed+0x13/0x20
> [302954.925201]  [<ffffffff813bda11>] ? keyring_gc+0x28/0x1b3
> [302954.931794]  [<ffffffff819b3515>] ? down_write+0x52/0x59
> [302954.938296]  [<ffffffff813bda11>] ? keyring_gc+0x28/0x1b3
> [302954.944892]  [<ffffffff813bb9a4>] ? key_garbage_collector+0x2a0/0x3b1
> [302954.952656]  [<ffffffff813bda11>] keyring_gc+0x28/0x1b3
> [302954.959061]  [<ffffffff813bba49>] key_garbage_collector+0x345/0x3b1
> [302954.966628]  [<ffffffff813bb9a4>] ? key_garbage_collector+0x2a0/0x3b1
> [302954.974392]  [<ffffffff8107ce74>] process_one_work+0x220/0x3e5
> [302954.981474]  [<ffffffff8107cde5>] ? process_one_work+0x191/0x3e5
> [302954.988743]  [<ffffffff813bb704>] ? key_schedule_gc+0x83/0x83
> [302954.995719]  [<ffffffff8107d4bf>] worker_thread+0x15a/0x21b
> [302955.002512]  [<ffffffff8107d365>] ? manage_workers.isra.22+0x170/0x170
> [302955.010372]  [<ffffffff810845d5>] kthread+0x8b/0x93
> [302955.016387]  [<ffffffff819bd774>] kernel_thread_helper+0x4/0x10
> [302955.023564]  [<ffffffff819b5930>] ? retint_restore_args+0x13/0x13
> [302955.030929]  [<ffffffff8108454a>] ? __init_kthread_worker+0x5a/0x5a
> [302955.038495]  [<ffffffff819bd770>] ? gs_change+0x13/0x13
> [302955.044936] make            D 000000000000000e  3800 46865  40708 0x00000000
> [302955.053556]  ffff88048f489518 0000000000000046 ffff880678129f60 ffff88048f489fd8
> [302955.063125]  ffff88048f489fd8 0000000000012f00 ffff880475701f60 ffff880678129f60
> [302955.072700]  0000000000000286 0000000000000000 0000000000000000 0000000000000000
> [302955.082254] Call Trace:
> [302955.085548]  [<ffffffff81084b9d>] ? prepare_to_wait+0x25/0x79
> [302955.092535]  [<ffffffff813c00d1>] ? wait_for_key_construction+0x6d/0x6d
> [302955.100495]  [<ffffffff819b4393>] schedule+0x64/0x66
> [302955.106599]  [<ffffffff813c00df>] key_wait_bit+0xe/0x12
> [302955.113004]  [<ffffffff819b2201>] __wait_on_bit+0x48/0x7b
> [302955.119603]  [<ffffffff819b22a6>] out_of_line_wait_on_bit+0x72/0x7d
> [302955.127169]  [<ffffffff813c00d1>] ? wait_for_key_construction+0x6d/0x6d
> [302955.135126]  [<ffffffff81084d42>] ? autoremove_wake_function+0x3d/0x3d
> [302955.142988]  [<ffffffff813c00ae>] wait_for_key_construction+0x4a/0x6d
> [302955.150761]  [<ffffffff813c09bc>] request_key_with_auxdata+0x35/0x52
> [302955.158429]  [<ffffffff81262865>] nfs_idmap_request_key+0xd2/0x1bf
> [302955.165903]  [<ffffffff814014be>] ? _kstrtoull+0x2c/0x66
> [302955.172401]  [<ffffffff8140150c>] ? kstrtoull+0x14/0x16
> [302955.178803]  [<ffffffff81262a6d>] nfs_idmap_lookup_id+0x77/0xac
> [302955.185985]  [<ffffffff819b54c5>] ? _raw_spin_unlock_irq+0x2e/0x3a
> [302955.193455]  [<ffffffff81262c96>] ? nfs_map_string_to_numeric+0x28/0x76
> [302955.201416]  [<ffffffff8108e121>] ? finish_task_switch+0x4c/0xf6
> [302955.208827]  [<ffffffff812632c0>] nfs_map_group_to_gid+0x58/0x60
> [302955.216106]  [<ffffffff8125b246>] decode_getfattr_attrs+0x5e6/0x985
> [302955.223665]  [<ffffffff8125e5e7>] decode_getfattr_generic.constprop.60+0x8c/0xbe
> [302955.232886]  [<ffffffff8125ea93>] ? nfs4_xdr_dec_lookup+0x6e/0x6e
> [302955.240263]  [<ffffffff8125e62c>] decode_getfattr+0x13/0x15
> [302955.247053]  [<ffffffff8125ead6>] nfs4_xdr_dec_getattr+0x43/0x4c
> [302955.254327]  [<ffffffff8125ea93>] ? nfs4_xdr_dec_lookup+0x6e/0x6e
> [302955.261698]  [<ffffffff8194d701>] rpcauth_unwrap_resp+0x57/0x60
> [302955.268880]  [<ffffffff8194490f>] call_decode+0x34c/0x3a9
> [302955.275476]  [<ffffffff81084d42>] ? autoremove_wake_function+0x3d/0x3d
> [302955.283336]  [<ffffffff819445c3>] ? call_transmit_status+0x8f/0x8f
> [302955.290803]  [<ffffffff8194c78c>] __rpc_execute+0x9b/0x204
> [302955.297496]  [<ffffffff81084a68>] ? wake_up_bit+0x25/0x2a
> [302955.304091]  [<ffffffff8194c98a>] rpc_execute+0x67/0x70
> [302955.310494]  [<ffffffff81945e6c>] rpc_run_task+0x7e/0x86
> [302955.316993]  [<ffffffff81945f61>] rpc_call_sync+0x45/0x66
> [302955.323589]  [<ffffffff81253e96>] _nfs4_call_sync+0x13/0x15
> [302955.330378]  [<ffffffff81254c29>] _nfs4_proc_getattr+0x9f/0xad
> [302955.337460]  [<ffffffff81257e9f>] nfs4_proc_getattr+0x36/0x55
> [302955.344445]  [<ffffffff81244cc0>] __nfs_revalidate_inode+0x8b/0xef
> [302955.351916]  [<ffffffff81240b1a>] nfs_lookup_revalidate+0x15b/0x32c
> [302955.359486]  [<ffffffff8124220f>] nfs_open_revalidate+0x225/0x238
> [302955.366867]  [<ffffffff8115f764>] ? __d_lookup+0x177/0x189
> [302955.373555]  [<ffffffff8115f5ed>] ? __d_lookup_rcu+0x160/0x160
> [302955.380639]  [<ffffffff81156d5d>] do_lookup+0x1b5/0x2a5
> [302955.387042]  [<ffffffff81156ecb>] ? link_path_walk+0x7e/0x74a
> [302955.394026]  [<ffffffff81158041>] do_last+0x14b/0x773
> [302955.400232]  [<ffffffff81158dd3>] path_openat+0xd0/0x351
> [302955.406728]  [<ffffffff81159151>] do_filp_open+0x38/0x86
> [302955.413229]  [<ffffffff819b5493>] ? _raw_spin_unlock+0x28/0x2c
> [302955.420302]  [<ffffffff81163666>] ? alloc_fd+0xec/0xfe
> [302955.426606]  [<ffffffff8114b5b1>] do_sys_open+0x105/0x197
> [302955.433197]  [<ffffffff81163eab>] ? vfsmount_lock_local_lock_cpu+0x66/0x66
> [302955.441442]  [<ffffffff8114b664>] sys_open+0x21/0x23
> [302955.447555]  [<ffffffff819bc329>] system_call_fastpath+0x16/0x1b
> [302955.454824] make            D 0000000000000009  3856 47064  40708 0x00000000
> [302955.463444]  ffff88080bb87518 0000000000000046 ffff880672393ec0 ffff88080bb87fd8
> [302955.473003]  ffff88080bb87fd8 0000000000012f00 ffff88048f663ec0 ffff880672393ec0
> [302955.482558]  0000000000000286 0000000000000000 0000000000000000 0000000000000000
> [302955.492119] Call Trace:
> [302955.495410]  [<ffffffff81084b9d>] ? prepare_to_wait+0x25/0x79
> [302955.502392]  [<ffffffff813c00d1>] ? wait_for_key_construction+0x6d/0x6d
> [302955.510353]  [<ffffffff819b4393>] schedule+0x64/0x66
> [302955.516464]  [<ffffffff813c00df>] key_wait_bit+0xe/0x12
> [302955.522867]  [<ffffffff819b2201>] __wait_on_bit+0x48/0x7b
> [302955.529464]  [<ffffffff8184f881>] ? release_sock+0x15e/0x17d
> [302955.536352]  [<ffffffff819b22a6>] out_of_line_wait_on_bit+0x72/0x7d
> [302955.543920]  [<ffffffff813c00d1>] ? wait_for_key_construction+0x6d/0x6d
> [302955.551874]  [<ffffffff81084d42>] ? autoremove_wake_function+0x3d/0x3d
> [302955.559734]  [<ffffffff813c00ae>] wait_for_key_construction+0x4a/0x6d
> [302955.567496]  [<ffffffff813c09bc>] request_key_with_auxdata+0x35/0x52
> [302955.575162]  [<ffffffff81262865>] nfs_idmap_request_key+0xd2/0x1bf
> [302955.592031]  [<ffffffff814014be>] ? _kstrtoull+0x2c/0x66
> [302955.598530]  [<ffffffff8140150c>] ? kstrtoull+0x14/0x16
> [302955.604932]  [<ffffffff81262a6d>] nfs_idmap_lookup_id+0x77/0xac
> [302955.612102]  [<ffffffff819b54c5>] ? _raw_spin_unlock_irq+0x2e/0x3a
> [302955.619574]  [<ffffffff81262c96>] ? nfs_map_string_to_numeric+0x28/0x76
> [302955.627530]  [<ffffffff8108e121>] ? finish_task_switch+0x4c/0xf6
> [302955.634808]  [<ffffffff812632c0>] nfs_map_group_to_gid+0x58/0x60
> [302955.642085]  [<ffffffff8125b246>] decode_getfattr_attrs+0x5e6/0x985
> [302955.649653]  [<ffffffff8125e5e7>] decode_getfattr_generic.constprop.60+0x8c/0xbe
> [302955.658862]  [<ffffffff8125ea93>] ? nfs4_xdr_dec_lookup+0x6e/0x6e
> [302955.666231]  [<ffffffff8125e62c>] decode_getfattr+0x13/0x15
> [302955.673020]  [<ffffffff8125ead6>] nfs4_xdr_dec_getattr+0x43/0x4c
> [302955.680295]  [<ffffffff8125ea93>] ? nfs4_xdr_dec_lookup+0x6e/0x6e
> [302955.687667]  [<ffffffff8194d701>] rpcauth_unwrap_resp+0x57/0x60
> [302955.694843]  [<ffffffff8194490f>] call_decode+0x34c/0x3a9
> [302955.701436]  [<ffffffff81084d42>] ? autoremove_wake_function+0x3d/0x3d
> [302955.709302]  [<ffffffff819445c3>] ? call_transmit_status+0x8f/0x8f
> [302955.716773]  [<ffffffff8194c78c>] __rpc_execute+0x9b/0x204
> [302955.723464]  [<ffffffff81084a68>] ? wake_up_bit+0x25/0x2a
> [302955.730058]  [<ffffffff8194c98a>] rpc_execute+0x67/0x70
> [302955.736455]  [<ffffffff81945e6c>] rpc_run_task+0x7e/0x86
> [302955.742953]  [<ffffffff81945f61>] rpc_call_sync+0x45/0x66
> [302955.749546]  [<ffffffff81253e96>] _nfs4_call_sync+0x13/0x15
> [302955.756336]  [<ffffffff81254c29>] _nfs4_proc_getattr+0x9f/0xad
> [302955.763419]  [<ffffffff81257e9f>] nfs4_proc_getattr+0x36/0x55
> [302955.770402]  [<ffffffff81244cc0>] __nfs_revalidate_inode+0x8b/0xef
> [302955.777872]  [<ffffffff81240b1a>] nfs_lookup_revalidate+0x15b/0x32c
> [302955.785438]  [<ffffffff8124220f>] nfs_open_revalidate+0x225/0x238
> [302955.792811]  [<ffffffff8115f764>] ? __d_lookup+0x177/0x189
> [302955.799499]  [<ffffffff8115f5ed>] ? __d_lookup_rcu+0x160/0x160
> [302955.806582]  [<ffffffff81156d5d>] do_lookup+0x1b5/0x2a5
> [302955.812983]  [<ffffffff81156ecb>] ? link_path_walk+0x7e/0x74a
> [302955.819966]  [<ffffffff81158041>] do_last+0x14b/0x773
> [302955.826172]  [<ffffffff81158dd3>] path_openat+0xd0/0x351
> [302955.832670]  [<ffffffff81159151>] do_filp_open+0x38/0x86
> [302955.839168]  [<ffffffff819b5493>] ? _raw_spin_unlock+0x28/0x2c
> [302955.846250]  [<ffffffff81163666>] ? alloc_fd+0xec/0xfe
> [302955.852555]  [<ffffffff8114b5b1>] do_sys_open+0x105/0x197
> [302955.859155]  [<ffffffff81163eab>] ? vfsmount_lock_local_lock_cpu+0x66/0x66
> [302955.867403]  [<ffffffff8114b664>] sys_open+0x21/0x23
> [302955.873514]  [<ffffffff819bc329>] system_call_fastpath+0x16/0x1b
> [302955.880791] make            D 000000000000000c  3856 47169  42128 0x00000000
> [302955.889411]  ffff880824bbd518 0000000000000046 ffff880672389f60 ffff880824bbdfd8
> [302955.898968]  ffff880824bbdfd8 0000000000012f00 ffff88048ffbde20 ffff880672389f60
> [302955.908525]  0000000000000286 0000000000000000 0000000000000000 0000000000000000
> [302955.918078] Call Trace:
> [302955.921368]  [<ffffffff81084b9d>] ? prepare_to_wait+0x25/0x79
> [302955.928354]  [<ffffffff813c00d1>] ? wait_for_key_construction+0x6d/0x6d
> [302955.936311]  [<ffffffff819b4393>] schedule+0x64/0x66
> [302955.942420]  [<ffffffff813c00df>] key_wait_bit+0xe/0x12
> [302955.948821]  [<ffffffff819b2201>] __wait_on_bit+0x48/0x7b
> [302955.955416]  [<ffffffff8184f881>] ? release_sock+0x15e/0x17d
> [302955.962303]  [<ffffffff819b22a6>] out_of_line_wait_on_bit+0x72/0x7d
> [302955.969868]  [<ffffffff813c00d1>] ? wait_for_key_construction+0x6d/0x6d
> [302955.977824]  [<ffffffff81084d42>] ? autoremove_wake_function+0x3d/0x3d
> [302955.985680]  [<ffffffff813c00ae>] wait_for_key_construction+0x4a/0x6d
> [302955.993432]  [<ffffffff813c09bc>] request_key_with_auxdata+0x35/0x52
> [302956.001099]  [<ffffffff81262865>] nfs_idmap_request_key+0xd2/0x1bf
> [302956.008571]  [<ffffffff814014be>] ? _kstrtoull+0x2c/0x66
> [302956.015066]  [<ffffffff8140150c>] ? kstrtoull+0x14/0x16
> [302956.021468]  [<ffffffff81262a6d>] nfs_idmap_lookup_id+0x77/0xac
> [302956.028648]  [<ffffffff819b54c5>] ? _raw_spin_unlock_irq+0x2e/0x3a
> [302956.036117]  [<ffffffff81262c96>] ? nfs_map_string_to_numeric+0x28/0x76
> [302956.044074]  [<ffffffff8108e121>] ? finish_task_switch+0x4c/0xf6
> [302956.051349]  [<ffffffff812632c0>] nfs_map_group_to_gid+0x58/0x60
> [302956.058636]  [<ffffffff8125b246>] decode_getfattr_attrs+0x5e6/0x985
> [302956.066202]  [<ffffffff8125e5e7>] decode_getfattr_generic.constprop.60+0x8c/0xbe
> [302956.075420]  [<ffffffff8125ea93>] ? nfs4_xdr_dec_lookup+0x6e/0x6e
> [302956.082794]  [<ffffffff8125e62c>] decode_getfattr+0x13/0x15
> [302956.089586]  [<ffffffff8125ead6>] nfs4_xdr_dec_getattr+0x43/0x4c
> [302956.096864]  [<ffffffff8125ea93>] ? nfs4_xdr_dec_lookup+0x6e/0x6e
> [302956.104237]  [<ffffffff8194d701>] rpcauth_unwrap_resp+0x57/0x60
> [302956.111421]  [<ffffffff8194490f>] call_decode+0x34c/0x3a9
> [302956.118020]  [<ffffffff81084d42>] ? autoremove_wake_function+0x3d/0x3d
> [302956.125877]  [<ffffffff819445c3>] ? call_transmit_status+0x8f/0x8f
> [302956.133346]  [<ffffffff8194c78c>] __rpc_execute+0x9b/0x204
> [302956.140032]  [<ffffffff81084a68>] ? wake_up_bit+0x25/0x2a
> [302956.146629]  [<ffffffff8194c98a>] rpc_execute+0x67/0x70
> [302956.153029]  [<ffffffff81945e6c>] rpc_run_task+0x7e/0x86
> [302956.159527]  [<ffffffff81945f61>] rpc_call_sync+0x45/0x66
> [302956.166121]  [<ffffffff81253e96>] _nfs4_call_sync+0x13/0x15
> [302956.172902]  [<ffffffff81254c29>] _nfs4_proc_getattr+0x9f/0xad
> [302956.179985]  [<ffffffff81257e9f>] nfs4_proc_getattr+0x36/0x55
> [302956.186969]  [<ffffffff81244cc0>] __nfs_revalidate_inode+0x8b/0xef
> [302956.194439]  [<ffffffff81240b1a>] nfs_lookup_revalidate+0x15b/0x32c
> [302956.202007]  [<ffffffff8124220f>] nfs_open_revalidate+0x225/0x238
> [302956.209382]  [<ffffffff8115f764>] ? __d_lookup+0x177/0x189
> [302956.216074]  [<ffffffff8115f5ed>] ? __d_lookup_rcu+0x160/0x160
> [302956.223157]  [<ffffffff81156d5d>] do_lookup+0x1b5/0x2a5
> [302956.229562]  [<ffffffff81156ecb>] ? link_path_walk+0x7e/0x74a
> [302956.236550]  [<ffffffff81158041>] do_last+0x14b/0x773
> [302956.242756]  [<ffffffff81158dd3>] path_openat+0xd0/0x351
> [302956.249255]  [<ffffffff81159151>] do_filp_open+0x38/0x86
> [302956.255753]  [<ffffffff819b5493>] ? _raw_spin_unlock+0x28/0x2c
> [302956.262835]  [<ffffffff81163666>] ? alloc_fd+0xec/0xfe
> [302956.269137]  [<ffffffff8114b5b1>] do_sys_open+0x105/0x197
> [302956.275726]  [<ffffffff81163eab>] ? vfsmount_lock_local_lock_cpu+0x66/0x66
> [302956.283979]  [<ffffffff8114b664>] sys_open+0x21/0x23
> [302956.290089]  [<ffffffff819bc329>] system_call_fastpath+0x16/0x1b
>
