Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab0HQFRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 01:17:43 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63386 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab0HQFRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 01:17:40 -0400
Message-Id: <201008170517.o7H5HbCT002910@www262.sakura.ne.jp>
Subject: [2.6.36-rc1] List corruption when using initrd.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 17 Aug 2010 14:17:37 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 16082010 #3878497, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I get list_add corruption message when booting with initrd on Debian Sarge.
Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.36-rc1-2 .

[    7.140845] VFS: Mounted root (cramfs filesystem) readonly on device 1:0.
[    7.192635] mount used greatest stack depth: 2004 bytes left
[    7.212497] linuxrc used greatest stack depth: 1572 bytes left
[    7.214451] debug: unmapping init memory c158d000..c1751000
[    7.218958] Write protecting the kernel text: 3648k
[    7.220230] Write protecting the kernel read-only data: 1700k
[    7.222770] ------------[ cut here ]------------
[    7.223823] WARNING: at fs/inode.c:692 unlock_new_inode+0x78/0xc0()
[    7.225249] Hardware name: VMware Virtual Platform
[    7.228818] Modules linked in:
[    7.229668] Pid: 1, comm: swapper Not tainted 2.6.36-rc1 #1
[    7.230963] Call Trace:
[    7.231535]  [<c103dbe8>] ? printk+0x18/0x20
[    7.232478]  [<c10d8778>] ? unlock_new_inode+0x78/0xc0
[    7.233668]  [<c103d18c>] warn_slowpath_common+0x7c/0xa0
[    7.234882]  [<c10d8778>] ? unlock_new_inode+0x78/0xc0
[    7.237936]  [<c103d24d>] warn_slowpath_null+0x1d/0x40
[    7.239257]  [<c10d8778>] unlock_new_inode+0x78/0xc0
[    7.240411]  [<c10d8d5e>] ? iget_locked+0x2e/0x50
[    7.241590]  [<c113c219>] get_cramfs_inode+0x49/0x80
[    7.242731]  [<c113cad6>] cramfs_lookup+0x196/0x1c0
[    7.245605]  [<c10d6736>] ? d_lookup+0x26/0x50
[    7.246633]  [<c10cd017>] do_lookup+0x137/0x1b0
[    7.247717]  [<c10ce887>] do_last+0x67/0x450
[    7.248695]  [<c10cee5d>] do_filp_open+0x1ed/0x500
[    7.249804]  [<c10acc55>] ? __get_user_pages+0xe5/0x2d0
[    7.250996]  [<c10ace92>] ? get_user_pages+0x52/0x60
[    7.252087]  [<c11d39ac>] ? _copy_from_user+0x3c/0x70
[    7.253266]  [<c10c8818>] ? put_arg_page+0x8/0x10
[    7.256494]  [<c10c8be4>] ? copy_strings+0x194/0x1b0
[    7.257644]  [<c10c8f90>] open_exec+0x30/0xe0
[    7.258665]  [<c10fcce2>] load_script+0x1c2/0x220
[    7.259757]  [<c106a000>] ? trace_hardirqs_off_caller+0xf0/0x110
[    7.261126]  [<c105c8eb>] ? local_clock+0x3b/0x60
[    7.262261]  [<c1066c23>] ? lock_release_holdtime+0x73/0xb0
[    7.265183]  [<c10c9f16>] ? search_binary_handler+0xa6/0x260
[    7.266484]  [<c106c4b7>] ? __lock_release+0x47/0x70
[    7.267607]  [<c10c9f16>] ? search_binary_handler+0xa6/0x260
[    7.268887]  [<c10fcb20>] ? load_script+0x0/0x220
[    7.270005]  [<c10fcb20>] ? load_script+0x0/0x220
[    7.271092]  [<c10c9f1d>] search_binary_handler+0xad/0x260
[    7.272329]  [<c10ca23a>] do_execve+0x16a/0x230
[    7.273397]  [<c10cc858>] ? getname+0x38/0x80
[    7.274410]  [<c100a2c2>] sys_execve+0x42/0x60
[    7.277201]  [<c1002d43>] ptregs_execve+0x13/0x18
[    7.278284]  [<c138e0e1>] ? syscall_call+0x7/0xb
[    7.279342]  [<c100742f>] ? kernel_execve+0x1f/0x30
[    7.280368]  [<c158db70>] ? kernel_init+0x0/0xe0
[    7.281449]  [<c10012c7>] ? run_init_process+0x17/0x20
[    7.282658]  [<c100131c>] ? init_post+0x4c/0xb0
[    7.285440]  [<c158dc25>] ? kernel_init+0xb5/0xe0
[    7.286524]  [<c10031fa>] ? kernel_thread_helper+0x6/0x1c
[    7.287778] ---[ end trace 13753716ad16dd15 ]---
[    7.289098] ------------[ cut here ]------------
[    7.290163] WARNING: at fs/inode.c:692 unlock_new_inode+0x78/0xc0()
[    7.291538] Hardware name: VMware Virtual Platform
[    7.292631] Modules linked in:
[    7.295550] Pid: 1, comm: swapper Tainted: G        W   2.6.36-rc1 #1
[    7.296994] Call Trace:
[    7.297632]  [<c103dbe8>] ? printk+0x18/0x20
[    7.298620]  [<c10d8778>] ? unlock_new_inode+0x78/0xc0
[    7.299777]  [<c103d18c>] warn_slowpath_common+0x7c/0xa0
[    7.300984]  [<c10d8778>] ? unlock_new_inode+0x78/0xc0
[    7.302191]  [<c103d24d>] warn_slowpath_null+0x1d/0x40
[    7.305155]  [<c10d8778>] unlock_new_inode+0x78/0xc0
[    7.306324]  [<c10d8d5e>] ? iget_locked+0x2e/0x50
[    7.307424]  [<c113c219>] get_cramfs_inode+0x49/0x80
[    7.308563]  [<c113cad6>] cramfs_lookup+0x196/0x1c0
[    7.309707]  [<c10d6736>] ? d_lookup+0x26/0x50
[    7.310741]  [<c10cd017>] do_lookup+0x137/0x1b0
[    7.311756]  [<c10ce887>] do_last+0x67/0x450
[    7.312743]  [<c10d0a69>] ? page_getlink+0x49/0x70
[    7.316035]  [<c10ceff5>] do_filp_open+0x385/0x500
[    7.317157]  [<c11d39ac>] ? _copy_from_user+0x3c/0x70
[    7.318340]  [<c10c8818>] ? put_arg_page+0x8/0x10
[    7.319408]  [<c10c8be4>] ? copy_strings+0x194/0x1b0
[    7.320541]  [<c10c8f90>] open_exec+0x30/0xe0
[    7.321572]  [<c10fcce2>] load_script+0x1c2/0x220
[    7.322653]  [<c106a000>] ? trace_hardirqs_off_caller+0xf0/0x110
[    7.325736]  [<c105c8eb>] ? local_clock+0x3b/0x60
[    7.326836]  [<c1066c23>] ? lock_release_holdtime+0x73/0xb0
[    7.328073]  [<c10c9f16>] ? search_binary_handler+0xa6/0x260
[    7.329388]  [<c106c4b7>] ? __lock_release+0x47/0x70
[    7.330531]  [<c10c9f16>] ? search_binary_handler+0xa6/0x260
[    7.331766]  [<c10fcb20>] ? load_script+0x0/0x220
[    7.332846]  [<c10fcb20>] ? load_script+0x0/0x220
[    7.336067]  [<c10c9f1d>] search_binary_handler+0xad/0x260
[    7.337338]  [<c10ca23a>] do_execve+0x16a/0x230
[    7.338402]  [<c10cc858>] ? getname+0x38/0x80
[    7.339409]  [<c100a2c2>] sys_execve+0x42/0x60
[    7.340424]  [<c1002d43>] ptregs_execve+0x13/0x18
[    7.341511]  [<c138e0e1>] ? syscall_call+0x7/0xb
[    7.342575]  [<c100742f>] ? kernel_execve+0x1f/0x30
[    7.345450]  [<c158db70>] ? kernel_init+0x0/0xe0
[    7.346530]  [<c10012c7>] ? run_init_process+0x17/0x20
[    7.347699]  [<c100131c>] ? init_post+0x4c/0xb0
[    7.348747]  [<c158dc25>] ? kernel_init+0xb5/0xe0
[    7.349914]  [<c10031fa>] ? kernel_thread_helper+0x6/0x1c
[    7.351128] ---[ end trace 13753716ad16dd16 ]---
[    7.420484] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    7.422533] pcnet32 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    7.424829] pcnet32: PCnet/PCI II 79C970A at 0x2000, 00:0c:29:9e:eb:32 assigned IRQ 18
[    7.430623] pcnet32: eth0: registered as PCnet/PCI II 79C970A
[    7.435459] pcnet32: 1 cards_found
[    7.484267] ------------[ cut here ]------------
[    7.485302] WARNING: at lib/list_debug.c:26 __list_add+0x8f/0xa0()
[    7.486758] Hardware name: VMware Virtual Platform
[    7.487865] list_add corruption. next->prev should be prev (c156b180), but was c1d67d08. (next=ded86fa0).
[    7.492595] Modules linked in: pcnet32
[    7.493633] Pid: 1146, comm: mount Tainted: G        W   2.6.36-rc1 #1
[    7.495188] Call Trace:
[    7.495835]  [<c11e1c00>] ? __list_add+0x20/0xa0
[    7.496873]  [<c11e1c6f>] ? __list_add+0x8f/0xa0
[    7.497940]  [<c103d18c>] warn_slowpath_common+0x7c/0xa0
[    7.499579]  [<c11e1c6f>] ? __list_add+0x8f/0xa0
[    7.500652]  [<c103d1e1>] warn_slowpath_fmt+0x31/0x40
[    7.501809]  [<c11e1c6f>] __list_add+0x8f/0xa0
[    7.502929]  [<c11e5425>] __percpu_counter_init+0x75/0x90
[    7.504187]  [<c10a7742>] shmem_fill_super+0xb2/0x170
[    7.505233]  [<c10c6135>] ? sget+0x165/0x1f0
[    7.506620]  [<c10c67e0>] ? set_anon_super+0x0/0xe0
[    7.507768]  [<c10c6c50>] get_sb_nodev+0x50/0x80
[    7.508805]  [<c10a78cf>] shmem_get_sb+0x1f/0x30
[    7.509863]  [<c10a7690>] ? shmem_fill_super+0x0/0x170
[    7.511087]  [<c10c6da1>] vfs_kern_mount+0x71/0x190
[    7.512158]  [<c10daef0>] ? get_fs_type+0x30/0xa0
[    7.513175]  [<c10c70e7>] do_kern_mount+0x37/0x90
[    7.514614]  [<c10dd087>] do_new_mount+0x57/0xa0
[    7.515712]  [<c10dd691>] do_mount+0x171/0x1b0
[    7.516699]  [<c10dd99c>] sys_mount+0x6c/0xa0
[    7.517711]  [<c138e0e1>] syscall_call+0x7/0xb
[    7.518823] ---[ end trace 13753716ad16dd17 ]---
[    7.633900] ------------[ cut here ]------------
[    7.636734] WARNING: at lib/list_debug.c:26 __list_add+0x8f/0xa0()
[    7.638118] Hardware name: VMware Virtual Platform
[    7.639251] list_add corruption. next->prev should be prev (c156b180), but was (null). (next=de0a4fa0).
[    7.641361] Modules linked in: pcnet32
[    7.642296] Pid: 1159, comm: mount Tainted: G        W   2.6.36-rc1 #1
[    7.645946] Call Trace:
[    7.646545]  [<c11e1c00>] ? __list_add+0x20/0xa0
[    7.647631]  [<c11e1c6f>] ? __list_add+0x8f/0xa0
[    7.648702]  [<c103d18c>] warn_slowpath_common+0x7c/0xa0
[    7.649890]  [<c11e1c6f>] ? __list_add+0x8f/0xa0
[    7.650946]  [<c103d1e1>] warn_slowpath_fmt+0x31/0x40
[    7.652114]  [<c11e1c6f>] __list_add+0x8f/0xa0
[    7.653142]  [<c11e5425>] __percpu_counter_init+0x75/0x90
[    7.656110]  [<c10a7742>] shmem_fill_super+0xb2/0x170
[    7.657266]  [<c10c6135>] ? sget+0x165/0x1f0
[    7.658226]  [<c10c67e0>] ? set_anon_super+0x0/0xe0
[    7.659341]  [<c10c6c50>] get_sb_nodev+0x50/0x80
[    7.660418]  [<c10a78cf>] shmem_get_sb+0x1f/0x30
[    7.661477]  [<c10a7690>] ? shmem_fill_super+0x0/0x170
[    7.662611]  [<c10c6da1>] vfs_kern_mount+0x71/0x190
[    7.665910]  [<c10daef0>] ? get_fs_type+0x30/0xa0
[    7.667024]  [<c10c70e7>] do_kern_mount+0x37/0x90
[    7.668122]  [<c10dd087>] do_new_mount+0x57/0xa0
[    7.669210]  [<c10dd691>] do_mount+0x171/0x1b0
[    7.670347]  [<c10dd99c>] sys_mount+0x6c/0xa0
[    7.671348]  [<c138e0e1>] syscall_call+0x7/0xb
[    7.672412] ---[ end trace 13753716ad16dd18 ]---
[    7.698493] EXT3-fs (sda1): recovery required on readonly filesystem
[    7.700100] EXT3-fs (sda1): write access will be enabled during recovery
[    7.702792] EXT3-fs: barriers not enabled
[    7.764556] scsi0: Tagged Queuing now active for Target 0
[    7.768309] kjournald starting.  Commit interval 5 seconds
[    7.768887] EXT3-fs (sda1): recovery complete
[    7.771507] EXT3-fs (sda1): mounted filesystem with ordered data mode
[    7.773979] mount used greatest stack depth: 1168 bytes left
[   10.792931] EXT3-fs (sda1): using internal journal
[   15.186074] EXT3-fs: barriers not enabled
[   15.219484] kjournald starting.  Commit interval 5 seconds
[   17.620661] EXT3-fs (sdb1): using internal journal
[   17.622297] EXT3-fs (sdb1): mounted filesystem with ordered data mode
[   25.617923] pcnet32 0000:02:00.0: eth0: link up
[   34.921324] rcS used greatest stack depth: 988 bytes left

