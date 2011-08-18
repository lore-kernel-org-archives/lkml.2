Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab1HRFOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 01:14:40 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61523 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab1HRFOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 01:14:39 -0400
Date: Thu, 18 Aug 2011 13:14:15 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: WARNING: at lib/iomap.c:43 0xffffffffa00ac458()
Message-ID: <Pine.LNX.4.64.1108181259020.4357@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Got several warning here and it's the iwlagn that brought down the system. 
Running linux-3.1.0-rc2 commit at 338d0f0a6fbc82407864606f5b64b75aeb3c70f2

This problem surfaced after 53d1e658df6e26d62500410719aaee2b82067c03.

Before that, everything is very stable.


------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:455 0xffffffff810f5ac4()
Hardware name: 5413FGA
sysfs: cannot create duplicate filename 
'/devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1/intel_backlight'
Modules linked in: i915(+) drm_kms_helper
Pid: 2016, comm: modprobe Not tainted 3.1.0-rc2 #6
Call Trace:
[<ffffffff8103454c>] ? 0xffffffff8103454c
[<ffffffff810345ff>] ? 0xffffffff810345ff
[<ffffffff810f5ac4>] ? 0xffffffff810f5ac4
[<ffffffff810f634f>] ? 0xffffffff810f634f
[<ffffffff81044ca7>] ? 0xffffffff81044ca7
[<ffffffff810f6423>] ? 0xffffffff810f6423
[<ffffffff8102dbbd>] ? 0xffffffff8102dbbd
[<ffffffff811dc525>] ? 0xffffffff811dc525
[<ffffffff811dc76e>] ? 0xffffffff811dc76e
[<ffffffff8102dbbd>] ? 0xffffffff8102dbbd
[<ffffffff812893ad>] ? 0xffffffff812893ad
[<ffffffff8102be75>] ? 0xffffffff8102be75
[<ffffffff8102dbbd>] ? 0xffffffff8102dbbd
[<ffffffff81290c76>] ? 0xffffffff81290c76
[<ffffffff81215181>] ? 0xffffffff81215181
[<ffffffffa0031e17>] ? 0xffffffffa0031e17
[<ffffffffa0021f2d>] ? 0xffffffffa0021f2d
[<ffffffffa0009185>] ? 0xffffffffa0009185
[<ffffffff8127a87b>] ? 0xffffffff8127a87b
[<ffffffff8127c415>] ? 0xffffffff8127c415
[<ffffffff814d065c>] ? 0xffffffff814d065c
[<ffffffff811f767e>] ? 0xffffffff811f767e
[<ffffffff811f8448>] ? 0xffffffff811f8448
[<ffffffff8128b110>] ? 0xffffffff8128b110
[<ffffffff8128b251>] ? 0xffffffff8128b251
[<ffffffff8128b330>] ? 0xffffffff8128b330
[<ffffffff8128b2e1>] ? 0xffffffff8128b2e1
[<ffffffff8128aabd>] ? 0xffffffff8128aabd
[<ffffffff8128a46b>] ? 0xffffffff8128a46b
[<ffffffff8128b865>] ? 0xffffffff8128b865
[<ffffffff811f869a>] ? 0xffffffff811f869a
[<ffffffffa004c000>] ? 0xffffffffa004c000
[<ffffffffa004c000>] ? 0xffffffffa004c000
[<ffffffff81000208>] ? 0xffffffff81000208
[<ffffffff8105e445>] ? 0xffffffff8105e445
[<ffffffff814d0fd2>] ? 0xffffffff814d0fd2
---[ end trace 7d200175acf13c73 ]---
kobject_add_internal failed for intel_backlight with -EEXIST, don't try to 
register things with the same name in the same directory.
Pid: 2016, comm: modprobe Tainted: G        W   3.1.0-rc2 #6
Call Trace:
[<ffffffff811dc5b4>] ? 0xffffffff811dc5b4
[<ffffffff811dc76e>] ? 0xffffffff811dc76e
[<ffffffff8102dbbd>] ? 0xffffffff8102dbbd
[<ffffffff812893ad>] ? 0xffffffff812893ad
[<ffffffff8102be75>] ? 0xffffffff8102be75
[<ffffffff8102dbbd>] ? 0xffffffff8102dbbd
[<ffffffff81290c76>] ? 0xffffffff81290c76
[<ffffffff81215181>] ? 0xffffffff81215181
[<ffffffffa0031e17>] ? 0xffffffffa0031e17
[<ffffffffa0021f2d>] ? 0xffffffffa0021f2d
[<ffffffffa0009185>] ? 0xffffffffa0009185
[<ffffffff8127a87b>] ? 0xffffffff8127a87b
[<ffffffff8127c415>] ? 0xffffffff8127c415
[<ffffffff814d065c>] ? 0xffffffff814d065c
[<ffffffff811f767e>] ? 0xffffffff811f767e
[<ffffffff811f8448>] ? 0xffffffff811f8448
[<ffffffff8128b110>] ? 0xffffffff8128b110
[<ffffffff8128b251>] ? 0xffffffff8128b251
[<ffffffff8128b330>] ? 0xffffffff8128b330
[<ffffffff8128b2e1>] ? 0xffffffff8128b2e1
[<ffffffff8128aabd>] ? 0xffffffff8128aabd
[<ffffffff8128a46b>] ? 0xffffffff8128a46b
[<ffffffff8128b865>] ? 0xffffffff8128b865
[<ffffffff811f869a>] ? 0xffffffff811f869a
[<ffffffffa004c000>] ? 0xffffffffa004c000
[<ffffffffa004c000>] ? 0xffffffffa004c000
[<ffffffff81000208>] ? 0xffffffff81000208
[<ffffffff8105e445>] ? 0xffffffff8105e445
[<ffffffff814d0fd2>] ? 0xffffffff814d0fd2
[drm:intel_panel_setup_backlight] *ERROR* Failed to register backlight: 
-17
fbcon: inteldrmfb (fb0) is primary device
Console: switching to colour frame buffer device 180x56
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
acpi device:02: registered as cooling_device4
input: Video Bus as 
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input6
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
cfg80211: Calling CRDA to update world regulatory domain
Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
Copyright(c) 2003-2011 Intel Corporation
iwlagn 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
iwlagn 0000:02:00.0: setting latency timer to 64
iwlagn 0000:02:00.0: pci_resource_len = 0x00002000
iwlagn 0000:02:00.0: pci_resource_base = ffffc90001ce8000
iwlagn 0000:02:00.0: HW Revision ID = 0x35
iwlagn 0000:02:00.0: irq 43 for MSI/MSI-X
iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, 
REV=0x74
iwlagn 0000:02:00.0: L1 Disabled; Enabling L0S
iwlagn 0000:02:00.0: device EEPROM VER=0x436, CALIB=0x6
iwlagn 0000:02:00.0: Device SKU: 0X1f0
iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:02:00.0: loaded firmware version 9.221.4.1 build 25532
Registered led device: phy0-led
ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
iwlagn 0000:02:00.0: L1 Disabled; Enabling L0S
iwlagn 0000:02:00.0: Radio type=0x1-0x3-0x1
iwlagn 0000:02:00.0: L1 Disabled; Enabling L0S
iwlagn 0000:02:00.0: Radio type=0x1-0x3-0x1
wlan0: authenticate with 00:18:39:a3:83:94 (try 1)
wlan0: authenticated
wlan0: waiting for beacon from 00:18:39:a3:83:94
wlan0: beacon received
wlan0: associate with 00:18:39:a3:83:94 (try 1)
wlan0: RX AssocResp from 00:18:39:a3:83:94 (capab=0x471 status=0 aid=2)
wlan0: associated
iwlagn 0000:02:00.0: Queue 2 stuck for 2000 ms.
iwlagn 0000:02:00.0: On demand firmware reload
ieee80211 phy0: Hardware restart was requested
iwlagn 0000:02:00.0: L1 Disabled; Enabling L0S
iwlagn 0000:02:00.0: Radio type=0x1-0x3-0x1
wlan0: deauthenticating from 00:18:39:a3:83:94 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
iwlagn 0000:02:00.0: Error: Response NULL in 'REPLY_ADD_STA'
iwlagn 0000:02:00.0: Adding station ff:ff:ff:ff:ff:ff failed.
------------[ cut here ]------------
WARNING: at lib/iomap.c:43 0xffffffffa00ac458()
Hardware name: 5413FGA
Bad IO access at port 0x0 ()
Modules linked in: iwlagn(-) mac80211 cfg80211 i915 drm_kms_helper
Pid: 2889, comm: modprobe Tainted: G        W   3.1.0-rc2 #6
Call Trace:
[<ffffffff8103454c>] ? 0xffffffff8103454c
[<ffffffff810345ff>] ? 0xffffffff810345ff
[<ffffffffa00ac458>] ? 0xffffffffa00ac458
[<ffffffff811f82ed>] ? 0xffffffff811f82ed
[<ffffffff8128af7c>] ? 0xffffffff8128af7c
[<ffffffff8128b041>] ? 0xffffffff8128b041
[<ffffffff8128a36f>] ? 0xffffffff8128a36f
[<ffffffff811f85eb>] ? 0xffffffff811f85eb
[<ffffffffa00ac2a1>] ? 0xffffffffa00ac2a1
[<ffffffff8105e744>] ? 0xffffffff8105e744
[<ffffffff8109240c>] ? 0xffffffff8109240c
[<ffffffff814d0b35>] ? 0xffffffff814d0b35
[<ffffffff814d0fd2>] ? 0xffffffff814d0fd2
---[ end trace 7d200175acf13c74 ]---
Trying to free nonexistent resource <0000000000000021-00000000017cd000>
Trying to free nonexistent resource <ffff880228481000-ffff88022eb38320>
Trying to free nonexistent resource <ffff88022eb38fc0-ffffffffa006b108>
general protection fault: 0000 [#1] PREEMPT SMP
CPU 1
Modules linked in: iwlagn(-) mac80211 cfg80211 i915 drm_kms_helper

Pid: 2889, comm: modprobe Tainted: G        W   3.1.0-rc2 #6 LENOVO 
5413FGA/5413FGA
RIP: 0010:[<ffffffff8128aec0>]  [<ffffffff8128aec0>] 0xffffffff8128aec0
RSP: 0018:ffff880227e77e08  EFLAGS: 00010286
RAX: 8000000000000000 RBX: ffff88022eb38950 RCX: ffff88022fd99c20
RDX: ffff88022fd900a0 RSI: 0000000000000000 RDI: ffff88022eb38950
RBP: 0000000000000000 R08: 0000000000000002 R09: ffff88022eb382e0
R10: 00007fffd6a978f0 R11: 000000000000bd6b R12: ffff88022eb38300
R13: 00007fffd6a978f0 R14: 0000000000000001 R15: 00000000011404a0
FS:  00007f7fac94b700(0000) GS:ffff88023bc80000(0000) 
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000006b4c24 CR3: 0000000228587000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 2889, threadinfo ffff880227e76000, task 
ffff880231c6c800)
Stack:
ffff88022eb382e0 ffff88022eb382e0 ffff88022eb382c0 ffffffffa00ac47c
ffff8802326e1090 ffffffffa00b4bb0 ffff8802326e1000 ffffffff811f82ed
ffff8802326e1090 ffffffffa00b4c10 ffff8802326e10f0 ffffffff8128af7c
Call Trace:
[<ffffffffa00ac47c>] ? 0xffffffffa00ac47c
[<ffffffff811f82ed>] ? 0xffffffff811f82ed
[<ffffffff8128af7c>] ? 0xffffffff8128af7c
[<ffffffff8128b041>] ? 0xffffffff8128b041
[<ffffffff8128a36f>] ? 0xffffffff8128a36f
[<ffffffff811f85eb>] ? 0xffffffff811f85eb
[<ffffffffa00ac2a1>] ? 0xffffffffa00ac2a1
[<ffffffff8105e744>] ? 0xffffffff8105e744
[<ffffffff8109240c>] ? 0xffffffff8109240c
[<ffffffff814d0b35>] ? 0xffffffff814d0b35
[<ffffffff814d0fd2>] ? 0xffffffff814d0fd2
Code: 48 8b 80 88 00 00 00 c3 31 c0 c3 55 48 89 f5 53 48 89 fb 48 83 ec 08 
48 83 7f 08 00 75 09 e8 60 e0 ff ff 85 c0 75 0d 48 8b 43 08
RIP  [<ffffffff8128aec0>] 0xffffffff8128aec0
RSP <ffff880227e77e08>
---[ end trace 7d200175acf13c75 ]---


Thanks,
Jeff





