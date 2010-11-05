Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab0KEARy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 20:17:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63644 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab0KEARx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 20:17:53 -0400
Date: Thu, 4 Nov 2010 17:16:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant.likely@secretlab.ca>
Cc: lkml <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: spi_lm70llp module crash on unload (2.6.37-rc1)
Message-Id: <20101104171620.00d8c95d.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[  195.766900] calling  init_spi_lm70llp+0x0/0x20 [spi_lm70llp] @ 4739
Nov  4 14:54:37 control kernel: [  195.788098] parport_pc 00:06: registered master spi32766 (dynamic)
[  195.796346] spi spi32766.0: spi_bitbang_setup, 166 nsec/bit
[  195.803579] spi spi32766.0: setup mode 0, 3wire, 8 bits/w, 6000000 Hz max --> 0
[  195.813169] parport_pc 00:06: registered child spi32766.0
[  195.820255] spi spi32766.0: spidev_lm70 at spi32766.0
[  195.827021] initcall init_spi_lm70llp+0x0/0x20 [spi_lm70llp] returned 0 after 50824 usecs
Nov  4 14:54:37 control kernel: [  195.890956] calling  init_lm70+0x0/0x20 [lm70] @ 4758
Nov  4 14:54:37 control kernel: [  195.890956] c[  195.903782] initcall init_lm70+0x0/0x20 [lm70] returned 0 after 5699 usecs
Nov  4 14:54:37 control kernel: [  196.874322] BUG: unable to handle kernel NULL pointer dereference at 0000000000000060
[  196.876033] IP: [<ffffffff8124f7e2>] sysfs_find_dirent+0x12/0x84
[  196.885674] PGD 6bc79067 PUD 6b0f2067 PMD 0 
[  196.885674] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[  196.885674] last sysfs file: /sys/module/hwmon/initstate
[  196.885674] CPU 0 
[  196.885674] Modules linked in: lm70 spi_lm70llp(-) spi_bitbang crc7 crc_itu_t ipt_MASQUERADE iptable_nat nf_nat af_packet nfsd lockdNov  4 14:54:38  nfs_acl auth_rpcgss exportfs sco bridge stp llc bnep l2cap crc16 bluetooth rfkill sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 p4_clockmod freq_table speedstep_lib binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm uinput mousedev joydev ppdev snd_intel8x0 snd_ac97_codec usbmouse ac97_bus usbkbd snd_seq snd_seq_device snd_pcm usbhid hid led_class snd_timer dcdbas sg sr_mod iTCO_wdt snd pcspkr iTCO_vendor_support cdrom soundcore i2c_i801 rng_core rtc_cmos snd_page_alloc tg3 rtc_core parport_pc rtc_lib 8250_pnp parport evdev mac_hid shpchp pci_hotplug unix ide_pci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd oh!
 ci_hcd ssb mmc_core pcmcia pcmcia_core firmware_class ehci_hcd usbcore nls_base i915 drm_kms_helper intel_agp button intel_gtt video thermal_sys hwmon output [last unloaded: tle62x0]
