Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab2JaR1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:27:44 -0400
Received: from mail.agmk.net ([91.192.224.71]:47760 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318Ab2JaR1m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:27:42 -0400
From: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
To: skinsbursky@parallels.com
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        baggins@pld-linux.org, arekm@pld-linux.org
Subject: Re: [PATCH] lockd: fix races in per-net NSM client handling
Date: Wed, 31 Oct 2012 18:27:36 +0100
Message-ID: <1689813.hptKgzjpAu@localhost>
User-Agent: KMail/4.9.1 (Linux/3.6.4; KDE/4.9.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the patch metioned in https://lkml.org/lkml/2012/10/24/175 seems to fix
the 3.6.3 oops (while 3.6.2 works fine) at 16-cores opteron server.
please queue this path for 3.6.$next.

BR,
Paweł.

[173788.113576] ------------[ cut here ]------------
[173788.133439] hrtimer: interrupt took 11004406 ns
[173788.157195] kernel BUG at fs/lockd/mon.c:150!
[173788.179641] invalid opcode: 0000 [#1] SMP 
[173788.202033] Modules linked in: nfsv4 fuse nfsv3 nfs fscache nfsd auth_rpcgss nfs_acl lockd sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filter ip6_tables x_tables quota_v2 quota_tree ext4 crc16 jbd2 raid10 raid0 dm_mod uvesafb autofs4 dummy ide_cd_mod cdrom ata_generic pata_acpi pata_atiixp sp5100_tco ide_pci_generic igb ptp pps_core psmouse k10temp mgag200 serio_raw dca pcspkr ttm powernow_k8 drm_kms_helper drm mperf freq_table kvm_amd evdev joydev i2c_piix4 kvm i2c_algo_bit hid_generic syscopyarea sysfillrect sysimgblt hwmon microcode atiixp amd64_edac_mod edac_core i2c_core ide_core processor edac_mce_amd button ext3 mbcache jbd sd_mod crc_t10dif raid1 md_mod
[173788.378811]  ahci libahci libata scsi_mod usbhid hid ohci_hcd ehci_hcd usbcore usb_common
[173788.416270] CPU 2 
[173788.416648] Pid: 1383, comm: lockd Not tainted 3.6.3 #11 Supermicro H8DGU/H8DGU
[173788.493500] RIP: 0010:[<ffffffffa04e64c0>]  [<ffffffffa04e64c0>] nsm_mon_unmon+0x90/0xa0 [lockd]
[173788.529520] RSP: 0000:ffff8808093cdd00  EFLAGS: 00010246
[173788.565141] RAX: ffff8808093cdd28 RBX: ffff880ba2353200 RCX: 0000000000000000
[173788.601765] RDX: ffff8808093cdd68 RSI: 0000000000000002 RDI: ffff880ba2353200
[173788.638672] RBP: ffff8808093cdd50 R08: 00000000000168a0 R09: 000000000000ffff
[173788.675546] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880407db6c00
[173788.712500] R13: 0000000000000000 R14: ffff8808093cde28 R15: ffff8808093cde20
[173788.749767] FS:  00007f105fe73780(0000) GS:ffff88040fc80000(0000) knlGS:00000000f6663700
[173788.788015] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[173788.826367] CR2: 0000000000bce580 CR3: 000000044b252000 CR4: 00000000000007e0
[173788.865560] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[173788.904753] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[173788.943652] Process lockd (pid: 1383, threadinfo ffff8808093cc000, task ffff880808db3020)
[173788.983327] Stack:
[173789.022719]  ffff8808093cdd60 ffffffffa04ae9e4 ffff8808093cdd28 ffff8808093cdd68
[173789.063923]  0000000000000000 ffff880ba23532b1 00000003000186b5 0000000400000010
[173789.105657]  ffff880ba23532c1 000000000000008c ffff8808093cdd90 ffffffffa04e6821
[173789.148126] Call Trace:
[173789.190527]  [<ffffffffa04ae9e4>] ? sunrpc_cache_lookup+0x74/0x2f0 [sunrpc]
[173789.233864]  [<ffffffffa04e6821>] nsm_monitor+0xd1/0x1b0 [lockd]
[173789.277890]  [<ffffffffa04e8d18>] nlm4svc_retrieve_args+0xa8/0xf0 [lockd]
[173789.322014]  [<ffffffffa04e90c2>] nlm4svc_proc_lock+0x52/0xe0 [lockd]
[173789.366333]  [<ffffffffa04e86c9>] ? nlm4svc_decode_lockargs+0x49/0xc0 [lockd]
[173789.411109]  [<ffffffffa04a48d7>] svc_process+0x707/0x7a0 [sunrpc]
[173789.456179]  [<ffffffffa04e3825>] lockd+0xa5/0x1b0 [lockd]
[173789.500017]  [<ffffffffa04e3780>] ? set_grace_period+0xa0/0xa0 [lockd]
[173789.543446]  [<ffffffff810726ce>] kthread+0x8e/0xa0
[173789.585890]  [<ffffffff814af784>] kernel_thread_helper+0x4/0x10
[173789.628042]  [<ffffffff81072640>] ? kthread_freezable_should_stop+0x70/0x70
[173789.670892]  [<ffffffff814af780>] ? gs_change+0x13/0x13
[173789.713913] Code: 00 00 00 48 c1 e6 06 ba 00 04 00 00 48 29 c6 48 03 71 38 48 89 75 b8 48 8d 75 b8 e8 1b 3c fb ff 31 d2 85 c0 0f 4e d0 c9 89 d0 c3 <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 fe b9 
[173789.806212] RIP  [<ffffffffa04e64c0>] nsm_mon_unmon+0x90/0xa0 [lockd]
[173789.851690]  RSP <ffff8808093cdd00>
[173789.897665] ---[ end trace c8774e11cc39ecc3 ]---

