Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab1EBR1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 13:27:04 -0400
Received: from mail.candelatech.com ([208.74.158.172]:43432 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab1EBR07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 13:26:59 -0400
Message-ID: <4DBEE960.7000801@candelatech.com>
Date: Mon, 02 May 2011 10:26:56 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Block related crashes & hangs in 2.6.39-rc5
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm still having troubles on 2.6.39-rc5.

On today's linux-2.6 top-of-tree, it just hung the first time
I tried (with elevator=noop, but not sure that matters).

[drm] initialized overlay support
fbcon: inteldrmfb (fb0) is primary device
[drm] Changing LVDS panel from (+hsync, +vsync) to (-hsync, -vsync)
Console: switching to colour frame buffer device 160x64
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
dracut: Starting plymouth daemon
dracut: Scanning devices sda2  for LVM logical volumes VolGroup/lv_root VolGroup/lv_swap
dracut: inactive '/dev/VolGroup/lv_root' [10.47 GiB] inherit
dracut: inactive '/dev/VolGroup/lv_swap' [3.94 GiB] inherit
EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)

I disabled elevator=noop, and saw this next boot, so evidently that wasn't
the cause...

udev[306]: starting version 161
sd 0:0:1:0: [sda] Unhandled sense code
sd 0:0:1:0: [sda]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:1:0: [sda]  Sense Key : 0xf [current]
sd 0:0:1:0: [sda]  Add. Sense: No additional sense information
sd 0:0:1:0: [sda] CDB: Read(10): 28 00 00 0f fb 40 00 00 30 00
end_request: I/O error, dev sda, sector 1047360
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-2.6/drivers/ata/libata-core.c:5016 ata_qc_issue+0x15d/0x296()
Hardware name: To Be Filled By O.E.M.
Modules linked in: i915 drm_kms_helper drm i2c_algo_bit video [last unloaded: scsi_wait_scan]
Pid: 275, comm: readahead Not tainted 2.6.39-rc5+ #20
Call Trace:
  [<c043a0e2>] warn_slowpath_common+0x6a/0x7f
  [<c06a5159>] ? ata_qc_issue+0x15d/0x296
  [<c043a10b>] warn_slowpath_null+0x14/0x18
  [<c06a5159>] ata_qc_issue+0x15d/0x296
  [<c06ab08b>] __ata_scsi_queuecmd+0x15b/0x1a0
  [<c06aa793>] ? ata_scsiop_mode_sense+0x25c/0x25c
  [<c06ab152>] ata_scsi_queuecmd+0x3c/0x63
  [<c068ccaa>] scsi_dispatch_cmd+0x161/0x1ee
  [<c0691cc0>] scsi_request_fn+0x319/0x44a
  [<c05b36cc>] __blk_run_queue+0x19/0x1b
  [<c05b603e>] blk_run_queue+0x20/0x31
  [<c06914dd>] scsi_run_queue+0x1a8/0x1ea
  [<c068cf2c>] ? __scsi_put_command+0x59/0x5f
  [<c0691f9c>] scsi_next_command+0x2d/0x39
  [<c0692ac5>] scsi_io_completion+0x3e8/0x41f
  [<c0692602>] ? scsi_device_unbusy+0x8c/0x92
  [<c068ca47>] scsi_finish_command+0xc5/0xcd
  [<c0692bed>] scsi_softirq_done+0xdd/0xe5
  [<c05bb096>] blk_done_softirq+0x66/0x73
  [<c043fbaa>] __do_softirq+0xb1/0x17c
  [<c043faf9>] ? __local_bh_enable+0x8c/0x8c
  <IRQ>  [<c043f97a>] ? irq_exit+0x43/0x8e
  [<c0403b43>] ? do_IRQ+0x81/0x95
  [<c07f56ee>] ? common_interrupt+0x2e/0x40
  [<c046007b>] ? ftrace_raw_output_lock+0x8f/0xaa
  [<c07ef144>] ? _raw_spin_unlock_irq+0x29/0x30
  [<c05c219a>] ? blk_throtl_bio+0x41b/0x448
  [<c05b6d84>] ? generic_make_request+0x242/0x2d8
  [<c05cf5d8>] ? trace_hardirqs_on_thunk+0xc/0x10
  [<c05b6ed9>] ? submit_bio+0xbf/0xc7
  [<c0509220>] ? bio_alloc_bioset+0x3c/0x99
  [<c05056b5>] ? submit_bh+0xe7/0x107
  [<c05068e7>] ? ll_rw_block+0x61/0x76
  [<c0506fc1>] ? __breadahead+0x2d/0x3b
  [<c054aa39>] ? __ext4_get_inode_loc+0x29b/0x34e
  [<c054bac1>] ? ext4_iget+0x57/0x6a8
  [<c055201b>] ? ext4_lookup+0x66/0xb8
  [<c04ed39a>] ? d_alloc_and_lookup+0x3d/0x54
  [<c04ee9d2>] ? walk_component+0x138/0x2b7
  [<c04ef0dd>] ? link_path_walk+0x8a/0x394
  [<c04eec4e>] ? do_last+0xfd/0x502
  [<c04ef4f7>] ? path_openat+0x9b/0x28a
  [<c0463349>] ? lock_release_non_nested+0x86/0x1d8
  [<c04c0f0d>] ? might_fault+0x4c/0x86
  [<c04ef79a>] ? do_filp_open+0x26/0x62
  [<c07ef1ba>] ? _raw_spin_unlock+0x22/0x25
  [<c04f955c>] ? alloc_fd+0x137/0x144
  [<c04e3ce9>] ? do_sys_open+0x59/0xd8
  [<c04e3db4>] ? sys_open+0x23/0x2b
  [<c07f511c>] ? sysenter_do_call+0x12/0x38
