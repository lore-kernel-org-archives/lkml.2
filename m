Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191Ab1DMQrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:47:37 -0400
Received: from mail.candelatech.com ([208.74.158.172]:48034 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549Ab1DMQrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:47:35 -0400
Message-ID: <4DA5D3A6.8010708@candelatech.com>
Date: Wed, 13 Apr 2011 09:47:34 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.39-rc3-wl+ blocked 'mount' task, won't complete booting.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This may be related to the other bug I just posted
"WARNING at libata-core.c:5015 in 2.6.39-rc3-wl+, then lockup.", but I didn't
see any warnings print before these


Console: switching to colour frame buffer device 160x64
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
dracut: Starting plymouth daemon
dracut: Scanning devices sda2  for LVM logical volumes VolGroup/lv_root VolGroup/lv_swap
dracut: inactive '/dev/VolGroup/lv_root' [10.47 GiB] inherit
dracut: inactive '/dev/VolGroup/lv_swap' [3.94 GiB] inherit
EXT4-fs (dm-0): INFO: recovery required on readonly filesystem
EXT4-fs (dm-0): write access will be enabled during recovery


SysRq : Show Locks Held

Showing all locks held in the system:
1 lock held by mount/226:
  #0:  (&type->s_umount_key#19/1){+.+.+.}, at: [<c04e7b48>] sget+0x1f6/0x339

=============================================

SysRq : Show backtrace of all active CPUs
sending NMI to all CPUs:
NMI backtrace for cpu 0
Modules linked in: i915 drm_kms_helper drm i2c_algo_bit video [last unloaded: scsi_wait_scan]

Pid: 0, comm: swapper Not tainted 2.6.39-rc3-wl+ #58 To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M.
EIP: 0060:[<c046117f>] EFLAGS: 00000046 CPU: 0
EIP is at trace_hardirqs_off+0xc/0xd
EAX: 00000046 EBX: 00000003 ECX: c046117e EDX: c041ad61
ESI: 00000002 EDI: 00000006 EBP: f540ff04 ESP: f540fef4
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=f540e000 task=c0a26020 task.ti=c09e4000)
Stack:
  c041ad61 00000000 c0a58518 00000007 f540ff10 c041aaf7 00000000 f540ff20
  c041b045 c092d864 0000006c f540ff28 c06548a8 f540ff4c c0654b3f c09285f1
  c09740d6 c07f3f01 00000092 c106c204 0000006c fffdd64c f540ff54 c0654d59
Call Trace:
  [<c041ad61>] ? default_send_IPI_mask_logical+0x92/0xa9
  [<c041aaf7>] default_send_IPI_all+0x27/0x6a
  [<c041b045>] arch_trigger_all_cpu_backtrace+0x3e/0x69
  [<c06548a8>] sysrq_handle_showallcpus+0xd/0xf
  [<c0654b3f>] __handle_sysrq+0xa0/0x115
  [<c07f3f01>] ? _raw_spin_lock_irqsave+0x35/0x44
  [<c0654d59>] handle_sysrq+0x2b/0x2d
  [<c0664580>] serial8250_handle_port+0x13f/0x269
  [<c06646fc>] serial8250_interrupt+0x52/0xea
  [<c0484004>] handle_irq_event_percpu+0x58/0x17b
  [<c0484158>] handle_irq_event+0x31/0x48
  [<c0485c53>] ? handle_percpu_irq+0x40/0x40
  [<c0485ce2>] handle_edge_irq+0x8f/0xb1
  <IRQ>
  [<c0403afe>] ? do_IRQ+0x3c/0x95
  [<c07fa92e>] ? common_interrupt+0x2e/0x40
  [<c046007b>] ? ftrace_raw_output_lock+0x53/0xaa
  [<c0617633>] ? intel_idle+0xbf/0xe8
  [<c0724bd0>] ? cpuidle_idle_call+0xcd/0x141
  [<c0402439>] ? cpu_idle+0x58/0x77
  [<c07d9166>] ? rest_init+0x92/0x97
  [<c0a817f8>] ? start_kernel+0x30f/0x314
  [<c0a810c5>] ? i386_start_kernel+0xc5/0xcc
Code: 3c 04 00 00 00 00 00 00 89 b3 30 04 00 00 40 89 83 28 04 00 00 89 83 38 04 00 00 5b 5e 5d c3 55 89 e5 8b 45 04 e8 64 ff ff ff 5d <c3> 55 31 c9
Call Trace:
  [<c041ad61>] ? default_send_IPI_mask_logical+0x92/0xa9
  [<c041aaf7>] default_send_IPI_all+0x27/0x6a
  [<c041b045>] arch_trigger_all_cpu_backtrace+0x3e/0x69
  [<c06548a8>] sysrq_handle_showallcpus+0xd/0xf
  [<c0654b3f>] __handle_sysrq+0xa0/0x115
  [<c07f3f01>] ? _raw_spin_lock_irqsave+0x35/0x44
  [<c0654d59>] handle_sysrq+0x2b/0x2d
  [<c0664580>] serial8250_handle_port+0x13f/0x269
  [<c06646fc>] serial8250_interrupt+0x52/0xea
  [<c0484004>] handle_irq_event_percpu+0x58/0x17b
  [<c0484158>] handle_irq_event+0x31/0x48
  [<c0485c53>] ? handle_percpu_irq+0x40/0x40
  [<c0485ce2>] handle_edge_irq+0x8f/0xb1
  <IRQ>  [<c0403afe>] ? do_IRQ+0x3c/0x95
  [<c07fa92e>] ? common_interrupt+0x2e/0x40
  [<c046007b>] ? ftrace_raw_output_lock+0x53/0xaa
  [<c0617633>] ? intel_idle+0xbf/0xe8
  [<c0724bd0>] ? cpuidle_idle_call+0xcd/0x141
  [<c0402439>] ? cpu_idle+0x58/0x77
  [<c07d9166>] ? rest_init+0x92/0x97
  [<c0a817f8>] ? start_kernel+0x30f/0x314
  [<c0a810c5>] ? i386_start_kernel+0xc5/0xcc
