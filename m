Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab1EXTZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:25:05 -0400
Received: from mail.agmk.net ([91.192.224.71]:49082 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648Ab1EXTZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:25:03 -0400
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: [2.6.38.7] slow path warning in do_syslog().
Date: Tue, 24 May 2011 21:24:41 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.6-8; KDE/4.6.3; x86_64; ; )
Cc: arekm@pld-linux.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105242124.42470.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

the vanilla 2.6.38.7 from git reports slow path warning right after startup.

[   84.226128] ------------[ cut here ]------------
[   84.226139] WARNING: at kernel/printk.c:288 do_syslog+0xc1/0x4c0()
[   84.226141] Hardware name: H8DGU
[   84.226143] Attempt to access syslog with CAP_SYS_ADMIN but no CAP_SYSLOG (deprecated).
[   84.226145] Modules linked in: nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs ipmi_si ipmi_devintf ipmi_msghandler sch_sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filter ip6_tables x_tables ext4 jbd2 crc16 raid0 dm_mod uvesafb autofs4 dummy aoe usbhid hid ide_cd_mod cdrom ata_generic pata_acpi pata_atiixp ide_pci_generic ohci_hcd atiixp ide_core ssb ehci_hcd igb mmc_core sp5100_tco usbcore pcmcia amd64_edac_mod i2c_piix4 k10temp pcmcia_core i2c_core hwmon evdev edac_core ghes edac_mce_amd pcspkr processor dca sg button hed sd_mod crc_t10dif raid1 md_mod ext3 jbd mbcache ahci libahci libata scsi_mod [last unloaded: scsi_wait_scan]
[   84.226197] Pid: 3291, comm: syslog-ng Not tainted 2.6.38.7 #1
[   84.226199] Call Trace:
[   84.226207]  [<ffffffff810487da>] ? warn_slowpath_common+0x7a/0xb0
[   84.226211]  [<ffffffff810488b1>] ? warn_slowpath_fmt+0x41/0x50
[   84.226216]  [<ffffffff811b9974>] ? security_capable+0x24/0x30
[   84.226220]  [<ffffffff81049a21>] ? do_syslog+0xc1/0x4c0
[   84.226224]  [<ffffffff8118c695>] ? proc_reg_open+0x45/0x170
[   84.226227]  [<ffffffff81196857>] ? kmsg_open+0x17/0x20
[   84.226230]  [<ffffffff8118c6e6>] ? proc_reg_open+0x96/0x170
[   84.226233]  [<ffffffff81196820>] ? kmsg_release+0x0/0x20
[   84.226236]  [<ffffffff8118c650>] ? proc_reg_open+0x0/0x170
[   84.226241]  [<ffffffff81134029>] ? __dentry_open+0xc9/0x2e0
[   84.226245]  [<ffffffff8113fcee>] ? generic_permission+0x1e/0xc0
[   84.226249]  [<ffffffff81135291>] ? nameidata_to_filp+0x71/0x80
[   84.226253]  [<ffffffff81143bd8>] ? finish_open+0xc8/0x1b0
[   84.226257]  [<ffffffff81143402>] ? do_path_lookup+0x82/0x160
[   84.226260]  [<ffffffff8114436d>] ? do_filp_open+0x2ad/0x7d0
[   84.226264]  [<ffffffff811203b6>] ? init_object+0x46/0x80
[   84.226268]  [<ffffffff81121e09>] ? __slab_alloc+0x3a9/0x410
[   84.226271]  [<ffffffff81141c36>] ? getname+0x36/0x220
[   84.226275]  [<ffffffff811503d7>] ? alloc_fd+0x47/0x140
[   84.226279]  [<ffffffff81135304>] ? do_sys_open+0x64/0x110
[   84.226282]  [<ffffffff811353cb>] ? sys_open+0x1b/0x20
[   84.226287]  [<ffffffff81002cbb>] ? system_call_fastpath+0x16/0x1b
[   84.226289] ---[ end trace e86f16754c027c2b ]---