---[ end trace b80641d7fc29e077 ]---
ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.01: failed command: READ DMA
ata1.01: cmd c8/00:08:70:fb:0f/00:00:00:00:00/f0 tag 0 dma 4096 in
          res 50/00:00:48:fb:0f/00:00:00:00:00/f0 Emask 0x40 (internal error)
ata1.01: status: { DRDY }
ata1.01: configured for UDMA/100
BUG: unable to handle kernel paging request at 00800a18
IP: [<c05b5ebb>] bio_data+0xd/0x37
*pde = 00000000
Oops: 0000 [#1] SMP
last sysfs file: /sys/bus/platform/drivers/88pm860x-regulator/uevent
Modules linked in: i915 drm_kms_helper drm i2c_algo_bit video [last unloaded: scsi_wait_scan]

Pid: 36, comm: scsi_eh_0 Tainted: G        W   2.6.39-rc5+ #20 To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M.
EIP: 0060:[<c05b5ebb>] EFLAGS: 00010246 CPU: 0
EIP is at bio_data+0xd/0x37
EAX: 00000000 EBX: 00800a00 ECX: 00000000 EDX: 00800a00
ESI: 00800a00 EDI: 00000000 EBP: f4f1be34 ESP: f4f1be30
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process scsi_eh_0 (pid: 36, ti=f4f1a000 task=f54fe720 task.ti=f4f1a000)
Stack:
  f45dc000 f4f1be5c c05b6496 f4f1bea8 00000000 00000000 00000000 00000000
  f45dc000 00000000 00000000 f4f1be6c c05b6552 f4f6c000 f45dc000 f4f1be88
  c05b7482 00000000 c06925ee f4438e40 00000000 f45dc000 f4f1be94 c05b74f8
Call Trace:
  [<c05b6496>] blk_update_request+0x25c/0x305
  [<c05b6552>] blk_update_bidi_request+0x13/0x54
  [<c05b7482>] blk_end_bidi_request+0x1d/0x55
  [<c06925ee>] ? scsi_device_unbusy+0x78/0x92
  [<c05b74f8>] blk_end_request+0xf/0x11
  [<c069289c>] scsi_io_completion+0x1bf/0x41f
  [<c068ca47>] scsi_finish_command+0xc5/0xcd
  [<c068fa4e>] scsi_eh_flush_done_q+0xd8/0xf3
  [<c06b013b>] ata_scsi_port_error_handler+0x43d/0x4ad
  [<c06b022c>] ata_scsi_error+0x81/0xa6
  [<c0690907>] scsi_error_handler+0x119/0x54b
  [<c07ef18c>] ? _raw_spin_unlock_irqrestore+0x41/0x4d
  [<c0461c7a>] ? trace_hardirqs_on_caller+0x10e/0x12f
  [<c042d9f3>] ? complete+0x39/0x43
  [<c06907ee>] ? scsi_eh_get_sense+0x175/0x175
  [<c0451d49>] kthread+0x67/0x6c
  [<c0451ce2>] ? __init_kthread_worker+0x47/0x47
  [<c07f5706>] kernel_thread_helper+0x6/0x10
Code: 3e 8d 74 26 00 89 c3 eb 0b 8b 50 08 89 53 3c e8 e8 25 f5 ff 8b 43 3c 85 c0 75 ee 5b 5d c3 55 89 e5 53 3e 8d 74 26 00 89 c3 31 c0
  83 7b 18 00 74 20 0f b7 53 1a 8b 43 38 6b d2 0c 8b 04 02 e8
EIP: [<c05b5ebb>] bio_data+0xd/0x37 SS:ESP 0068:f4f1be30
CR2: 0000000000800a18
---[ end trace b80641d7fc29e078 ]---



On lightly-hacked wireless-testing based on 2.6.39-rc5, I see this
crash and then constant spewing after that:

general protection fault: 0000 [#1] SMP
last sysfs file: /sys/bus/pci/drivers/agpgart-serverworks/uevent
Modules linked in: i915 drm_kms_helper drm i2c_algo_bit video [last unloaded: scsi_wait_scan]

Pid: 255, comm: readahead Not tainted 2.6.39-rc5-wl+ #61 To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M.
EIP: 0060:[<c0695f28>] EFLAGS: 00010246 CPU: 0
EIP is at scsi_request_fn+0x42d/0x44a
EAX: 00000000 EBX: f4f28800 ECX: 00000018 EDX: ffffffff
ESI: f5596800 EDI: ffffffff EBP: f5421ef4 ESP: f5421ed0
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process readahead (pid: 255, ti=f5420000 task=f45ad280 task.ti=f4596000)
Stack:
  f4f5c2a8 f4f288e4 f44c9f00 f4516cb0 f4f5c000 f4f28844 f4f5c000 00000246
  f552e000 f5421efc c05b3684 f5421f0c c05b5ff6 f5596800 f559683c f5421f40
  c0695631 f5421f2c c0691080 f4f288e4 f4f5c000 f4f28800 00000246 f5421f2c
Call Trace:
  [<c05b3684>] __blk_run_queue+0x19/0x1b
  [<c05b5ff6>] blk_run_queue+0x20/0x31
  [<c0695631>] scsi_run_queue+0x1a8/0x1ea
  [<c0691080>] ? __scsi_put_command+0x59/0x5f
  [<c06960f0>] scsi_next_command+0x2d/0x39
  [<c0696c19>] scsi_io_completion+0x3e8/0x41f
  [<c0696756>] ? scsi_device_unbusy+0x8c/0x92
  [<c0690b9b>] scsi_finish_command+0xc5/0xcd
  [<c0696d41>] scsi_softirq_done+0xdd/0xe5
  [<c05bb04e>] blk_done_softirq+0x66/0x73
  [<c043fb8a>] __do_softirq+0xb1/0x17c
  [<c043fad9>] ? __local_bh_enable+0x8c/0x8c
  <IRQ>
  [<c043f95a>] ? irq_exit+0x43/0x8e
  [<c0403b43>] ? do_IRQ+0x81/0x95
  [<c07fabee>] ? common_interrupt+0x2e/0x40
  [<c05b69eb>] ? bio_check_eod+0x22/0x131
  [<c0455dd1>] ? up_read+0x1b/0x2e
  [<c07141c6>] ? dm_request+0x139/0x140
  [<c05b6b8c>] ? generic_make_request+0x92/0x2d8
  [<c04d7a0f>] ? slab_pre_alloc_hook+0x18/0x38
  [<c04acd9f>] ? mempool_alloc_slab+0x13/0x15
  [<c04acec3>] ? mempool_alloc+0x5c/0xf9
  [<c05b6e91>] ? submit_bio+0xbf/0xc7
  [<c05091d8>] ? bio_alloc_bioset+0x3c/0x99
  [<c050566d>] ? submit_bh+0xe7/0x107
  [<c050689f>] ? ll_rw_block+0x61/0x76
  [<c0551e57>] ? ext4_find_entry+0x23d/0x353
  [<c04617d5>] ? mark_lock+0x1e/0x1de
  [<c04f4adb>] ? d_alloc+0x131/0x18c
  [<c0551f9a>] ? ext4_lookup+0x2d/0xb8
  [<c04ed35a>] ? d_alloc_and_lookup+0x3d/0x54
  [<c04ee992>] ? walk_component+0x138/0x2b7
  [<c04ef09d>] ? link_path_walk+0x8a/0x394
  [<c04eec0e>] ? do_last+0xfd/0x502
  [<c04ef4b7>] ? path_openat+0x9b/0x28a
  [<c0463311>] ? lock_release_non_nested+0x86/0x1d8
  [<c04c0eb9>] ? might_fault+0x4c/0x86
  [<c04ef75a>] ? do_filp_open+0x26/0x62
  [<c07f46ba>] ? _raw_spin_unlock+0x22/0x25
  [<c04f9515>] ? alloc_fd+0x137/0x144
  [<c04e3ca9>] ? do_sys_open+0x59/0xd8
  [<c04e3d74>] ? sys_open+0x23/0x2b
  [<c07fa61c>] ? sysenter_do_call+0x12/0x38
Code: ff 86 f4 00 00 00 8b 46 64 e8 10 e7 15 00 8b 45 e4 b9 18 00 00 00 8b 50 58 c7 40 18 00 00 00 00 c7 40 44 00 00 00 00 31 c0 89 d7 <f3> ab 8b 55
EIP: [<c0695f28>] scsi_request_fn+0x42d/0x44a SS:ESP 0068:f5421ed0
---[ end trace a436ef25ffdd40dc ]---


On more heavly-hacked wireless-testing based on 2.6.39-rc5, I see this:

------------[ cut here ]------------
kernel BUG at /home/greearb/git/linux.wireless-testing-ct/fs/bio.c:416!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/block/loop0/uevent
Modules linked in: i915 drm_kms_helper drm i2c_algo_bit video [last unloaded: scsi_wait_scan]

Pid: 0, comm: swapper Not tainted 2.6.39-rc5-wl+ #8 To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M.
EIP: 0060:[<c04d4359>] EFLAGS: 00010246 CPU: 0
EIP is at bio_put+0xc/0x29
EAX: 00000000 EBX: f5758180 ECX: 00000002 EDX: f5758180
ESI: f4f16a00 EDI: f4f16a00 EBP: f5421e68 ESP: f5421e68
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=f5420000 task=c096dfe0 task.ti=c092c000)
Stack:
  f5421e74 c04d181b f4fd3898 f5421e7c c04d4289 f5421eac c06afb4c 00000000
  00000004 f5421e9c 00000000 00000000 00000002 f5758180 f4f1d000 00000000
  f4eb3ed0 f5421ecc c06afcfd f4fd3898 f4f16a00 00000000 f4f1d000 00000008
Call Trace:
  [<c04d181b>] end_bio_bh_io_sync+0x32/0x35
  [<c04d4289>] bio_endio+0x24/0x26
  [<c06afb4c>] dec_pending+0x1cb/0x1d3
  [<c06afcfd>] clone_endio+0x96/0x9e
  [<c04d4289>] bio_endio+0x24/0x26
  [<c056df8c>] req_bio_endio+0x9a/0xa2
  [<c056e0b7>] blk_update_request+0x123/0x2b8
  [<c056e25a>] blk_update_bidi_request+0xe/0x4f
  [<c056ee42>] blk_end_bidi_request+0x18/0x50
  [<c056eeae>] blk_end_request+0xa/0xc
  [<c0638be4>] scsi_io_completion+0x1ba/0x41a
  [<c0638954>] ? scsi_device_unbusy+0x87/0x8d
  [<c06331b8>] scsi_finish_command+0xc0/0xc8
  [<c0638f2b>] scsi_softirq_done+0xd8/0xe0
  [<c057268e>] blk_done_softirq+0x56/0x63
  [<c0435690>] __do_softirq+0x6d/0xfa
  [<c0435623>] ? __local_bh_enable+0x6c/0x6c
  <IRQ>
  [<c0435559>] ? irq_exit+0x32/0x7d
  [<c04039ca>] ? do_IRQ+0x7c/0x90
  [<c0785e69>] ? common_interrupt+0x29/0x30
  [<c05c0f4f>] ? intel_idle+0xa6/0xcf
  [<c06c1027>] ? cpuidle_idle_call+0x6f/0xa4
  [<c040234d>] ? cpu_idle+0x49/0x64
  [<c0767008>] ? rest_init+0x58/0x5a
  [<c09a97d5>] ? start_kernel+0x2ec/0x2f1
  [<c09a90c5>] ? i386_start_kernel+0xc5/0xcc
Code: 55 89 e5 53 89 c3 8b 00 e8 73 44 fd ff 8b 43 04 e8 6b 44 fd ff 89 d8 e8 64 44 fd ff 5b 5d c3 55 89 c2 8b 40 34 89 e5 85 c0 75 04 <0f> 0b eb fe
EIP: [<c04d4359>] bio_put+0xc/0x29 SS:ESP 0068:f5421e68
---[ end trace a6ec255542134cf4 ]---
Kernel panic - not syncing: Fatal exception in interrupt

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