NMI backtrace for cpu 1
Modules linked in: i915 drm_kms_helper drm i2c_algo_bit video [last unloaded: scsi_wait_scan]

Pid: 0, comm: kworker/0:0 Not tainted 2.6.39-rc3-wl+ #58 To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M.
EIP: 0060:[<c0617615>] EFLAGS: 00000046 CPU: 1
EIP is at intel_idle+0xa1/0xe8
EAX: 00000030 EBX: a22b5320 ECX: 00000001 EDX: 00000000
ESI: 12142a7a EDI: 00000010 EBP: f54e3f74 ESP: f54e3f60
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kworker/0:0 (pid: 0, ti=f54e2000 task=f5497170 task.ti=f54e2000)
Stack:
  00000030 00000001 ff7f2000 00000001 00000108 f54e3f90 c0724bd0 00000001
  ff7f2118 c0a7de78 00000001 00000000 f54e3fa0 c0402439 00000001 00000000
  f54e3fac c07eede1 01020800 00000000 00000000 00000000 00000000 00000000
Call Trace:
  [<c0724bd0>] cpuidle_idle_call+0xcd/0x141
  [<c0402439>] cpu_idle+0x58/0x77
  [<c07eede1>] start_secondary+0x176/0x17b
Code: 08 8b 52 08 80 e2 08 75 22 31 d2 89 d1 0f 01 c8 0f ae f0 89 f6 89 e0 25 00 e0 ff ff 8b 40 08 a8 08 75 08 b1 01 8b 45 ec 0f 01 c9 <e8> 9f f4 e7
Call Trace:
  [<c0724bd0>] cpuidle_idle_call+0xcd/0x141
  [<c0402439>] cpu_idle+0x58/0x77
  [<c07eede1>] start_secondary+0x176/0x17b

INFO: task mount:226 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
mount           D 00000000     0   226      1 0x00000000
  f4555c54 00000046 f443c830 00000000 c0b19600 f443c830 c0b19600 c0b19600
  f443caa4 c0b19600 92c0bf72 00000001 00000000 00000001 f443c830 00000046
  f443c830 f443c830 00000000 00000006 b25a2e57 f4555c2c c045935d f44c522c
Call Trace:
  [<c045935d>] ? timekeeping_get_ns+0x16/0x52
  [<c045a58b>] ? ktime_get_ts+0x98/0xa2
  [<c07f28b9>] io_schedule+0x72/0xab
  [<c0506981>] sleep_on_buffer+0xd/0x11
  [<c07f2f07>] __wait_on_bit+0x39/0x60
  [<c0506974>] ? unmap_underlying_metadata+0x51/0x51
  [<c0506974>] ? unmap_underlying_metadata+0x51/0x51
  [<c07f2fce>] out_of_line_wait_on_bit+0xa0/0xa8
  [<c0452114>] ? autoremove_wake_function+0x34/0x34
  [<c05068ef>] __wait_on_buffer+0x20/0x23
  [<c057c784>] jread+0x1a5/0x1da
  [<c0461cb6>] ? trace_hardirqs_on_caller+0x10e/0x12f
  [<c0461ce2>] ? trace_hardirqs_on+0xb/0xd
  [<c057cb53>] do_one_pass+0x39a/0x6e7
  [<c057cff0>] jbd2_journal_recover+0xa2/0x142
  [<c0580f90>] jbd2_journal_load+0x109/0x2cb
  [<c0560ab6>] ? ext4_fill_super+0x17e2/0x239b
  [<c0560ab6>] ? ext4_fill_super+0x17e2/0x239b
  [<c0560ab6>] ? ext4_fill_super+0x17e2/0x239b
  [<c04d8c94>] ? kmem_cache_alloc_trace+0x92/0x9c
  [<c0560adc>] ext4_fill_super+0x1808/0x239b
  [<c05ce464>] ? snprintf+0x15/0x17
  [<c052cdc1>] ? disk_name+0x29/0x6e
  [<c04e7e6d>] mount_bdev+0x107/0x140
  [<c04d8ad9>] ? __kmalloc_track_caller+0x10b/0x117
  [<c055ba0e>] ext4_mount+0x15/0x17
  [<c055f2d4>] ? ext4_register_li_request+0x290/0x290
  [<c04e7889>] mount_fs+0x61/0x12a
  [<c04fa730>] ? alloc_vfsmnt+0xa6/0x122
  [<c04faf40>] vfs_kern_mount+0x51/0x7e
  [<c04fb747>] do_kern_mount+0x34/0xb4
  [<c04fc3a7>] do_mount+0x614/0x662
  [<c04fc45b>] sys_mount+0x66/0x94
  [<c07fa35c>] sysenter_do_call+0x12/0x38
1 lock held by mount/226:
  #0:  (&type->s_umount_key#19/1){+.+.+.}, at: [<c04e7b48>] sget+0x1f6/0x339


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