[  196.885674] 
[  196.885674] Pid: 4777, comm: rmmod Not tainted 2.6.37-rc1 #12 0HH807/OptiPlex GX620               
[  196.885674] RIP: 0010:[<ffffffff8124f7e2>]  [<ffffffff8124f7e2>] sysfs_find_dirent+0x12/0x84
[  196.885674] RSP: 0018:ffff88006b057d68  EFLAGS: 00010292
[  196.885674] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  196.885674] RDX: ffffffff81692c20 RSI: 0000000000000000 RDI: 0000000000000000
[  196.885674] RBP: ffff88006b057d88 R08: ffffffff81ad8370 R09: 000000000048403c
[  196.885674] R10: 0000000000000002 R11: 00007fffa900efb0 R12: 0000000000000000
[  196.885674] R13: ffff88006bea6370 R14: 0000000000000000 R15: 0000000000000001
[  196.885674] FS:  00007fab30c566f0(0000) GS:ffff88007c600000(0000) knlGS:0000000000000000
[  196.885674] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  196.885674] CR2: 0000000000000060 CR3: 000000006bd62000 CR4: 00000000000006f0
[  196.885674] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  196.885674] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  196.885674] Process rmmod (pid: 4777, threadinfo ffff88006b056000, task ffff88006b250000)
[  196.885674] Stack:
[  196.885674]  ffff88006b057d88 0000000000000000 0000000000000000 ffff88006bea6370
[  196.885674]  ffff88006b057db8 ffffffff8124f899 ffff88006b057dc8 ffffffff81692c20
[  196.885674]  ffffffff81b057e0 ffff880079b199b0 ffff88006b057de8 ffffffff81252f2c
[  196.885674] Call Trace:
[  196.885674]  [<ffffffff8124f899>] sysfs_get_dirent+0x45/0x7b
[  196.885674]  [<ffffffff81252f2c>] sysfs_remove_group+0x32/0xf0
[  196.885674]  [<ffffffff813f9f38>] dpm_sysfs_remove+0x20/0x29
[  196.885674]  [<ffffffff813ef5cf>] device_del+0x68/0x260
[  196.885674]  [<ffffffff813ef829>] device_unregister+0x62/0x7c
[  196.885674]  [<ffffffff81443134>] spi_unregister_master+0x74/0x7f
[  196.885674]  [<ffffffffa0c0d31e>] spi_bitbang_stop+0x24/0x6f [spi_bitbang]
[  196.885674]  [<ffffffffa0c1517b>] spi_lm70llp_detach+0x44/0xb8 [spi_lm70llp]
[  196.885674]  [<ffffffffa03c8925>] parport_unregister_driver+0x60/0xa4 [parport]
[  196.885674]  [<ffffffffa0c15668>] cleanup_spi_lm70llp+0x1c/0x25 [spi_lm70llp]
[  196.885674]  [<ffffffff810d32bc>] sys_delete_module+0x2d6/0x368
[  196.885674]  [<ffffffff8155075b>] ? lockdep_sys_exit_thunk+0x35/0x67
[  196.885674]  [<ffffffff815506e5>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  196.885674]  [<ffffffff8100ea72>] system_call_fastpath+0x16/0x1b
[  196.885674] Code: ff 48 ff 05 a9 ff 72 01 f0 ff 03 48 ff 05 a7 ff 72 01 5a 48 89 d8 5b c9 c3 55 48 89 e5 41 55 41 54 53 48 83 ec 08 0f 1f 44 00 00 <4c> 8b 67 60 48 89 f3 49 89 d5 eb 4f 48 ff 05 a3 ff 72 01 48 85 
[  196.885674] RIP  [<ffffffff8124f7e2>] sysfs_find_dirent+0x12/0x84
[  196.885674]  RSP <ffff88006b057d68>
[  196.885674] CR2: 0000000000000060
[  196.886323] ---[ end trace 2d4fa5c0b761caa4 ]---
control kernel: Nov  4 14:54:38 control kernel: [  196.885674] last sysfs file: /sys/module/hwmon/initstate
Nov  4 14:54:38 control kernel: [  196.885674] CPU 0 
Nov  4 14:54:38 control kernel: [  196.885674] Modules linked in: lm70 spi_lm70llp(-) spi_bitbang crc7 crc_itu_t ipt_MASQUERADE iptable_nat nf_nat af_packet nfsd lockd nfs_acl auth_rpcgss exportfs sco bridge stp llc bnep l2cap crc16 bluetooth rfkill sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 p4_clockmod freq_table speedstep_lib binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm uinput mousedev joydev ppdev snd_intel8x0 snd_ac97_codec usbmouse ac97_bus usbkbd snd_seq snd_seq_device snd_pcm usbhid hid led_class snd_timer dcdbas sg sr_mod iTCO_wdt snd pcsNov  4 14:54:38 control kernel: [  196.885674]  [<ffffffff8124f899>] sysfs_get_dirent+0x45/0x7b
Nov  4 14:54:38 control kernel: [  196.885674]  [<ffffffff81252f2c>] sysfs_remove_group+0x32/0xf0
Nov  4 14:54:38 control kernel: [  196.885674]  [<ffffffff813f9f38>] dpm_sysfs_remove+0x20/0x29
Nov  4 14:54:38 control kernel: [  196.885674]  [<ffffffff813ef5cf>] device_del+0x68/0x260
Nov  4 14:54:38 control kernel: [  196.885674]  [<ffffffff813ef829>] device_unregister+0x62/0x7c

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
