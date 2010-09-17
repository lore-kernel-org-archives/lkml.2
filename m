Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab0IQS0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:26:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:39024 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753627Ab0IQS0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:26:50 -0400
X-Authenticated: #27760234
X-Provags-ID: V01U2FsdGVkX1+e9fgQMkmeHekQFnZRcUD17w/aKSbbXm4uL73+dc
	dr5wWWaqQ4JxOT
Date: Fri, 17 Sep 2010 20:26:47 +0200
From: Richard Mittendorfer <delist@gmx.net>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Radeon KMS r100 and STR problems
Message-Id: <20100917202647.aa4b6300.delist@gmx.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello *

Radeon KMS and STR on a X32

01:00.0 VGA compatible controller: ATI Technologies Inc Radeon Mobility M6 LY
01:00.0 0300: 1002:4c59
2.6.36-rc4, Debian Squeeze

Most of the time: Backlight comes on, screen remains black, box hangs,
networking in isn't possible (likely due to NM), but  also SysRq
doesn't do. Hardly ever: Vertical lines, messed up screen, but text (as
well as mouse movement when switching to Xorg) "is there". One out of
~10 tries I saw this when suspending at the console (echo mem>/s/p/state).
Rebooting blindly was possible then and the logger was able to capture the 
messages below.


Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: PCI INT A disabled
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: power state changed by ACPI to D3
Sep 17 18:31:52 xth kernel: ata_piix 0000:00:1f.1: PCI INT A disabled
Sep 17 18:31:52 xth kernel: PM: suspend of devices complete after 693.385 msecs
[...]
Sep 17 18:31:52 xth kernel: Back to C!
Sep 17 18:31:52 xth kernel: PM: Restoring platform NVS memory
Sep 17 18:31:52 xth kernel: Extended CMOS year: 2000
Sep 17 18:31:52 xth kernel: ACPI: Waking up from system sleep state S3
Sep 17 18:31:52 xth kernel: pci 0000:00:01.0: restoring config space at offset 0x7 (was 0x2a03030, writing 0x22a03030)
Sep 17 18:31:52 xth kernel: pci 0000:00:01.0: restoring config space at offset 0x3 (was 0x16000, writing 0x18000)
[...]
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: power state changed by ACPI to D0
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: BAR 0: set to [mem 0xe0000000-0xe7ffffff pref] (PCI address [0xe0000000-0xe7ffffff]
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: BAR 1: set to [io  0x3000-0x30ff] (PCI address [0x3000-0x30ff]
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: BAR 2: set to [mem 0xc0100000-0xc010ffff] (PCI address [0xc0100000-0xc010ffff]
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: power state changed by ACPI to D0
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: restoring config space at offset 0x1 (was 0x2b00383, writing 0x2b00387)
[...]
Sep 17 18:31:52 xth kernel: PM: early resume of devices complete after 123.716 msecs
Sep 17 18:31:52 xth kernel: pm_op(): pci_pm_resume+0x0/0x60 returns -16
Sep 17 18:31:52 xth kernel: PM: Device 0000:00:00.0 failed to resume async: error -16
[...]
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: power state changed by ACPI to D0
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: power state changed by ACPI to D0
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: power state changed by ACPI to D0
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: power state changed by ACPI to D0
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
Sep 17 18:31:52 xth kernel: [drm] AGP mode requested: 4
Sep 17 18:31:52 xth kernel: agpgart-intel 0000:00:00.0: AGP 2.0 bridge
Sep 17 18:31:52 xth kernel: agpgart-intel 0000:00:00.0: putting AGP V2 device into 4x mode
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: putting AGP V2 device into 4x mode
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: GTT: 256M 0xD0000000 - 0xDFFFFFFF
[...]
Sep 17 18:31:52 xth kernel: [drm] radeon: ring at 0x00000000D0000000
Sep 17 18:31:52 xth kernel: [drm] ring test succeeded in 1 usecs
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: GPU lockup CP stall for more than 1000msec
Sep 17 18:31:52 xth kernel: ------------[ cut here ]------------
Sep 17 18:31:52 xth kernel: WARNING: at drivers/gpu/drm/radeon/radeon_fence.c:235 radeon_fence_wait+0x1dd/0x281 [radeon]()
Sep 17 18:31:52 xth kernel: Hardware name: 2673M4G
Sep 17 18:31:52 xth kernel: GPU lockup (waiting for 0x00166D34 last fence id 0x00166D33)
Sep 17 18:31:52 xth kernel: Modules linked in: lib80211_crypt_ccmp acpi_cpufreq mperf cpufreq_stats ipv6 radeon ipw2200 thinkpad_acpi e1000 firewire_ohci ttm snd_intel8x0 snd_ac97_codec pcspkr libipw nsc_ircc firewire_core drm_kms_helper cfbcopyarea cfbimgblt cfbfillrect ac97_bus i2c_i801
Sep 17 18:31:52 xth kernel: Pid: 26735, comm: kworker/u:7 Not tainted 2.6.36-rc4 #1
Sep 17 18:31:52 xth kernel: Call Trace:
Sep 17 18:31:52 xth kernel: [<c1022114>] ? warn_slowpath_common+0x6a/0x7b
Sep 17 18:31:52 xth kernel: [<f831ea4b>] ? radeon_fence_wait+0x1dd/0x281 [radeon]
Sep 17 18:31:52 xth kernel: [<c102218b>] ? warn_slowpath_fmt+0x28/0x2c
Sep 17 18:31:52 xth kernel: [<f831ea4b>] ? radeon_fence_wait+0x1dd/0x281 [radeon]
Sep 17 18:31:52 xth kernel: [<c1034efc>] ? autoremove_wake_function+0x0/0x29
Sep 17 18:31:52 xth kernel: [<f83336ec>] ? r100_ib_test+0x126/0x1c2 [radeon]
Sep 17 18:31:52 xth kernel: [<f83337a6>] ? r100_ib_init+0x1e/0x40 [radeon]
Sep 17 18:31:52 xth kernel: [<f83392cc>] ? r100_startup+0x228/0x246 [radeon]
Sep 17 18:31:52 xth kernel: [<f830f9fd>] ? radeon_resume_kms+0x77/0xe6 [radeon]
Sep 17 18:31:52 xth kernel: [<c112ab80>] ? pci_legacy_resume+0x23/0x2c
Sep 17 18:31:52 xth kernel: [<c112ac36>] ? pci_pm_resume+0x0/0x60
Sep 17 18:31:52 xth kernel: [<c11a4613>] ? pm_op+0x8f/0x13f
Sep 17 18:31:52 xth kernel: [<c11a4a07>] ? device_resume+0x3a/0xb3
Sep 17 18:31:52 xth kernel: [<c11a4d55>] ? async_resume+0x13/0x33
Sep 17 18:31:52 xth kernel: [<c103a09f>] ? async_run_entry_fn+0x9f/0x148
Sep 17 18:31:52 xth kernel: [<c10320cf>] ? process_one_work+0x1b3/0x2c5
Sep 17 18:31:52 xth kernel: [<c103a000>] ? async_run_entry_fn+0x0/0x148
Sep 17 18:31:52 xth kernel: [<c10324c3>] ? worker_thread+0x174/0x2e7
Sep 17 18:31:52 xth kernel: [<c103234f>] ? worker_thread+0x0/0x2e7
Sep 17 18:31:52 xth kernel: [<c1034d1a>] ? kthread+0x62/0x67
Sep 17 18:31:52 xth kernel: [<c1034cb8>] ? kthread+0x0/0x67
Sep 17 18:31:52 xth kernel: [<c1002b76>] ? kernel_thread_helper+0x6/0x10
Sep 17 18:31:52 xth kernel: ---[ end trace bf12151d9d6852e3 ]---
Sep 17 18:31:52 xth kernel: Failed to wait GUI idle while programming pipes. Bad things might happen.
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: (r100_asic_reset:2093) RBBM_STATUS=0x80010140
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: (r100_asic_reset:2114) RBBM_STATUS=0x80010140
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: (r100_asic_reset:2122) RBBM_STATUS=0x00000140
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: restoring config space at offset 0x1 (was 0x2b00383, writing 0x2b00387)
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: GPU reset succeed
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: GPU reset succeed
Sep 17 18:31:52 xth kernel: [drm] radeon: ring at 0x00000000D0000000
Sep 17 18:31:52 xth kernel: [drm:r100_ring_test] *ERROR* radeon: ring test failed (sracth(0x15E8)=0xCAFEDEAD)
Sep 17 18:31:52 xth kernel: [drm:r100_cp_init] *ERROR* radeon: cp isn't working (-22).
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: failled initializing CP (-22).
Sep 17 18:31:52 xth kernel: [drm:r100_ib_test] *ERROR* radeon: ib test failed (sracth(0x15E4)=0xCAFEDEAD)
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: failled testing IB (-22).
Sep 17 18:31:52 xth kernel: radeon 0000:01:00.0: failled initializing IB (-22).
Sep 17 18:31:52 xth kernel: PM: resume of devices complete after 6851.341 msecs
[...]
Sep 17 18:31:52 xth kernel: Restarting tasks ... done.
Sep 17 18:31:52 xth kernel: video LNXVIDEO:00: Restoring backlight state
Sep 17 18:31:56 xth acpid: client connected from 26409[0:0]
Sep 17 18:31:56 xth acpid: 1 client rule loaded
Sep 17 18:31:56 xth kernel: [drm:radeon_ib_schedule] *ERROR* radeon: couldn't schedule IB(1).
Sep 17 18:31:56 xth kernel: [drm:radeon_cs_ioctl] *ERROR* Faild to schedule IB !
Sep 17 18:31:56 xth kernel: [drm:radeon_ib_schedule] *ERROR* radeon: couldn't schedule IB(2).
Sep 17 18:31:56 xth kernel: [drm:radeon_cs_ioctl] *ERROR* Faild to schedule IB !
Sep 17 18:31:56 xth kernel: [drm:radeon_ib_schedule] *ERROR* radeon: couldn't schedule IB(3).
Sep 17 18:31:56 xth kernel: [drm:radeon_cs_ioctl] *ERROR* Faild to schedule IB !
Sep 17 18:31:56 xth kernel: [drm:radeon_ib_schedule] *ERROR* radeon: couldn't schedule IB(4).
Sep 17 18:31:56 xth kernel: [drm:radeon_cs_ioctl] *ERROR* Faild to schedule IB !
Sep 17 18:31:56 xth kernel: [drm:radeon_ib_schedule] *ERROR* radeon: couldn't schedule IB(5).
Sep 17 18:31:56 xth kernel: [drm:radeon_cs_ioctl] *ERROR* Faild to schedule IB !
Sep 17 18:31:56 xth kernel: [drm:radeon_ib_schedule] *ERROR* radeon: couldn't schedule IB(6).
Sep 17 18:31:56 xth kernel: [drm:radeon_cs_ioctl] *ERROR* Faild to schedule IB !
Sep 17 18:31:56 xth kernel: [drm:radeon_ib_schedule] *ERROR* radeon: couldn't schedule IB(7).
Sep 17 18:31:56 xth kernel: [drm:radeon_cs_ioctl] *ERROR* Faild to schedule IB !
Sep 17 18:31:56 xth kernel: [drm:radeon_ib_schedule] *ERROR* radeon: couldn't schedule IB(8).
Sep 17 18:31:56 xth kernel: [drm:radeon_cs_ioctl] *ERROR* Faild to schedule IB !
Sep 17 18:31:56 xth kernel: [drm:radeon_ib_schedule] *ERROR* radeon: couldn't schedule IB(9).
Sep 17 18:31:56 xth kernel: [drm:radeon_cs_ioctl] *ERROR* Faild to schedule IB !
Sep 17 18:31:56 xth kernel: [drm:radeon_ib_schedule] *ERROR* radeon: couldn't schedule IB(10).
Sep 17 18:31:56 xth kernel: [drm:radeon_cs_ioctl] *ERROR* Faild to schedule IB !
Sep 17 18:31:57 xth kernel: [drm:radeon_ib_schedule] *ERROR* radeon: couldn't schedule IB(11).
Sep 17 18:31:57 xth kernel: [drm:radeon_cs_ioctl] *ERROR* Faild to schedule IB !
Sep 17 18:31:57 xth kernel: [drm:radeon_ib_schedule] *ERROR* radeon: couldn't schedule IB(12).
Sep 17 18:31:57 xth kernel: [drm:radeon_cs_ioctl] *ERROR* Faild to schedule IB !
Sep 17 18:31:58 xth kernel: [drm:radeon_ib_schedule] *ERROR* radeon: couldn't schedule IB(13).
Sep 17 18:31:58 xth kernel: [drm:radeon_cs_ioctl] *ERROR* Faild to schedule IB !
Sep 17 18:31:58 xth kernel: [drm:radeon_ib_schedule] *ERROR* radeon: couldn't schedule IB(14).
Sep 17 18:31:58 xth kernel: [drm:radeon_cs_ioctl] *ERROR* Faild to schedule IB !
Sep 17 18:31:58 xth kernel: [drm:radeon_ib_schedule] *ERROR* radeon: couldn't schedule IB(15).
Sep 17 18:31:58 xth kernel: [drm:radeon_cs_ioctl] *ERROR* Faild to schedule IB !
Sep 17 18:31:59 xth kernel: [drm:radeon_ib_schedule] *ERROR* radeon: couldn't schedule IB(0).
Sep 17 18:31:59 xth kernel: [drm:radeon_cs_ioctl] *ERROR* Faild to schedule IB !
Sep 17 18:31:59 xth acpid: client 26409[0:0] has disconnected
Sep 17 18:32:15 xth shutdown[26755]: shutting down for system reboot

drm init:
Sep 17 18:32:51 xth kernel: [drm] radeon kernel modesetting enabled.
Sep 17 18:32:51 xth kernel: radeon 0000:01:00.0: power state changed by ACPI to D0
Sep 17 18:32:51 xth kernel: radeon 0000:01:00.0: power state changed by ACPI to D0
Sep 17 18:32:51 xth kernel: radeon 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
Sep 17 18:32:51 xth kernel: [drm] initializing kernel modesetting (RV100 0x1002:0x4C59).
Sep 17 18:32:51 xth kernel: [drm] register mmio base: 0xC0100000
Sep 17 18:32:51 xth kernel: [drm] register mmio size: 65536
Sep 17 18:32:51 xth kernel: [drm] AGP mode requested: 4
Sep 17 18:32:51 xth kernel: agpgart-intel 0000:00:00.0: AGP 2.0 bridge
Sep 17 18:32:51 xth kernel: agpgart-intel 0000:00:00.0: putting AGP V2 device into 4x mode
Sep 17 18:32:51 xth kernel: radeon 0000:01:00.0: putting AGP V2 device into 4x mode
Sep 17 18:32:51 xth kernel: radeon 0000:01:00.0: GTT: 256M 0xD0000000 - 0xDFFFFFFF
Sep 17 18:32:51 xth kernel: radeon 0000:01:00.0: VRAM: 64M 0xE0000000 - 0xE3FFFFFF (16M used)
Sep 17 18:32:51 xth kernel: [drm] radeon: irq initialized.
Sep 17 18:32:51 xth kernel: [drm] Detected VRAM RAM=64M, BAR=128M
Sep 17 18:32:51 xth kernel: [drm] RAM width 32bits DDR
Sep 17 18:32:51 xth kernel: [TTM] Zone  kernel: Available graphics memory: 447686 kiB.
Sep 17 18:32:51 xth kernel: [TTM] Zone highmem: Available graphics memory: 517002 kiB.
Sep 17 18:32:51 xth kernel: [TTM] Initializing pool allocator.
Sep 17 18:32:51 xth kernel: [drm] radeon: 16M of VRAM memory ready
Sep 17 18:32:51 xth kernel: [drm] radeon: 256M of GTT memory ready.
Sep 17 18:32:51 xth kernel: [drm] Loading R100 Microcode
Sep 17 18:32:51 xth kernel: [drm] radeon: ring at 0x00000000D0000000
Sep 17 18:32:51 xth kernel: [drm] ring test succeeded in 1 usecs
Sep 17 18:32:51 xth kernel: [drm] radeon: ib pool ready.
Sep 17 18:32:51 xth kernel: [drm] ib test succeeded in 0 usecs
Sep 17 18:32:51 xth kernel: [drm] Panel ID String: 1024x768                
Sep 17 18:32:51 xth kernel: [drm] Panel Size 1024x768
Sep 17 18:32:51 xth kernel: [drm] Radeon Display Connectors
Sep 17 18:32:51 xth kernel: [drm] Connector 0:
Sep 17 18:32:51 xth kernel: [drm]   VGA
Sep 17 18:32:51 xth kernel: [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
Sep 17 18:32:51 xth kernel: [drm]   Encoders:
Sep 17 18:32:51 xth kernel: [drm]     CRT1: INTERNAL_DAC1
Sep 17 18:32:51 xth kernel: [drm] Connector 1:
Sep 17 18:32:51 xth kernel: [drm]   LVDS
Sep 17 18:32:51 xth kernel: [drm]   Encoders:
Sep 17 18:32:51 xth kernel: [drm]     LCD1: INTERNAL_LVDS
Sep 17 18:32:51 xth kernel: [drm] radeon: power management initialized
Sep 17 18:32:51 xth kernel: [drm] fb mappable at 0xE0040000
Sep 17 18:32:51 xth kernel: [drm] vram apper at 0xE0000000
Sep 17 18:32:51 xth kernel: [drm] size 786432
Sep 17 18:32:51 xth kernel: [drm] fb depth is 8
Sep 17 18:32:51 xth kernel: [drm]    pitch is 1024
Sep 17 18:32:51 xth kernel: Console: switching to colour frame buffer device 128x48
Sep 17 18:32:51 xth kernel: fb0: radeondrmfb frame buffer device
Sep 17 18:32:51 xth kernel: drm: registered panic notifier
Sep 17 18:32:51 xth kernel: [drm] Initialized radeon 2.6.0 20080528 for 0000:01:00.0 on minor 0

If there's something I can do to debug this or further info is
needed, let me know. I don't have a last known working state, and
getting out of suspend halfway alive looks like a matter of luck.
Besides this KMS plays nicely here and performance is good, thx!

Regards, 
ritch
-- 
Richard Mittendorfer <delist@gmx.net>
