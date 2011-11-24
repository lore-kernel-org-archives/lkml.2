Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab1KXOfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 09:35:51 -0500
Received: from dwdmx5.dwd.de ([141.38.3.242]:45192 "EHLO dwdmx5.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263Ab1KXOft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 09:35:49 -0500
X-Greylist: delayed 640 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Nov 2011 09:35:49 EST
Date: Thu, 24 Nov 2011 14:02:35 +0000 (GMT)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@diagnostix.dwd.de
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Kernel error (drm kms?) message while booting
Message-ID: <alpine.LRH.2.02.1111241351190.21084@diagnostix.dwd.de>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I see the following error while the system boots with 3.1.3-rc1 and also
3.1.2. Any idea what is the cause of this? I can send full details of
setup and dmesg if required.

Regards,
Holger


udev: starting version 147
udevd (189): /proc/189/oom_adj is deprecated, please use /proc/189/oom_score_adj instead.
[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
radeon 0000:01:03.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[drm] initializing kernel modesetting (RV100 0x1002:0x515E 0x103C:0x31FB).
[drm] register mmio base: 0xF1CF0000
[drm] register mmio size: 65536
radeon 0000:01:03.0: VRAM: 128M 0x00000000E8000000 - 0x00000000EFFFFFFF (64M used)
radeon 0000:01:03.0: GTT: 512M 0x00000000C8000000 - 0x00000000E7FFFFFF
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
[drm] radeon: irq initialized.
[drm] Detected VRAM RAM=128M, BAR=128M
[drm] RAM width 16bits DDR
[TTM] Zone  kernel: Available graphics memory: 55836228 kiB.
[TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[TTM] Initializing pool allocator.
[drm] radeon: 64M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] GART: num cpu pages 131072, num gpu pages 131072
NMI: IOCK error (debug interrupt?) for reason 71 on CPU 0.
CPU 0 
Modules linked in: radeon(+) ttm drm_kms_helper hwmon

Pid: 0, comm: swapper Not tainted 3.1.3 #13 HP ProLiant DL380 G7
RIP: 0010:[<ffffffff81074f50>]  [<ffffffff81074f50>] ktime_get_ts+0xe0/0xe0
RSP: 0018:ffff880d9fc03f20  EFLAGS: 00000002
RAX: 0000000000000000 RBX: ffff880d9fc0cc80 RCX: ffffffff81a51020
RDX: ffff880d9fc00000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff880d9fc03f58 R08: 0000000000000000 R09: 00000000000000c8
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 000000000000cc80 R14: ffffffff81a01dc8 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff880d9fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007ffcc89b4400 CR3: 0000000001a49000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff81a00000, task ffffffff81a51020)
Stack:
  ffffffff8107c19c 000000478f0e1000 0000000000000092 ffffffffffffffd6
  0000000000000000 0000000000000029 0000000000000a7b ffff880d9fc03f78
  ffffffff8104f4ac ffff880d9fc03f78 0000000000000000 ffff880d9fc03fa8
Call Trace:
  <IRQ>
  [<ffffffff8107c19c>] ? tick_check_idle+0x4c/0xc0
  [<ffffffff8104f4ac>] irq_enter+0x6c/0x80
  [<ffffffff81501ff6>] do_IRQ+0x46/0xe0
  [<ffffffff814ff62b>] common_interrupt+0x6b/0x6b
  <EOI>
  [<ffffffff81299d6a>] ? intel_idle+0xba/0x110
  [<ffffffff81299d4d>] ? intel_idle+0x9d/0x110
  [<ffffffff81402ac2>] cpuidle_idle_call+0xe2/0x210
  [<ffffffff810018f5>] cpu_idle+0xc5/0x120
  [<ffffffff814e7375>] rest_init+0x75/0x80
  [<ffffffff81b04c8e>] start_kernel+0x3b9/0x3c4
  [<ffffffff81b04321>] x86_64_start_reservations+0x131/0x135
  [<ffffffff81b04412>] x86_64_start_kernel+0xed/0xf4
Code: 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d 
usb 6-1: new full speed USB device number 2 using uhci_hcd
f8 c9 c3 be 14 01 00 00 48 c7 c7 a1 b1 7c 81 e8 ec 3b fd ff e9 59 ff ff ff f3 90 e9 52 ff ff ff
  48 89 e5 48 83 ec 20 48 89 1c 24 4c 89 64 24 08 4c 89 6c 24 
radeon 0000:01:03.0: WB enabled
[drm] Loading R100 Microcode
DRHD: handling fault status reg 2
DMAR:[DMA Read] Request device [00:1e.0] fault addr 3000 
DMAR:[fault reason 06] PTE Read access is not set
[drm] radeon: ring at 0x00000000C8001000
[drm] ring test succeeded in 3 usecs
[drm] radeon: ib pool ready.
[drm] ib test succeeded in 0 usecs
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   VGA
[drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[drm]   Encoders:
[drm]     CRT1: INTERNAL_DAC1
[drm] Connector 1:
[drm]   VGA
[drm]   DDC: 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c
[drm]   Encoders:
[drm]     CRT2: INTERNAL_DAC2
[drm] Radeon display connector VGA-1: No monitor connected or invalid EDID
input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
[drm] Radeon display connector VGA-2: Found valid EDID


