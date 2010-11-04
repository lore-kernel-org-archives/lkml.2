Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab0KDTqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:46:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30446 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab0KDTql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:46:41 -0400
Date: Thu, 4 Nov 2010 12:46:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net
Subject: spi_butterfly null ptr dereference on unload module
Message-Id: <20101104124606.ceb3e5f0.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just load and unload the module.


[ 3090.282767] BUG: unable to handle kernel NULL pointer dereference at 0000000000000060
[ 3090.284021] IP: [<ffffffff8124f7e2>] sysfs_find_dirent+0x12/0x84
[ 3090.284021] PGD 6c0ee067 PUD 6d087067 PMD 0 
[ 3090.284021] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[ 3090.284021] last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/local_cpus
[ 3090.284021] CPU 1 
[ 3090.284021] Modules linked in: mtd_dataflash mtd spi_butterfly(-) spi_bitbang leds_net5501 ipt_MASQUERADE iptable_nat nf_nat af_packet nfsd lockd nfs_acl auth_rpcgss exportfs sco bridge stp llc bnep l2cap crc16 bluetooth rfkill sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 p4_clockmod freq_table speedstep_lib binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm uinput mousedev joydev snd_intel8x0 snd_ac97_codec ac97_bus snd_seq snd_seq_device ppdev snd_pcm led_class usbmouse usbkbd snd_timer usbhid iTCO_wdt hid snd iTCO_vendor_support tg3 sg sr_mod soundcore dcdbas rtc_cmos i2c_i801 cdrom rng_core pcspkr rtc_core snd_page_alloc parport_pc evdev shpchp rtc_lib parport 8250_pnp pci_hotplug mac_hid unix ide_pci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_!
 hcd ssb mmc_core pcmcia pcmcia_core firmware_class ehci_hcd usbcore nls_base i915 drm_kms_helper intel_agp button intel_gtt video thermal_sys hwmon output [last unloaded: mperf]
[ 3090.325393] 
[ 3090.325393] Pid: 6990, comm: rmmod Not tainted 2.6.37-rc1 #12 0HH807/OptiPlex GX620               
[ 3090.325393] RIP: 0010:[<ffffffff8124f7e2>]  [<ffffffff8124f7e2>] sysfs_find_dirent+0x12/0x84
[ 3090.325393] RSP: 0018:ffff880076fbfd68  EFLAGS: 00010292
[ 3090.325393] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[ 3090.325393] RDX: ffffffff81692c20 RSI: 0000000000000000 RDI: 0000000000000000
[ 3090.325393] RBP: ffff880076fbfd88 R08: ffffffff81ad8370 R09: 000000000047603c
[ 3090.325393] R10: 0000000000000002 R11: 00007fff04119e40 R12: 0000000000000000
[ 3090.325393] R13: ffff88006c21c250 R14: 0000000000000000 R15: 0000000000000001
[ 3090.325393] FS:  00007f69f8f206f0(0000) GS:ffff88007c800000(0000) knlGS:0000000000000000
[ 3090.325393] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 3090.325393] CR2: 0000000000000060 CR3: 000000006c18f000 CR4: 00000000000006e0
[ 3090.325393] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3090.325393] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 3090.325393] Process rmmod (pid: 6990, threadinfo ffff880076fbe000, task ffff88006d208000)
[ 3090.325393] Stack:
[ 3090.325393]  ffff880076fbfd88 0000000000000000 0000000000000000 ffff88006c21c250
[ 3090.325393]  ffff880076fbfdb8 ffffffff8124f899 ffff880076fbfdc8 ffffffff81692c20
[ 3090.325393]  ffffffff81b057e0 ffff880079ae1568 ffff880076fbfde8 ffffffff81252f2c
[ 3090.325393] Call Trace:
[ 3090.325393]  [<ffffffff8124f899>] sysfs_get_dirent+0x45/0x7b
[ 3090.325393]  [<ffffffff81252f2c>] sysfs_remove_group+0x32/0xf0
[ 3090.325393]  [<ffffffff813f9f38>] dpm_sysfs_remove+0x20/0x29
[ 3090.325393]  [<ffffffff813ef5cf>] device_del+0x68/0x260
[ 3090.325393]  [<ffffffff813ef829>] device_unregister+0x62/0x7c
[ 3090.325393]  [<ffffffff81443134>] spi_unregister_master+0x74/0x7f
[ 3090.325393]  [<ffffffffa0bdf31e>] spi_bitbang_stop+0x24/0x6f [spi_bitbang]
[ 3090.325393]  [<ffffffffa0be7127>] butterfly_detach+0x53/0xcd [spi_butterfly]
[ 3090.325393]  [<ffffffffa034e925>] parport_unregister_driver+0x60/0xa4 [parport]
[ 3090.325393]  [<ffffffffa0be762c>] butterfly_exit+0x1c/0x25 [spi_butterfly]
[ 3090.325393]  [<ffffffff810d32bc>] sys_delete_module+0x2d6/0x368
[ 3090.325393]  [<ffffffff8155075b>] ? lockdep_sys_exit_thunk+0x35/0x67
[ 3090.325393]  [<ffffffff815506e5>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 3090.325393]  [<ffffffff8100ea72>] system_call_fastpath+0x16/0x1b
[ 3090.325393] Code: ff 48 ff 05 a9 ff 72 01 f0 ff 03 48 ff 05 a7 ff 72 01 5a 48 89 d8 5b c9 c3 55 48 89 e5 41 55 41 54 53 48 83 ec 08 0f 1f 44 00 00 <4c> 8b 67 60 48 89 f3 49 89 d5 eb 4f 48 ff 05 a3 ff 72 01 48 85 
[ 3090.325393] RIP  [<ffffffff8124f7e2>] sysfs_find_dirent+0x12/0x84
[ 3090.325393]  RSP <ffff880076fbfd68>
[ 3090.325393] CR2: 0000000000000060
[ 3090.326140] ---[ end trace 593b81e8a5dd9dbd ]---

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
