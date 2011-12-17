Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab1LQVgw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 16:36:52 -0500
Received: from mail2.charite.de ([141.42.206.200]:52670 "EHLO mail2.charite.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab1LQVgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 16:36:49 -0500
Date: Sat, 17 Dec 2011 22:36:45 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: oops during modprobe (3.2.0-rc6+)
Message-ID: <20111217213645.GQ12099@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Todya I pulled 3.2.0-rc6+ from git and built it for my machine. After
booting I found this in dmesg:

...
[    6.322632] bnx2: Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v2.1.11 (July 20, 2011)
[    6.324608] hpwdt 0000:01:04.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    6.324680] hpwdt: New timer passed in is 30 seconds.
[    6.324725] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[    6.324798] BUG: unable to handle kernel paging request at c00f0000
[    6.324917] IP: [<c00f0000>] 0xc00effff
[    6.325002] *pdpt = 00000000013b1001 *pde = 00000000013de067 *pte = 80000000000f0163 
[    6.325002] Oops: 0011 [#1] SMP 
[    6.325002] Modules linked in: hpwdt(+) bnx2(+) container psmouse thermal button processor
[    6.325002] 
[    6.325002] Pid: 668, comm: modprobe Not tainted 3.2.0-rc6+ #16 HP ProLiant DL360 G5
[    6.325002] EIP: 0060:[<c00f0000>] EFLAGS: 00010286 CPU: 3
[    6.325002] EIP is at 0xc00f0000
[    6.325905] EAX: 55524324 EBX: 00000000 ECX: 00000000 EDX: 00000000
[    6.325905] ESI: 00000000 EDI: 00000000 EBP: f00cddd8 ESP: f00cdda8
[    6.325905]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    6.325905] Process modprobe (pid: 668, ti=f00cc000 task=f0028000 task.ti=f00cc000)
[    6.325905] Stack:
[    6.325905]  f8432020 00000060 c00e007b 00000286 c00ffee0 ffffffed f00cddd8 f00cddd8
[    6.325905]  c00f0000 00000001 00000000 c00f0000 f2cdbc00 f8432558 f8434100 c00f0000
[    6.325905]  f2c30564 ffffffff f8434030 000f0000 000f0000 f2d777e0 c0100000 c00f0000
[    6.325905] Call Trace:
[    6.325905]  [<f8432020>] ? asminline_call+0x20/0x46 [hpwdt]
[    6.325905]  [<f8432558>] ? hpwdt_init_one+0x1a7/0x3c0 [hpwdt]
[    6.325905]  [<c115dc36>] ? pci_device_probe+0x47/0x68
[    6.325905]  [<c11aa0a7>] ? driver_probe_device+0x4a/0x13a
[    6.325905]  [<c115db04>] ? pci_match_device+0xf/0x8a
[    6.325905]  [<c11aa1f9>] ? __driver_attach+0x62/0x64
[    6.325905]  [<c11aa197>] ? driver_probe_device+0x13a/0x13a
[    6.325905]  [<c11a9543>] ? bus_for_each_dev+0x3e/0x62
[    6.325905]  [<c115dba2>] ? pci_dev_put+0xd/0xd
[    6.325905]  [<c11a9e69>] ? driver_attach+0x19/0x1e
[    6.325905]  [<c11aa197>] ? driver_probe_device+0x13a/0x13a
[    6.325905]  [<c11a9beb>] ? bus_add_driver+0x17d/0x24d
[    6.325905]  [<c115dba2>] ? pci_dev_put+0xd/0xd
[    6.325905]  [<c11aa3d9>] ? driver_register+0x57/0xec
[    6.325905]  [<c115dfef>] ? __pci_register_driver+0x31/0x92
[    6.325905]  [<c1001027>] ? do_one_initcall+0x27/0x150
[    6.325905]  [<c101c97e>] ? set_memory_nx+0x57/0x5b
[    6.325905]  [<f8410000>] ? 0xf840ffff
[    6.325905]  [<c1054416>] ? sys_init_module+0xdff/0x1a14
[    6.325905]  [<c126f717>] ? sysenter_do_call+0x12/0x26
[    6.325905] Code: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
[    6.329004]  90 80 fc d8 75 0d e9 da 06 00 00 69 04 00 00 ad 04 00 00 9c 
[    6.329004] EIP: [<c00f0000>] 0xc00f0000 SS:ESP 0068:f00cdda8
[    6.329004] CR2: 00000000c00f0000
[    6.329004] ---[ end trace 239ff8fe19067483 ]---
[    6.443034] bnx2 0000:03:00.0: BAR 0: set to [mem 0xf8000000-0xf9ffffff 64bit] (PCI address [0xf8000000-0xf9ffffff])
[    6.443123] bnx2 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    6.773259] bnx2 0000:03:00.0: eth0: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X 64-bit 133MHz found at mem f8000000, IRQ 18, node addr 00:1e:0b:5f:f9:36


-- 
Ralf Hildebrandt
  Geschäftsbereich IT | Abteilung Netzwerk
  Charité - Universitätsmedizin Berlin
  Campus Benjamin Franklin
  Hindenburgdamm 30 | D-12203 Berlin
  Tel. +49 30 450 570 155 | Fax: +49 30 450 570 962
  ralf.hildebrandt@charite.de | http://www.charite.de
	    
