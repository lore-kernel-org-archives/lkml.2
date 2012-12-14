Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab2LNVyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 16:54:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52507 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab2LNVyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 16:54:31 -0500
Date: Fri, 14 Dec 2012 22:54:28 +0100
From: Heinz Diehl <htd@fritha.org>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [3.6.10] Null pointer dereference (xhci)
Message-ID: <20121214215428.GA4465@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+73 (c4c65eadeb71) (2011-07-01)
X-Provags-ID: V02:K0:JhLaqKfq5Agd81Ua6e6BKeZ0GvQJuJDBe6UXDxlY9LC
 Gir/J6TavhEpn6hLv5B8U04FFcgExwb38PEwjuJ4ITnVkMAPmC
 D7dRDsI6EvfApRvYJZ4Qw5OU/H/GFmUCVHNlVYDFZ0rYatKQUv
 LC5Q94bDR9/okfRnxqMVjDFiXJGb/GtNDEKL5tELSdbSCnmXk7
 isjUg9puoN9ykVSIcGnAxiyuONfBW1BJqOO/fNKq9AX9Gmstfu
 zcqGbViXs2Wu7l7w+C/5dGDCI9bJQc0jty3rKrJ2GCaxTvjZPm
 ejJ9zn/XEljVrxaRWhE5KdGUBwmFQYlVvnsVSnn3nc5J5xFNk0
 ox9WWSs+vQXDlrQdG3rnhBbCtmtt9hnQlRwP2KtbR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm getting this regularly with 3.6.10. The machine is new installed,
so I don't know if any version before 3.6.10 worked allright. 

