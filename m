Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1LaLhp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 06:37:45 -0500
Received: from mail2.charite.de ([141.42.206.200]:38707 "EHLO mail2.charite.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379Ab1LaLhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 06:37:42 -0500
Date: Sat, 31 Dec 2011 12:37:40 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: 3.2.0-rc7+: WARNING: at arch/x86/mm/pageattr.c:877
 change_page_attr_set_clr+0x243/0x354()
Message-ID: <20111231113740.GG14070@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From today's git pull:

...
[    6.369829] ACPI: Power Button [PWRF]
[    6.381614] hpwdt 0000:01:04.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    6.381700] hpwdt: New timer passed in is 30 seconds.
[    6.381855] ------------[ cut here ]------------
[    6.381914] WARNING: at arch/x86/mm/pageattr.c:877 change_page_attr_set_clr+0x243/0x354()
[    6.381991] Hardware name: ProLiant DL360 G5
[    6.382063] Modules linked in: thermal(+) hpwdt(+) psmouse(+) container
[    6.382220] thermal LNXTHERM:00: registered as thermal_zone0
[    6.382222] ACPI: Thermal Zone [THM0] (8 C)
[    6.382386]  button processor
[    6.382503] Pid: 676, comm: modprobe Not tainted 3.2.0-rc7+ #18
[    6.382559] Call Trace:
[    6.382622]  [<c102babc>] ? warn_slowpath_common+0x6c/0x95
[    6.382678]  [<c101c7c5>] ? change_page_attr_set_clr+0x243/0x354
[    6.382735]  [<c101c7c5>] ? change_page_attr_set_clr+0x243/0x354
[    6.382793]  [<c102bb00>] ? warn_slowpath_null+0x1b/0x1f
[    6.382849]  [<c101c7c5>] ? change_page_attr_set_clr+0x243/0x354
[    6.382906]  [<c101b7b5>] ? __ioremap_caller+0x365/0x45c
[    6.382961]  [<c101c92d>] ? set_memory_x+0x57/0x5b
[    6.383022]  [<f842c5b8>] ? hpwdt_init_one+0x207/0x3c2 [hpwdt]
[    6.383081]  [<c115dd06>] ? pci_device_probe+0x47/0x68
[    6.383140]  [<c11aa177>] ? driver_probe_device+0x4a/0x13a
[    6.383207]  [<c115dbd4>] ? pci_match_device+0xf/0x8a
[    6.383262]  [<c11aa2c9>] ? __driver_attach+0x62/0x64
[    6.383318]  [<c11aa267>] ? driver_probe_device+0x13a/0x13a
[    6.383374]  [<c11a9613>] ? bus_for_each_dev+0x3e/0x62
[    6.383430]  [<c115dc72>] ? pci_dev_put+0xd/0xd
[    6.383484]  [<c11a9f39>] ? driver_attach+0x19/0x1e
[    6.383539]  [<c11aa267>] ? driver_probe_device+0x13a/0x13a
[    6.383595]  [<c11a9cbb>] ? bus_add_driver+0x17d/0x24d
[    6.383650]  [<c115dc72>] ? pci_dev_put+0xd/0xd
[    6.383705]  [<c11aa4a9>] ? driver_register+0x57/0xec
[    6.383760]  [<c115e0bf>] ? __pci_register_driver+0x31/0x92
[    6.383818]  [<c1001027>] ? do_one_initcall+0x27/0x150
[    6.383875]  [<c101c99e>] ? set_memory_nx+0x57/0x5b
[    6.383931]  [<f8431000>] ? 0xf8430fff
[    6.383986]  [<c1054446>] ? sys_init_module+0xdff/0x1a14
[    6.384051]  [<c126fa97>] ? sysenter_do_call+0x12/0x26
[    6.384108] ---[ end trace d99102c5cb722e75 ]---
[    6.384170] hpwdt: CRU Base Address:   0xfff69800
[    6.384171] hpwdt: CRU Offset Address: 0x0
[    6.384172] hpwdt: CRU Length:         0x8000
[    6.384173] hpwdt: CRU Mapped Address: f842e0dc
[    6.384176] hpwdt 0000:01:04.0: HP Watchdog Timer Driver: NMI decoding initialized, allow kernel dump: OFF (default = 0/OFF), priority: LAST (default = 0/LAST).
[    6.384351] hpwdt 0000:01:04.0: HP Watchdog Timer Driver: 1.3.0, timer margin: 30 seconds (nowayout=0).

-- 
Ralf Hildebrandt
  Geschäftsbereich IT | Abteilung Netzwerk
  Charité - Universitätsmedizin Berlin
  Campus Benjamin Franklin
  Hindenburgdamm 30 | D-12203 Berlin
  Tel. +49 30 450 570 155 | Fax: +49 30 450 570 962
  ralf.hildebrandt@charite.de | http://www.charite.de
	    
