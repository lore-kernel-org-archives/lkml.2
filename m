Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab0DZSnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 14:43:37 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:44162 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751280Ab0DZSng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 14:43:36 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-pm@lists.linux-foundation.org
Subject: Invalid opcode on resume from STR on Asus P4P800-VM
Date: Mon, 26 Apr 2010 20:43:23 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004262043.24814.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I'm trying to debug oops on resume from suspend-to-RAM on Asus P4P800-VM
mainboard. It crashes with invalid opcode (see below). The kernel is 
2.6.32-trunk from Debian but the same problem is present with vanilla
kernels - both newer and older (but screen remains blank most of the time,
only keyboard LEDs blink indicating an oops).

What can cause this problem?

     8.000339  invalid opcode: 0000 [#1] SMP
     8.003529  last sysfs file: /sys/power/state
     8.004265  Modules linked in: sco bridge stp bnep l2cacp crc16 bluetooth rfkill loop i2c_i801 snd_intel8x0 snd_ac97_codec shpchp ac97_bus 
parport_pc parport
rng_core pci_hotplug snd_pcsp snd_pcm snd_timer snd soundcore psmouse snd_page_alloc serio_raw evdev processor ext3 jbd mbcache ide_gd_mod 
ata_generic libata scsi_mod
ide_pci_generic i915 drm_kms_helper uhci_hcd drm i2c_algo_bit piix i2c_core ehci_hcd intel_agp e100 video ide_core mii floppy agpgart output 
usbcore nls_base button
thermal fan thermal_sys [last unloaded: scsi_wait_scan]
[  148.004265]
[  148.004265] Pid: 0, comm: swapper Not tainted (2.6.32-trunk-686 #1) To Be Filled By O.E.M.
[  148.004265] EIP: 0060:[<c1008ff3>] EFLAGS: 00010086 CPU: 0
[  148.004265] EIP is at mwait_idle+0x4e/0x6c
[  148.004265] EAX: c1336008 EBX: c1336008 ECX: 00000000 EDX: 00000000
[  148.004265] ESI: 00000000 EDI: c1339000 EBP: 01642003 ESP: c1337fd0
[  148.004265]  DS: 0068 ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  148.004265] Process swapper (pid: 0, ti=c1336000 task=c1364ba0 task.ti=c1336000)
[  148.004265] Stack:
[  148.004265] c1396004 c1002388 4176f186 d147e8ee c13c61e8 00099800 c1399800 a05e3121
[  148.004265] <0> 46258193 c13c61e8 00010800 00000000
[  148.004265] Call Trace:
[  148.004265]  [<c1002388>] ? cpu_idle+0x89/0xa5
[  148.004265]  [<c1399800>] ? start_kernel+0x30c/0x311
[  148.004265] Code: 8b 15 50 e9 3e c1 f6 44 10 27 02 74 0f 89 e2 81 e2 00 e0 ff ff 8d 42 08 0f ae 7a 08 89 e3 31 c9 81 e3 00 e0 ff ff 89 ca 
8d 43 08 <0f> 01 c8
 0f ae f0 89 f6 f6 43 08 08 75 08 89 c8 fb 0f 01 c9 eb
[  148.004265] EIP: [<c1008ff3>] mwait_idle+0x4e/0x6c SS:ESP 0068:c1337fd0
[  148.004265] ---[ end trace b2f32b48d4fa5394 ]---
[  148.004265] Kernel panic - not syncing: Attempted to kill the idle task!
[  148.004265] Pid: 0, comm: swapper Tainted: G      D    2.6.32-trunk-686 #1
[  148.004265] Call Trace:
[  148.004265]  [<c1259284>] ? panic+0x38/0xe4
[  148.004265]  [<c1033805>] ? do_exit+0x5a/0x5c6
[  148.004265]  [<c1259ee3>] ? printk+0xe/0x18
[  148.004265]  [<c100509d>] ? oops_end+0x98/0x9d
[  148.004265]  [<c100424b>] ? do_invalid_op+0x0/0x75
[  148.004265]  [<c10042b7>] ? do_invalid_op+0x6c/0x75
[  148.004265]  [<c1008ff3>] ? mwait_idle+0x4e/0x6c
[  148.004265]  [<c1001f10>] ? __switch_to+0xcf/0x141
[  148.004265]  [<c1046e9b>] ? hrtimer_get_next_event+0x8c/0xa0
[  148.004265]  [<c103b9da>] ? get_next_timer_interrupt+0x16f/0x1da
[  148.004265]  [<c1007fd1>] ? sched_clock+0x5/0x7
[  148.004265]  [<c104829f>] ? sched_clock_local+0x15/0x11b
[  148.004265]  [<c125af7b>] ? error_code+0x73/0x78
[  148.004265]  [<c1008ff3>] ? mwait_idle+0x4e/0x6c
[  148.004265]  [<c1002388>] ? cpu_idle+0x89/0xa5
[  148.004265]  [<c1399800>] ? start_kernel+0x30c/0x311
[  148.004265] [drm:drm_fb_helper_panic] *ERROR* panic occured, switching back to text console


-- 
Ondrej Zary