Dec 14 22:39:03 nala kernel: [ 1388.792044] xhci_hcd 0000:03:00.0: Timeout while waiting for address device command
Dec 14 22:39:03 nala kernel: [ 1399.776824] usb 3-1: Device not responding to set address.
Dec 14 22:39:04 nala kernel: [ 1399.977529] usb 3-1: device not accepting address 2, error -71
Dec 14 22:39:25 nala kernel: [ 1404.971070] xhci_hcd 0000:03:00.0: Timeout while waiting for a slot
Dec 14 22:39:25 nala kernel: [ 1419.875430] ------------[ cut here
]------------
Dec 14 22:39:25 nala kernel: [ 1419.875438] WARNING: at kernel/watchdog.c:242 watchdog_overflow_callback+0x9a/0xc0()
Dec 14 22:39:25 nala kernel: [ 1419.875439] Hardware name: K53E
Dec 14 22:39:25 nala kernel: [ 1419.875440] Watchdog detected hard LOCKUP on cpu 0
Dec 14 22:39:25 nala kernel: [ 1419.875441] Modules linked in: rfcomm
fuse lockd sunrpc bnep ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack snd_hda_codec_hdmi snd_hda_codec_realtek arc4 iwldvm
mac80211 uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core
videodev media coretemp snd_hda_intel kvm_intel iTCO_wdt
iTCO_vendor_support tcp_veno asus_nb_wmi asus_wmi sparse_keymap
snd_hda_codec btusb kvm crc32c_intel ghash_clmulni_intel microcode
joydev snd_hwdep serio_raw pcspkr bluetooth snd_seq i2c_i801 lpc_ich
mfd_core snd_seq_device iwlwifi snd_pcm atl1c snd_page_alloc snd_timer
cfg80211 snd uinput soundcore rfkill mei wmi xfs usb_storage i915
video i2c_algo_bit drm_kms_helper drm i2c_core
Dec 14 22:39:25 nala kernel: [ 1419.875484] Pid: 41, comm: khubd Not tainted 3.6.10 #1
Dec 14 22:39:25 nala kernel: [ 1419.875485] Call Trace:
Dec 14 22:39:25 nala kernel: [ 1419.875486]  <NMI> [<ffffffff8105e60f>] warn_slowpath_common+0x7f/0xc0
Dec 14 22:39:25 nala kernel: [ 1419.875493]  [<ffffffff8105e706>] warn_slowpath_fmt+0x46/0x50
Dec 14 22:39:25 nala kernel: [ 1419.875496]  [<ffffffff810eb450>] ? touch_nmi_watchdog+0x80/0x80
Dec 14 22:39:25 nala kernel: [ 1419.875498]  [<ffffffff810eb4ea>] watchdog_overflow_callback+0x9a/0xc0
Dec 14 22:39:25 nala kernel: [ 1419.875501]  [<ffffffff8112868d>] __perf_event_overflow+0x9d/0x230
Dec 14 22:39:25 nala kernel: [ 1419.875505]  [<ffffffff81026867>] ?x86_perf_event_set_period+0xd7/0x160Dec 14 22:39:25  nala kernel:  1419.875507]  [<ffffffff81129344>]
perf_event_overflow+0x14/0x20 
Dec 14 22:39:25 nala kernel: [ 1419.875509]  [<ffffffff8102be53>] intel_pmu_handle_irq+0x193/0x310
Dec 14 22:39:25 nala kernel: [ 1419.875513]  [<ffffffff81633b6d>] perf_event_nmi_handler+0x1d/0x20
Dec 14 22:39:25 nala kernel: [ 1419.875515]  [<ffffffff816332b9>] nmi_handle.isra.1+0x59/0x90
Dec 14 22:39:25 nala kernel: [ 1419.875518]  [<ffffffff81633459>] do_nmi+0x169/0x350
Dec 14 22:39:25 nala kernel: [ 1419.875520]  [<ffffffff816328c0>] end_repeat_nmi+0x1e/0x2e
Dec 14 22:39:25 nala kernel: [ 1419.875523]  [<ffffffff8146ca14>] ? handshake+0x24/0x70
Dec 14 22:39:25 nala kernel: [ 1419.875525]  [<ffffffff8146ca14>] ? handshake+0x24/0x70
Dec 14 22:39:25 nala kernel: [ 1419.875528]  [<ffffffff8146ca14>] ? handshake+0x24/0x70
Dec 14 22:39:25 nala kernel: [ 1419.875529]  <<EOE>> [<ffffffff8147641b>] xhci_cancel_cmd+0x13b/0x1d0
Dec 14 22:39:25 nala kernel: [ 1419.875533]  [<ffffffff8147036b>] xhci_alloc_dev+0x19b/0x1f0
Dec 14 22:39:25 nala kernel: [ 1419.875536]  [<ffffffff8143acdc>] usb_alloc_dev+0x7c/0x320
Dec 14 22:39:25 nala kernel: [ 1419.875539]  [<ffffffff812e5e6b>] ? kobject_put+0x2b/0x60
Dec 14 22:39:25 nala kernel: [ 1419.875542]  [<ffffffff81441433>] hub_thread+0x783/0x16d0
Dec 14 22:39:25 nala kernel: [ 1419.875545]  [<ffffffff81082dd0>] ? wake_up_bit+0x40/0x40
Dec 14 22:39:25 nala kernel: [ 1419.875547]  [<ffffffff81440cb0>] ? usb_remote_wakeup+0x70/0x70
Dec 14 22:39:25 nala kernel: [ 1419.875549]  [<ffffffff810828e3>] kthread+0x93/0xa0
Dec 14 22:39:25 nala kernel: [ 1419.875552]  [<ffffffff8163a1c4>] kernel_thread_helper+0x4/0x10
Dec 14 22:39:25 nala kernel: [ 1419.875554]  [<ffffffff81082850>] ? kthread_create_on_node+0x120/0x120
Dec 14 22:39:25 nala kernel: [ 1419.875556]  [<ffffffff8163a1c0>] ? gs_change+0x13/0x13
Dec 14 22:39:25 nala kernel: [ 1419.875557] ---[ end trace 6ca2082d20e938b5 ]---
Dec 14 22:39:25 nala kernel: [ 1421.139050] xhci_hcd 0000:03:00.0: Stopped the command ring failed, maybe the host is dead
Dec 14 22:39:25 nala kernel: [ 1421.139068] xhci_hcd 0000:03:00.0: Abort command ring failed
Dec 14 22:39:25 nala kernel: [ 1421.139477] xhci_hcd 0000:03:00.0: HC died; cleaning up
Dec 14 22:39:25 nala kernel: [ 1421.139489] hub 3-0:1.0: cannot reset port 1 (err = -19)
Dec 14 22:39:25 nala kernel: [ 1421.139492] hub 3-0:1.0: cannot disable port 1 (err = -19)
Dec 14 22:39:25 nala kernel: [ 1421.139507] BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
Dec 14 22:39:25 nala kernel: [ 1421.140733] IP: [<ffffffff81470c13>] xhci_free_dev+0x63/0x160
Dec 14 22:39:25 nala kernel: [ 1421.141276] PGD 1e7665067 PUD 1e7664067 PMD 0 
Dec 14 22:39:25 nala kernel: [ 1421.141801] Oops: 0002 [#1] PREEMPT SMP 
Dec 14 22:39:25 nala kernel: [ 1421.142346] Modules linked in: rfcomm
fuse lockd sunrpc bnep ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack snd_hda_codec_hdmi snd_hda_codec_realtek arc4 iwldvm
mac80211 uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core
videodev media coretemp snd_hda_intel kvm_intel iTCO_wdt
iTCO_vendor_support tcp_veno asus_nb_wmi asus_wmi sparse_keymap
snd_hda_codec btusb kvm crc32c_intel ghash_clmulni_intel microcode
joydev snd_hwdep serio_raw pcspkr bluetooth snd_seq i2c_i801 lpc_ich
mfd_core snd_seq_device iwlwifi snd_pcm atl1c snd_page_alloc snd_timer
cfg80211 snd uinput soundcore rfkill mei wmi xfs usb_storage i915
video i2c_algo_bit drm_kms_helper drm i2c_core
Dec 14 22:39:25 nala kernel: [ 1421.145623] CPU 0 
Dec 14 22:39:25 nala kernel: [ 1421.145632] Pid: 41, comm: khubd
Tainted: G        W    3.6.10 #1 ASUSTeK Computer Inc. K53E/K53E
Dec 14 22:39:25 nala kernel: [ 1421.146983] RIP:0010:[<ffffffff81470c13>]  [<ffffffff81470c13>] xhci_free_dev+0x63/0x160
Dec 14 22:39:25 nala kernel: [ 1421.147693] RSP: 0018:ffff8802338a3d60EFLAGS: 00010246
Dec 14 22:39:25 nala kernel: [ 1421.148399] RAX: 0000000000000000 RBX:0000000000000000 RCX: 0000000000000000
Dec 14 22:39:25 nala kernel: [ 1421.149097] RDX: ffff880232c61000 RSI:ffff8801dea02000 RDI: ffff88022ef16800
Dec 14 22:39:25 nala kernel: [ 1421.149830] RBP: ffff8802338a3da0 R08:0000000000000001 R09: ffffffff8186f0cc
Dec 14 22:39:25 nala kernel: [ 1421.150569] R10: 0000000000000000 R11:0000000000000431 R12: 0000000000000000
Dec 14 22:39:25 nala kernel: [ 1421.151313] R13: ffff8801dea02000 R14:ffff880232c61000 R15: 0000000000000040
Dec 14 22:39:25 nala kernel: [ 1421.152041] FS:0000000000000000(0000) GS:ffff88023f400000(0000)knlGS:0000000000000000
Dec 14 22:39:25 nala kernel: [ 1421.152808] CS:  0010 DS: 0000 ES:0000 CR0: 000000008005003b
Dec 14 22:39:25 nala kernel: [ 1421.153583] CR2: 0000000000000040 CR3:00000001e7662000 CR4: 00000000000407f0
Dec 14 22:39:25 nala kernel: [ 1421.154371] DR0: 0000000000000000 DR1:0000000000000000 DR2: 0000000000000000
Dec 14 22:39:25 nala kernel: [ 1421.155169] DR3: 0000000000000000 DR6:00000000ffff0ff0 DR7: 0000000000000400
Dec 14 22:39:25 nala kernel: [ 1421.155940] Process khubd (pid: 41,threadinfo ffff8802338a2000, task ffff880233eb45c0)
Dec 14 22:39:25 nala kernel: [ 1421.156740] Stack:
Dec 14 22:39:25 nala kernel: [ 1421.157538]  ffff88022e558000ffff88022ef16800 ffff88022ef16a00 0000000000000001
Dec 14 22:39:25 nala kernel: [ 1421.158363]  ffff88022e558000ffff8801dea02000 ffff88022ef16a00 00000000ffffff00
Dec 14 22:39:25 nala kernel: [ 1421.159187]  ffff8802338a3ee0ffffffff81441a81 ffff880233e7d358 0000000200000000
Dec 14 22:39:25 nala kernel: [ 1421.159993] Call Trace:
Dec 14 22:39:25 nala kernel: [ 1421.160807]  [<ffffffff81441a81>]hub_thread+0xdd1/0x16d0
Dec 14 22:39:25 nala kernel: [ 1421.161634]  [<ffffffff81082dd0>] ?wake_up_bit+0x40/0x40
Dec 14 22:39:25 nala kernel: [ 1421.162461]  [<ffffffff81440cb0>] ?usb_remote_wakeup+0x70/0x70
Dec 14 22:39:25 nala kernel: [ 1421.163289]  [<ffffffff810828e3>]kthread+0x93/0xa0
Dec 14 22:39:25 nala kernel: [ 1421.164103]  [<ffffffff8163a1c4>]kernel_thread_helper+0x4/0x10
Dec 14 22:39:25 nala kernel: [ 1421.164929]  [<ffffffff81082850>] ?kthread_create_on_node+0x120/0x120
Dec 14 22:39:25 nala kernel: [ 1421.165768]  [<ffffffff8163a1c0>] ?gs_change+0x13/0x13
Dec 14 22:39:25 nala kernel: [ 1421.166601] Code: ff ff 83 f8 ed 0f 85
e5 00 00 00 49 63 85 b8 04 00 00 31 db 4d 8b a4 c6 10 01 00 00 4d 8d
7c 24 40 0f 1f 80 00 00 00 00 48 63 c3 <41> 83 27 fb 83 c3 01 48 69 c0
e8 00 00 00 49 81 c7 e8 00 00 00 
Dec 14 22:39:25 nala kernel: [ 1421.168515] RIP  [<ffffffff81470c13>]xhci_free_dev+0x63/0x160
Dec 14 22:39:25 nala kernel: [ 1421.169450]  RSP <ffff8802338a3d60>
Dec 14 22:39:25 nala kernel: [ 1421.170380] CR2: 0000000000000040
Dec 14 22:39:25 nala kernel: [ 1421.179371] ---[ end trace 6ca2082d20e938b6 ]---
