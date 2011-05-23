Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab1EWI6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 04:58:33 -0400
Received: from [46.170.108.42] ([46.170.108.42]:4367 "EHLO
	krak.alatek.krakow.pl" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab1EWI6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 04:58:32 -0400
X-Greylist: delayed 1984 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 May 2011 04:58:31 EDT
From: Pawel Sikora <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: [2.6.37.6] warn_slowpath at fs/dcache.c:1996 prepend_path+0x150/0x160()
Date: Mon, 23 May 2011 10:25:24 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-2; KDE/4.6.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105231025.24501.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on quite heavy loaded (~20) dual opteron i'm observing from time to time a slow path warning:

May 19 19:33:42 odra kernel: [105977.220094] ------------[ cut here ]------------
May 19 19:33:42 odra kernel: [105977.220102] WARNING: at /home/users/builder/rpm/BUILD/kernel-2.6.37.6/linux-2.6.37/fs/dcache.c:1996 prepend_path+0x150/0x160()
May 19 19:33:42 odra kernel: [105977.220105] Hardware name: H8DGU
May 19 19:33:42 odra kernel: [105977.220106] Root dentry has weird name <>
May 19 19:33:42 odra kernel: [105977.220108] Modules linked in: nfs fscache binfmt_misc nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs ipmi_si ipmi_devintf ipmi_msghandler sch_sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filter ip6_tables x_tables ext4 jbd2 crc16 raid0 dm_mod uvesafb autofs4 dummy aoe usbhid hid sr_mod cdrom ohci_hcd ide_pci_generic pata_acpi ata_generic atiixp ide_core i2c_piix4 psmouse amd64_edac_mod ssb igb mmc_core ehci_hcd edac_core evdev pcmcia usbcore i2c_core pcspkr k10temp serio_raw pcmcia_core dca edac_mce_amd pata_atiixp hwmon processor sg shpchp pci_hotplug ghes hed button sd_mod crc_t10dif raid1 md_mod ext3 jbd mbcache ahci libahci libata scsi_mod [last unloaded: scsi_wait_scan]
May 19 19:33:42 odra kernel: [105977.220165] Pid: 27482, comm: pidof xid: #0 Not tainted 2.6.37.6-2 #1
May 19 19:33:42 odra kernel: [105977.220167] Call Trace:
May 19 19:33:42 odra kernel: [105977.220175]  [<ffffffff81049e8a>] warn_slowpath_common+0x7a/0xb0
May 19 19:33:42 odra kernel: [105977.220179]  [<ffffffff81049f61>] warn_slowpath_fmt+0x41/0x50
May 19 19:33:42 odra kernel: [105977.220183]  [<ffffffff81163860>] prepend_path+0x150/0x160
May 19 19:33:42 odra kernel: [105977.220186]  [<ffffffff811638ea>] path_with_deleted+0x7a/0x90
May 19 19:33:42 odra kernel: [105977.220189]  [<ffffffff811639b9>] d_path+0xb9/0xf0
May 19 19:33:42 odra kernel: [105977.220193]  [<ffffffff811aefff>] proc_pid_readlink+0x8f/0x1c0
May 19 19:33:42 odra kernel: [105977.220197]  [<ffffffff811661bc>] ? touch_atime+0x6c/0x1a0
May 19 19:33:42 odra kernel: [105977.220201]  [<ffffffff81151861>] sys_readlinkat+0xb1/0xc0
May 19 19:33:42 odra kernel: [105977.220205]  [<ffffffff81151886>] sys_readlink+0x16/0x20
May 19 19:33:42 odra kernel: [105977.220209]  [<ffffffff81002e3b>] system_call_fastpath+0x16/0x1b
May 19 19:33:42 odra kernel: [105977.220212] ---[ end trace 6e6e81a31199f8f8 ]---
May 19 19:33:42 odra kernel: [105977.221291] ------------[ cut here ]------------

i'm not sure that is a vanilla kernel problem becuase the vendor applies vserver/grsecurity patches.
maybe this backtrace will be useful for developers.

BR,
Paweł.
