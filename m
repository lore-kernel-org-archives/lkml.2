Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab0KEAOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 20:14:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52077 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0KEAOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 20:14:05 -0400
Date: Thu, 4 Nov 2010 17:13:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: (2.6.37-rc1) amd64-agp module crashed on second load
Message-Id: <20101104171333.fea1f498.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[   81.856556] calling  agp_amd64_mod_init+0x0/0x19 [amd64_agp] @ 3076
[   81.863586] initcall agp_amd64_mod_init+0x0/0x19 [amd64_agp] returned -19 after 571 usecs
[   91.203473] calling  agp_amd64_mod_init+0x0/0x19 [amd64_agp] @ 3194
[   91.210787] BUG: unable to handle kernel paging request at ffffffffa0bdac50
[   91.213864] IP: [<ffffffff813f46c9>] put_driver+0x10/0x22
[   91.213864] PGD 1a18067 PUD 1a1c063 PMD 6eb32067 PTE 0
[   91.213864] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   91.213864] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1.3/devnum
[   91.213864] CPU 0 
[   91.213864] Modules linked in: amd64_agp(+) ipt_MASQUERADE iptable_nat nf_nat af_packet nfsd lockd nfs_acl auth_rpcgss exportfs sco bridge stp llc bnep l2cap crc16 bluetooth rfkill sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 p4_clockmod freq_table speedstep_lib binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm uinput mousedev joydev ppdev snd_intel8x0 snd_ac97_codec ac97_bus snd_seq snd_seq_device led_class snd_pcm usbkbd iTCO_wdt usbmouse snd_timer usbhid iTCO_vendor_support snd hidNov  4 16:44:06  tg3 sr_mod dcdbas sg pcspkr soundcore i2c_i801 rtc_cmos rng_core cdrom parport_pc snd_page_alloc rtc_core evdev shpchp rtc_lib parport 8250_pnp pci_hotplug mac_hid unix ide_pci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_!
 core firmware_class ehci_hcd usbcore nls_base i915 drm_kms_helper intel_agp button intel_gtt video thermal_sys hwmon output [last unloaded: mperf]
[   91.306187] 
[   91.306187] Pid: 3194, comm: modprobe Not tainted 2.6.37-rc1 #12 0HH807/OptiPlex GX620               
[   91.306187] RIP: 0010:[<ffffffff813f46c9>]  [<ffffffff813f46c9>] put_driver+0x10/0x22
[   91.306187] RSP: 0018:ffff88006c94de88  EFLAGS: 00010202
[   91.306187] RAX: ffffffffa0bdabf0 RBX: ffffffffa0be3bf0 RCX: ffff88007c617d60
[   91.306187] RDX: 0000000000290028 RSI: 000000153c95b94f RDI: ffffffffa0bdabf0
[   91.306187] RBP: ffff88006c94de88 R08: 0000000000000000 R09: 0000000000000000
[   91.306187] R10: 0000000000000000 R11: ffffffff812babff R12: ffffffffa0be3bf0
[   91.306187] R13: 0000000000000000 R14: 000000153c95abb5 R15: 0000000000000000
[   91.306187] FS:  00007ff3f4c916f0(0000) GS:ffff88007c600000(0000) knlGS:0000000000000000
[   91.306187] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   91.306187] CR2: ffffffffa0bdac50 CR3: 000000006cad2000 CR4: 00000000000006f0
[   91.306187] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   91.306187] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   91.306187] Process modprobe (pid: 3194, threadinfo ffff88006c94c000, task ffff88006c928000)
[   91.306187] Stack:
[   91.306187]  ffff88006c94deb8 ffffffff813f479b ffffffffa0be3b90 ffffffffa0be3bf0
[   91.306187]  0000000000000000 000000153c95abb5 ffff88006c94def8 ffffffff812e6b1c
[   91.306187]  ffff88006c94dee8 ffffffff810b5251 ffff88006c94dee8 ffffffffa0be3f50
[   91.306187] Call Trace:
[   91.306187]  [<ffffffff813f479b>] driver_register+0xc0/0x1b2
[   91.306187]  [<ffffffff812e6b1c>] __pci_register_driver+0x76/0x12c
[   91.306187]  [<ffffffff810b5251>] ? timekeeping_get_ns+0x22/0x4b
[   91.306187]  [<ffffffffa0be711b>] ? agp_amd64_mod_init+0x0/0x19 [amd64_agp]
[   91.306187]  [<ffffffffa0be703f>] agp_amd64_init+0x3f/0x11b [amd64_agp]
[   91.306187]  [<ffffffffa0be712b>] agp_amd64_mod_init+0x10/0x19 [amd64_agp]
[   91.306187]  [<ffffffff810020a6>] do_one_initcall+0x6c/0x1ef
[   91.306187]  [<ffffffff810d529f>] sys_init_module+0xe1/0x2a5
[   91.306187]  [<ffffffff8100ea72>] system_call_fastpath+0x16/0x1b
[   91.306187] Code: 85 f6 75 d9 48 89 df e8 72 de ff ff 48 ff 05 d7 64 66 01 58 5b 41 5c 41 5d c9 c3 55 48 89 e5 0f 1f 44 00 00 48 ff 05 c7 64 66 01 <48> 8b 7f 60 e8 7a 6a ec ff 48 ff 05 bf 64 66 01 c9 c3 55 48 89 
[   91.306187] RIP  [<ffffffff813f46c9>] put_driver+0x10/0x22
[   91.306187]  RSP <ffff88006c94de88>
[   91.306187] CR2: ffffffffa0bdac50
[   91.306187] ---[ end trace 4da8520e1e9739ce ]---
Nov  4 16:44:06 control kernel: [   91.213864] IP: [<ffffffff813f46c9>] put_driver+0x10/0x22
Nov  4 16:44:06 control kernel: [   91.213864] PGD 1a18067 PUD 1a1c063 PMD 6eb32067 PTE 0
Nov  4 16:44:06 control kernel: [   91.213864] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   91.213864] last sysfs file: /sys/devices/pci0000:0
[   91.306187] Stack:

<nothing else printed>

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
