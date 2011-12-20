Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab1LTDMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 22:12:24 -0500
Received: from joshcartwright.net ([69.164.192.171]:44121 "EHLO
	li107-171.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814Ab1LTDMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 22:12:22 -0500
X-Greylist: delayed 2189 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Dec 2011 22:12:22 EST
Date: Mon, 19 Dec 2011 21:35:50 -0500
From: Josh Cartwright <joshc@linux.com>
To: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: oops during modprobe (3.2.0-rc6+)
Message-ID: <20111220023550.GB9308@joshcartwright.net>
References: <20111217213645.GQ12099@charite.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111217213645.GQ12099@charite.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC'ing linux-watchdog)

On Sat, Dec 17, 2011 at 10:36:45PM +0100, Ralf Hildebrandt wrote:
> Todya I pulled 3.2.0-rc6+ from git and built it for my machine. After
> booting I found this in dmesg:
> 
> ...
> [    6.322632] bnx2: Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v2.1.11 (July 20, 2011)
> [    6.324608] hpwdt 0000:01:04.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> [    6.324680] hpwdt: New timer passed in is 30 seconds.
> [    6.324725] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
> [    6.324798] BUG: unable to handle kernel paging request at c00f0000
> [    6.324917] IP: [<c00f0000>] 0xc00effff
> [    6.325002] *pdpt = 00000000013b1001 *pde = 00000000013de067 *pte = 80000000000f0163 
> [    6.325002] Oops: 0011 [#1] SMP 
> [    6.325002] Modules linked in: hpwdt(+) bnx2(+) container psmouse thermal button processor
> [    6.325002] 
> [    6.325002] Pid: 668, comm: modprobe Not tainted 3.2.0-rc6+ #16 HP ProLiant DL360 G5
> [    6.325002] EIP: 0060:[<c00f0000>] EFLAGS: 00010286 CPU: 3
> [    6.325002] EIP is at 0xc00f0000
> [    6.325905] EAX: 55524324 EBX: 00000000 ECX: 00000000 EDX: 00000000
> [    6.325905] ESI: 00000000 EDI: 00000000 EBP: f00cddd8 ESP: f00cdda8
> [    6.325905]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [    6.325905] Process modprobe (pid: 668, ti=f00cc000 task=f0028000 task.ti=f00cc000)
> [    6.325905] Stack:
> [    6.325905]  f8432020 00000060 c00e007b 00000286 c00ffee0 ffffffed f00cddd8 f00cddd8
> [    6.325905]  c00f0000 00000001 00000000 c00f0000 f2cdbc00 f8432558 f8434100 c00f0000
> [    6.325905]  f2c30564 ffffffff f8434030 000f0000 000f0000 f2d777e0 c0100000 c00f0000
> [    6.325905] Call Trace:
> [    6.325905]  [<f8432020>] ? asminline_call+0x20/0x46 [hpwdt]
> [    6.325905]  [<f8432558>] ? hpwdt_init_one+0x1a7/0x3c0 [hpwdt]
> [    6.325905]  [<c115dc36>] ? pci_device_probe+0x47/0x68
> [    6.325905]  [<c11aa0a7>] ? driver_probe_device+0x4a/0x13a
> [    6.325905]  [<c115db04>] ? pci_match_device+0xf/0x8a
> [    6.325905]  [<c11aa1f9>] ? __driver_attach+0x62/0x64
> [    6.325905]  [<c11aa197>] ? driver_probe_device+0x13a/0x13a
> [    6.325905]  [<c11a9543>] ? bus_for_each_dev+0x3e/0x62
> [    6.325905]  [<c115dba2>] ? pci_dev_put+0xd/0xd
> [    6.325905]  [<c11a9e69>] ? driver_attach+0x19/0x1e
> [    6.325905]  [<c11aa197>] ? driver_probe_device+0x13a/0x13a
> [    6.325905]  [<c11a9beb>] ? bus_add_driver+0x17d/0x24d
> [    6.325905]  [<c115dba2>] ? pci_dev_put+0xd/0xd
> [    6.325905]  [<c11aa3d9>] ? driver_register+0x57/0xec
> [    6.325905]  [<c115dfef>] ? __pci_register_driver+0x31/0x92
> [    6.325905]  [<c1001027>] ? do_one_initcall+0x27/0x150
> [    6.325905]  [<c101c97e>] ? set_memory_nx+0x57/0x5b
> [    6.325905]  [<f8410000>] ? 0xf840ffff
> [    6.325905]  [<c1054416>] ? sys_init_module+0xdff/0x1a14
> [    6.325905]  [<c126f717>] ? sysenter_do_call+0x12/0x26
> [    6.325905] Code: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> [    6.329004]  90 80 fc d8 75 0d e9 da 06 00 00 69 04 00 00 ad 04 00 00 9c 
> [    6.329004] EIP: [<c00f0000>] 0xc00f0000 SS:ESP 0068:f00cdda8
> [    6.329004] CR2: 00000000c00f0000
> [    6.329004] ---[ end trace 239ff8fe19067483 ]---

I'm completely unfamiliar with this driver, but it looks like it ends up
executing a ioremap()'d region, which is being mapped NX.  I'll take a
stab at it with this completely untested patch.  Does it resolve your
issue?

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 3774c9b..33e6c9a 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -227,6 +227,8 @@ static int __devinit cru_detect(unsigned long map_entry,
 	if (bios32_map == NULL)
 		return -ENODEV;
 
+	set_memory_x((unsigned long) bios32_map, 2 * PAGE_SIZE);
+
 	bios32_entrypoint = bios32_map + map_offset;
 
 	cmn_regs.u1.reax = CRU_BIOS_SIGNATURE_VALUE;

-- 
                           joshc