Also, I get RCU stall at "Unmounting local filesystems..." for both
"booted with initrd" and "booted without initrd" cases.
Maybe list corruption is happening without using initrd.

[  465.144200] nfsd: last server has exited, flushing export cache
[  487.051234] INFO: rcu_sched_state detected stall on CPU 0 (t=3750 jiffies)
[  487.051234] sending NMI to all CPUs:
[  487.051234] NMI backtrace for cpu 0
[  487.051234] Modules linked in: ipv6 pcnet32
[  487.051234] 
[  487.051234] Pid: 2793, comm: umount Tainted: G        W   2.6.36-rc1 #1 440BX Desktop Reference Platform/VMware Virtual Platform
[  487.051234] EIP: 0060:[<c101e839>] EFLAGS: 00000046 CPU: 0
[  487.051234] EIP is at default_send_IPI_mask_logical+0x99/0x130
[  487.051234] EAX: fffff000 EBX: 03000000 ECX: c101e7ce EDX: 00000c00
[  487.051234] ESI: 00000c00 EDI: 00000046 EBP: de2e5dc0 ESP: de2e5da4
[  487.051234]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  487.051234] Process umount (pid: 2793, ti=de2e5000 task=dab86af0 task.ti=de2e5000)
[  487.051234] Stack:
[  487.051234]  00000000 de2e5dc0 c1066c23 00000002 00000000 c1555a00 c1555a00 de2e5dcc
[  487.051234] <0> c101e9e1 00000000 de2e5ddc c101f242 c1494565 c1555a00 de2e5dfc c108b8ac
[  487.051234] <0> c14a9600 c14a2fa4 00000000 00000ea6 00000000 c1555a00 de2e5e0c c108b92f
[  487.051234] Call Trace:
[  487.051234]  [<c1066c23>] ? lock_release_holdtime+0x73/0xb0
[  487.051234]  [<c101e9e1>] ? default_send_IPI_all+0x71/0x80
[  487.051234]  [<c101f242>] ? arch_trigger_all_cpu_backtrace+0x32/0x60
[  487.051234]  [<c108b8ac>] ? print_cpu_stall+0x4c/0x90
[  487.051234]  [<c108b92f>] ? check_cpu_stall+0x3f/0x70
[  487.051234]  [<c108c880>] ? __rcu_pending+0x20/0xe0
[  487.051234]  [<c108c969>] ? rcu_pending+0x29/0x70
[  487.051234]  [<c108c31c>] ? rcu_check_callbacks+0x6c/0xa0
[  487.051234]  [<c1048ef8>] ? update_process_times+0x38/0x60
[  487.051234]  [<c1064d95>] ? tick_periodic+0x25/0x80
[  487.051234]  [<c1064e09>] ? tick_handle_periodic+0x19/0x80
[  487.051234]  [<c1069d02>] ? mark_held_locks+0x42/0x80
[  487.051234]  [<c101d263>] ? local_apic_timer_interrupt+0x53/0x60
[  487.051234]  [<c101d29e>] ? smp_apic_timer_interrupt+0x2e/0x40
[  487.051234]  [<c138e53b>] ? apic_timer_interrupt+0x2f/0x34
[  487.051234]  [<c11e1cb9>] ? list_del+0x39/0x110
[  487.051234]  [<c11e5464>] ? percpu_counter_destroy+0x24/0x40
[  487.051234]  [<c11248fc>] ? ext3_put_super+0x9c/0x1d0
[  487.051234]  [<c10d828e>] ? invalidate_inodes+0x5e/0x70
[  487.051234]  [<c10c5fc3>] ? generic_shutdown_super+0xc3/0xd0
[  487.051234]  [<c10c6be5>] ? kill_block_super+0x25/0x40
[  487.051234]  [<c10c5db5>] ? deactivate_locked_super+0x25/0x50
[  487.051234]  [<c10c5e2f>] ? deactivate_super+0x4f/0x60
[  487.051234]  [<c10db98e>] ? mntput_no_expire+0x5e/0xa0
[  487.051234]  [<c10dc535>] ? sys_umount+0x65/0xb0
[  487.051234]  [<c10dc597>] ? sys_oldumount+0x17/0x20
[  487.051234]  [<c138e0e1>] ? syscall_call+0x7/0xb
[  487.051234] Code: f6 c4 10 75 ed c1 e3 18 89 9a 10 c3 ff ff 8b 55 f0 a1 4c 1a 55 c1 09 f2 81 ce 00 04 00 00 83 7d f0 02 0f 44 d6 89 90 00 c3 ff ff <89> f8 c1 e8 09 83 f0 01 a8 01 74 0f 57 9d e8 d4 b7 04 00 83 c4 
[  487.051234] Call Trace:
[  487.051234]  [<c1066c23>] ? lock_release_holdtime+0x73/0xb0
[  487.051234]  [<c101e9e1>] default_send_IPI_all+0x71/0x80
[  487.051234]  [<c101f242>] arch_trigger_all_cpu_backtrace+0x32/0x60
[  487.051234]  [<c108b8ac>] print_cpu_stall+0x4c/0x90
[  487.051234]  [<c108b92f>] check_cpu_stall+0x3f/0x70
[  487.051234]  [<c108c880>] __rcu_pending+0x20/0xe0
[  487.051234]  [<c108c969>] rcu_pending+0x29/0x70
[  487.051234]  [<c108c31c>] rcu_check_callbacks+0x6c/0xa0
[  487.051234]  [<c1048ef8>] update_process_times+0x38/0x60
[  487.051234]  [<c1064d95>] tick_periodic+0x25/0x80
[  487.051234]  [<c1064e09>] tick_handle_periodic+0x19/0x80
[  487.051234]  [<c1069d02>] ? mark_held_locks+0x42/0x80
[  487.051234]  [<c101d263>] local_apic_timer_interrupt+0x53/0x60
[  487.051234]  [<c101d29e>] smp_apic_timer_interrupt+0x2e/0x40
[  487.051234]  [<c138e53b>] apic_timer_interrupt+0x2f/0x34
[  487.051234]  [<c11e1cb9>] ? list_del+0x39/0x110
[  487.051234]  [<c11e5464>] percpu_counter_destroy+0x24/0x40
[  487.051234]  [<c11248fc>] ext3_put_super+0x9c/0x1d0
[  487.051234]  [<c10d828e>] ? invalidate_inodes+0x5e/0x70
[  487.051234]  [<c10c5fc3>] generic_shutdown_super+0xc3/0xd0
[  487.051234]  [<c10c6be5>] kill_block_super+0x25/0x40
[  487.051234]  [<c10c5db5>] deactivate_locked_super+0x25/0x50
[  487.051234]  [<c10c5e2f>] deactivate_super+0x4f/0x60
[  487.051234]  [<c10db98e>] mntput_no_expire+0x5e/0xa0
[  487.051234]  [<c10dc535>] sys_umount+0x65/0xb0
[  487.051234]  [<c10dc597>] sys_oldumount+0x17/0x20
[  487.051234]  [<c138e0e1>] syscall_call+0x7/0xb
[  487.051234] Pid: 2793, comm: umount Tainted: G        W   2.6.36-rc1 #1
[  487.051234] Call Trace:
[  487.051234]  [<c1009e12>] ? show_regs+0x22/0x30
[  487.051234]  [<c101efd9>] nmi_watchdog_tick+0x159/0x1f0
[  487.051234]  [<c1003b30>] default_do_nmi+0x90/0x1b0
[  487.051234]  [<c1003cc9>] do_nmi+0x79/0x90
[  487.051234]  [<c138e829>] nmi_stack_correct+0x28/0x2d
[  487.051234]  [<c101e7ce>] ? default_send_IPI_mask_logical+0x2e/0x130
[  487.051234]  [<c101e839>] ? default_send_IPI_mask_logical+0x99/0x130
[  487.051234]  [<c1066c23>] ? lock_release_holdtime+0x73/0xb0
[  487.051234]  [<c101e9e1>] default_send_IPI_all+0x71/0x80
[  487.051234]  [<c101f242>] arch_trigger_all_cpu_backtrace+0x32/0x60
[  487.051234]  [<c108b8ac>] print_cpu_stall+0x4c/0x90
[  487.051234]  [<c108b92f>] check_cpu_stall+0x3f/0x70
[  487.051234]  [<c108c880>] __rcu_pending+0x20/0xe0
[  487.051234]  [<c108c969>] rcu_pending+0x29/0x70
[  487.051234]  [<c108c31c>] rcu_check_callbacks+0x6c/0xa0
[  487.051234]  [<c1048ef8>] update_process_times+0x38/0x60
[  487.051234]  [<c1064d95>] tick_periodic+0x25/0x80
[  487.051234]  [<c1064e09>] tick_handle_periodic+0x19/0x80
[  487.051234]  [<c1069d02>] ? mark_held_locks+0x42/0x80
[  487.051234]  [<c101d263>] local_apic_timer_interrupt+0x53/0x60
[  487.051234]  [<c101d29e>] smp_apic_timer_interrupt+0x2e/0x40
[  487.051234]  [<c138e53b>] apic_timer_interrupt+0x2f/0x34
[  487.051234]  [<c11e1cb9>] ? list_del+0x39/0x110
[  487.051234]  [<c11e5464>] percpu_counter_destroy+0x24/0x40
[  487.051234]  [<c11248fc>] ext3_put_super+0x9c/0x1d0
[  487.051234]  [<c10d828e>] ? invalidate_inodes+0x5e/0x70
[  487.051234]  [<c10c5fc3>] generic_shutdown_super+0xc3/0xd0
[  487.051234]  [<c10c6be5>] kill_block_super+0x25/0x40
[  487.051234]  [<c10c5db5>] deactivate_locked_super+0x25/0x50
[  487.051234]  [<c10c5e2f>] deactivate_super+0x4f/0x60
[  487.051234]  [<c10db98e>] mntput_no_expire+0x5e/0xa0
[  487.051234]  [<c10dc535>] sys_umount+0x65/0xb0
[  487.051234]  [<c10dc597>] sys_oldumount+0x17/0x20
[  487.051234]  [<c138e0e1>] syscall_call+0x7/0xb
[  487.042994] NMI backtrace for cpu 1
[  487.042994] Modules linked in: ipv6 pcnet32
[  487.042994] 
[  487.042994] Pid: 0, comm: kworker/0:0 Tainted: G        W   2.6.36-rc1 #1 440BX Desktop Reference Platform/VMware Virtual Platform
[  487.042994] EIP: 0060:[<c100a334>] EFLAGS: 00000202 CPU: 1
[  487.042994] EIP is at default_idle+0x34/0x60
[  487.042994] EAX: 00000002 EBX: 00000001 ECX: 00000001 EDX: 00000001
[  487.042994] ESI: 00000000 EDI: 00000000 EBP: df9f5f98 ESP: df9f5f98
[  487.042994]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  487.042994] Process kworker/0:0 (pid: 0, ti=df9f5000 task=dfa0a2b0 task.ti=df9f5000)
[  487.042994] Stack:
[  487.042994]  df9f5fa8 c1001619 02010800 00000000 df9f5fb0 c1386a5a 00000000 00000000
[  487.042994] <0> 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  487.042994] <0> 000000d8 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  487.042994] Call Trace:
[  487.042994]  [<c1001619>] ? cpu_idle+0x59/0xa0
[  487.042994]  [<c1386a5a>] ? start_secondary+0xca/0x100
[  487.042994] Code: 85 d2 75 43 80 3d a5 ab 58 c1 00 74 3a 89 e0 25 00 f0 ff ff 83 60 0c fb 0f ae f0 8d 76 00 f6 40 08 08 75 15 e8 ce fb 05 00 fb f4 <89> e0 25 00 f0 ff ff 83 48 0c 04 90 5d c3 e8 b9 fb 05 00 fb eb 
[  487.042994] Call Trace:
[  487.042994]  [<c1001619>] cpu_idle+0x59/0xa0
[  487.042994]  [<c1386a5a>] start_secondary+0xca/0x100
[  487.042994] Pid: 0, comm: kworker/0:0 Tainted: G        W   2.6.36-rc1 #1
[  487.042994] Call Trace:
[  487.042994]  [<c1009e12>] ? show_regs+0x22/0x30
[  487.042994]  [<c101efd9>] nmi_watchdog_tick+0x159/0x1f0
[  487.042994]  [<c1003b30>] default_do_nmi+0x90/0x1b0
[  487.042994]  [<c138e114>] ? restore_all_notrace+0x0/0x18
[  487.042994]  [<c1003cc9>] do_nmi+0x79/0x90
[  487.042994]  [<c138e829>] nmi_stack_correct+0x28/0x2d
[  487.042994]  [<c100a334>] ? default_idle+0x34/0x60
[  487.042994]  [<c1001619>] cpu_idle+0x59/0xa0
[  487.042994]  [<c1386a5a>] start_secondary+0xca/0x100

Regards.
