Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab2BZNfM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 08:35:12 -0500
Received: from mail2.charite.de ([141.42.206.200]:47681 "EHLO mail2.charite.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab2BZNfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 08:35:09 -0500
X-Greylist: delayed 509 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Feb 2012 08:35:09 EST
Date: Sun, 26 Feb 2012 14:26:38 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: [3.2.7] WARNING: at arch/x86/mm/pageattr.c:877
 change_page_attr_set_clr+0x243/0x354()
Message-ID: <20120226132638.GA20273@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux mail.charite.de 3.2.7 #1 SMP Sun Feb 26 14:11:52 CET 2012 i686 GNU/Linux

With 3.2.7 I'm getting:

...
[    6.451075] bnx2: Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v2.1.11 (July 20, 2011)
[    6.452111] hpwdt 0000:01:04.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    6.452176] hpwdt: New timer passed in is 30 seconds.
[    6.452336] ------------[ cut here ]------------
[    6.452395] WARNING: at arch/x86/mm/pageattr.c:877 change_page_attr_set_clr+0x243/0x354()
[    6.452468] Hardware name: ProLiant DL360 G5
[    6.452521] Modules linked in: hpwdt(+) bnx2(+) psmouse intel_rng(-) rng_core container thermal button processor
[    6.452914] Pid: 695, comm: modprobe Not tainted 3.2.7 #1
[    6.452969] Call Trace:
[    6.453032]  [<c102c0fc>] ? warn_slowpath_common+0x6c/0x95
[    6.453088]  [<c101ce15>] ? change_page_attr_set_clr+0x243/0x354
[    6.453145]  [<c101ce15>] ? change_page_attr_set_clr+0x243/0x354
[    6.453202]  [<c102c140>] ? warn_slowpath_null+0x1b/0x1f
[    6.453257]  [<c101ce15>] ? change_page_attr_set_clr+0x243/0x354
[    6.453314]  [<c101be05>] ? __ioremap_caller+0x365/0x45c
[    6.453369]  [<c101cf7d>] ? set_memory_x+0x57/0x5b
[    6.453425]  [<f842f5b8>] ? hpwdt_init_one+0x207/0x3c2 [hpwdt]
[    6.453484]  [<c115eb86>] ? pci_device_probe+0x47/0x68
[    6.453541]  [<c11ac197>] ? driver_probe_device+0x4a/0x13a
[    6.453597]  [<c115ea54>] ? pci_match_device+0xf/0x8a
[    6.453652]  [<c11ac2e9>] ? __driver_attach+0x62/0x64
[    6.453707]  [<c11ac287>] ? driver_probe_device+0x13a/0x13a
[    6.453763]  [<c11ab633>] ? bus_for_each_dev+0x3e/0x62
[    6.453818]  [<c115eaf2>] ? pci_dev_put+0xd/0xd
[    6.453872]  [<c11abf59>] ? driver_attach+0x19/0x1e
[    6.453927]  [<c11ac287>] ? driver_probe_device+0x13a/0x13a
[    6.453983]  [<c11abcdb>] ? bus_add_driver+0x17d/0x24d
[    6.454042]  [<c115eaf2>] ? pci_dev_put+0xd/0xd
[    6.454096]  [<c11ac4c9>] ? driver_register+0x57/0xec
[    6.454151]  [<c115ef3f>] ? __pci_register_driver+0x31/0x92
[    6.454207]  [<c1001027>] ? do_one_initcall+0x27/0x150
[    6.454262]  [<c101cfee>] ? set_memory_nx+0x57/0x5b
[    6.454316]  [<f8434000>] ? 0xf8433fff
[    6.454370]  [<c1055076>] ? sys_init_module+0xdff/0x1a14
[    6.454428]  [<c1275317>] ? sysenter_do_call+0x12/0x26
[    6.454483] ---[ end trace eda5d4063781bdf2 ]---
[    6.454543] hpwdt: CRU Base Address:   0xfff69800
[    6.454544] hpwdt: CRU Offset Address: 0x0
[    6.454545] hpwdt: CRU Length:         0x8000
[    6.454547] hpwdt: CRU Mapped Address: f84310dc
[    6.454549] hpwdt 0000:01:04.0: HP Watchdog Timer Driver: NMI decoding initialized, allow kernel dump: OFF (default = 0/OFF), priority: LAST (default = 0/LAST).
[    6.454668] hpwdt 0000:01:04.0: HP Watchdog Timer Driver: 1.3.0, timer margin: 30 seconds (nowayout=0).
[    6.572031] bnx2 0000:03:00.0: BAR 0: set to [mem 0xf8000000-0xf9ffffff 64bit] (PCI address [0xf8000000-0xf9ffffff])

-- 
Ralf Hildebrandt                   Charite Universitätsmedizin Berlin
ralf.hildebrandt@charite.de        Campus Benjamin Franklin
http://www.charite.de              Hindenburgdamm 30, 12203 Berlin
Geschäftsbereich IT, Abt. Netzwerk fon: +49-30-450.570.155
