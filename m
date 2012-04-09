Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab2DIPCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 11:02:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33774 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab2DIPCC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 11:02:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9tz-2bXahnfDK0-anxyZcqFUPOSEewJxh2+2U51xypmw-w@mail.gmail.com>
References: <CAPM=9tz-2bXahnfDK0-anxyZcqFUPOSEewJxh2+2U51xypmw-w@mail.gmail.com>
Date: Mon, 9 Apr 2012 16:02:01 +0100
Message-ID: <CAPM=9tzqwZpWP9Ea-UVWYFcoVY-fa+jCf5FOShiMTrY4roN-og@mail.gmail.com>
Subject: Re: oops on rmmod of rtl8192ce
From: Dave Airlie <airlied@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping any ideas on this oops on unload?

On Mon, Mar 19, 2012 at 8:25 AM, Dave Airlie <airlied@gmail.com> wrote:
> Every so often on resume my rtl8192ce stops working, it can see APs
> but won't attach to any of them,
>
> I see 3 probes, then a direct probe timeout message. If I s/r a few
> times sometimes it comes back. This time I tried to rmmod rtl8192ce
> and got a nice oops.
>
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] Oops: 0000 [#1] SMP
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] CPU 1
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] Modules linked in:
> tcp_lp fuse ppdev ebtable_nat parport_pc ebtables lp parport
> ipt_MASQUERADE iptable_nat nf_nat xt_CHECKSUM iptable_mangle bridge
> stp llc lockd be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4
> cxgb3i libcxgbi cxgb3 mdio ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad
> ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi
> rfcomm bnep ip6t_REJECT nf_conntrack_ipv4 nf_conntrack_ipv6
> nf_defrag_ipv4 nf_defrag_ipv6 xt_state ip6table_filter ip6_tables
> nf_conntrack vfat fat snd_hda_codec_conexant btusb bluetooth
> snd_hda_codec_hdmi arc4 snd_hda_intel snd_hda_codec rtl8192ce(-)
> snd_hwdep snd_seq snd_seq_device rtl8192c_common snd_pcm thinkpad_acpi
> snd_timer uvcvideo snd vhost_net r8169 macvtap macvlan tun rtlwifi
> mac80211 sp5100_tco virtio_net mii i2c_piix4 cfg80211 rfkill kvm_amd
> videodev k10temp soundcore joydev serio_raw snd_page_alloc kvm media
> v4l2_compat_ioctl32 sunrpc uinput binfmt_misc ums_realtek usb_storage
> video radeon ttm drm_kms_helpe
> Mar 19 08:14:35 kvothe kernel: r drm i2c_algo_bit i2c_core [last
> unloaded: scsi_wait_scan]
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011]
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] Pid: 19627, comm: rmmod
> Not tainted 3.2.9-2.fc16.x86_64 #1 LENOVO 05962RU/05962RU
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] RIP:
> 0010:[<ffffffffa0418d39>]  [<ffffffffa0418d39>]
> rtl92ce_get_desc+0x19/0xd0 [rtl8192ce]
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] RSP:
> 0018:ffff880050263b58  EFLAGS: 00010046
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] RAX: ffffffffa041c2a0
> RBX: 0000000000000000 RCX: 0000000000000000
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] RDX: 0000000000000000
> RSI: 0000000000000000 RDI: 00000000000006e0
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] RBP: ffff880050263b68
> R08: ffff8801182bde00 R09: ffff88011a4000a0
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] R10: fffffffcfffffff0
> R11: fffffffcfffffff0 R12: ffff8800b00ee400
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] R13: 00000000000006e0
> R14: 0000000000000037 R15: 0000000000000037
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] FS:
> 00007fe794c31700(0000) GS:ffff88011ed00000(0000)
> knlGS:0000000000000000
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] CS:  0010 DS: 0000 ES:
> 0000 CR0: 000000008005003b
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] CR2: 00000000000006e0
> CR3: 00000000c4c18000 CR4: 00000000000006e0
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] DR0: 0000000000000000
> DR1: 0000000000000000 DR2: 0000000000000000
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] DR3: 0000000000000000
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] Process rmmod (pid:
> 19627, threadinfo ffff880050262000, task ffff8801156d5cc0)
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] Stack:
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  0000000000000002
> ffff8801176c2540 ffff880050263ca8 ffffffffa03348e7
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  0000000000000282
> 0000000180150014 ffff880050263fd8 ffff8801176c2810
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  ffff880050263bc8
> ffffffff810550e2 00000000000002c0 ffff8801176c0d40
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] Call Trace:
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  [<ffffffffa03348e7>]
> _rtl_pci_rx_interrupt+0x187/0x650 [rtlwifi]
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  [<ffffffff810550e2>] ?
> complete+0x52/0x60
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  [<ffffffffa0335e69>]
> _rtl_pci_interrupt+0x409/0x930 [rtlwifi]
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  [<ffffffff810df45d>]
> __free_irq+0x17d/0x220
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  [<ffffffffa0335656>]
> rtl_pci_disconnect+0x176/0x1a0 [rtlwifi]
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  [<ffffffff812df2b6>]
> pci_device_remove+0x46/0x110
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  [<ffffffff813954cc>]
> __device_release_driver+0x7c/0xe0
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  [<ffffffff81395da8>]
> driver_detach+0xb8/0xc0
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  [<ffffffff8139530a>]
> bus_remove_driver+0x8a/0x100
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  [<ffffffff81396562>]
> driver_unregister+0x62/0xa0
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  [<ffffffff812de164>]
> pci_unregister_driver+0x44/0xa0
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  [<ffffffffa0418e5c>]
> rtl92ce_module_exit+0x10/0x1b4 [rtl8192ce]
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  [<ffffffff810ab41e>]
> sys_delete_module+0x18e/0x250
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  [<ffffffff815ec682>]
> system_call_fastpath+0x16/0x1b
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] Code: ff 09 d0 89 07 48
> 83 c4 08 5b 5d c3 66 0f 1f 44 00 00 55 48 89 e5 53 48 83 ec 08 66 66
> 66 66 90 40 84 f6 89 d3 74 13 84 d2 75 57 <8b> 07 48 83 c4 08 5b 5d c1
> e8 1f c3 0f 1f 00 84 d2 74 ed 80 fa
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] RIP
> [<ffffffffa0418d39>] rtl92ce_get_desc+0x19/0xd0 [rtl8192ce]
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  RSP <ffff880050263b58>
> Mar 19 08:14:35 kvothe kernel: [ 6584.626011] CR2: 00000000000006e0
> Mar 19 08:14:35 kvothe kernel: [ 6584.646491] ---[ end trace
> 8636c766dcfbe0e6 ]---
>
> Dave.
