Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab2HLKfg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 06:35:36 -0400
Received: from www17.your-server.de ([213.133.104.17]:34354 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2HLKfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 06:35:32 -0400
Message-ID: <1344767672.1272.7.camel@localhost.localdomain>
Subject: [UDL] general protection fault in fb_deferred_io_mkwrite()
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        airlied@linux.ie, dri-devel@lists.freedesktop.org
Date: Sun, 12 Aug 2012 12:34:32 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

guilty driver is probably udl_fb.c
any ideas?

[   42.890551] open /dev/fb1 user=1 fb_info=ffff880130e0a800 count=1
[   42.890585] released /dev/fb1 user=1 count=0
[   42.890702] open /dev/fb1 user=1 fb_info=ffff880130e0a800 count=1
[   43.053034] type=1400 audit(1344698343.496:9): avc:  denied  { execmem } for  pid=631 comm="java" scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:system_r:httpd_t:s0 tclass=process
[   43.093084] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   43.140051] [drm] write mode info 144
[   43.140786] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   43.164482] asix 2-1.3:1.0: eth1: link down
[   44.791884] asix 2-1.3:1.0: eth1: link up, 100Mbps, full-duplex, lpa 0x41E1
[   45.289464] general protection fault: 0000 [#1] 
[   45.289512] CPU 0 
[   45.289529] Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables snd_usb_audio snd_usbmidi_lib snd_rawmidi udl syscopyarea sysfillrect sysimgblt asix uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev usbnet snd_seq_device drm_usb arc4 btusb iwlwifi bluetooth snd_hda_codec_hdmi acer_wmi joydev mac80211 snd_hda_codec_realtek cfg80211 acerhdf atl1c snd_hda_intel sparse_keymap pcspkr snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer snd rfkill soundcore wmi kvm_intel kvm ipv6 [last unloaded: scsi_wait_scan]
[   45.290003] 
[   45.290003] Pid: 629, comm: X Not tainted 3.5.1 #3 Acer Aspire 1810T/JM11-MS
[   45.290003] RIP: 0010:[<ffffffff8123becc>]  [<ffffffff8123becc>] fb_deferred_io_mkwrite+0xdc/0xf0
[   45.290003] RSP: 0000:ffff880138e93c98  EFLAGS: 00010246
[   45.290003] RAX: 7672645f6e6f6564 RBX: ffffea0004bd6180 RCX: 0000000000000036
[   45.290003] RDX: ffff88013369b460 RSI: ffff880138e93cf8 RDI: ffff880130e0a800
[   45.290003] RBP: ffff880138e93cb8 R08: 0c00000000000000 R09: a80012f586000000
[   45.290003] R10: 57ffd70a7ebd6180 R11: 0000003ccd37a850 R12: ffff880130e0a800
[   45.290003] R13: ffff88013369b448 R14: ffff88013369b440 R15: 0000000000000000
[   45.290003] FS:  00007f981237a8c0(0000) GS:ffffffff8168a000(0000) knlGS:0000000000000000
[   45.290003] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   45.290003] CR2: 00007f9810821010 CR3: 000000012f191000 CR4: 00000000000407f0
[   45.290003] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   45.290003] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   45.290003] Process X (pid: 629, threadinfo ffff880138e92000, task ffff880130c16b50)
[   45.290003] Stack:
[   45.290003]  ffff880130f37dc8 0000000000000001 ffff88013b2049c0 ffffea0004bd6180
[   45.290003]  ffff880138e93d48 ffffffff810b658c ffff880138e93d48 ffffffff810b740a
[   45.290003]  ffff88012f183210 00007f9810821010 ffff880127c23420 0000000030c16b50
[   45.290003] Call Trace:
[   45.290003]  [<ffffffff810b658c>] __do_fault+0xbc/0x420
[   45.290003]  [<ffffffff810b740a>] ? do_wp_page.isra.77+0x2aa/0x640
[   45.290003]  [<ffffffff810b8acc>] handle_pte_fault+0x8c/0x7f0
[   45.290003]  [<ffffffff8103b3f0>] ? __send_signal.part.24+0x130/0x300
[   45.290003]  [<ffffffff810264aa>] ? pte_alloc_one+0x1a/0x40
[   45.290003]  [<ffffffff810b9948>] handle_mm_fault+0x208/0x2c0
[   45.290003]  [<ffffffff814c0543>] do_page_fault+0x143/0x490
[   45.290003]  [<ffffffff8104fe85>] ? check_preempt_curr+0x85/0xa0
[   45.290003]  [<ffffffff81052a2a>] ? __dequeue_entity+0x2a/0x50
[   45.290003]  [<ffffffff81052fee>] ? pick_next_task_fair+0x6e/0x180
[   45.290003]  [<ffffffff814bc6ad>] ? __schedule+0x22d/0x500
[   45.290003]  [<ffffffff814bd72f>] page_fault+0x1f/0x30
[   45.290003] Code: 89 0a 4c 89 ef e8 35 fd 27 00 49 8b 36 49 8d bc 24 90 02 00 00 e8 95 66 e0 ff 5b b8 00 02 00 00 41 5c 41 5d 41 5e 5d c3 4c 89 e7 <ff> d0 e9 5e ff ff ff 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 
[   45.290003] RIP  [<ffffffff8123becc>] fb_deferred_io_mkwrite+0xdc/0xf0
[   45.290003]  RSP <ffff880138e93c98>
[   45.316388] ---[ end trace d4732d5a0bf375fa ]---
[   45.347642] released /dev/fb1 user=1 count=0
[   45.454869] open /dev/fb1 user=1 fb_info=ffff880130e0a800 count=1
[   45.454903] released /dev/fb1 user=1 count=0
[   45.455020] open /dev/fb1 user=1 fb_info=ffff880130e0a800 count=1
[   45.456389] [drm] write mode info 144
[   45.631358] [drm] write mode info 144
[   45.632075] general protection fault: 0000 [#2] 
[   45.632121] CPU 0 
[   45.632139] Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables snd_usb_audio snd_usbmidi_lib snd_rawmidi udl syscopyarea sysfillrect sysimgblt asix uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev usbnet snd_seq_device drm_usb arc4 btusb iwlwifi bluetooth snd_hda_codec_hdmi acer_wmi joydev mac80211 snd_hda_codec_realtek cfg80211 acerhdf atl1c snd_hda_intel sparse_keymap pcspkr snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer snd rfkill soundcore wmi kvm_intel kvm ipv6 [last unloaded: scsi_wait_scan]
[   45.633336] 
[   45.633336] Pid: 836, comm: X Tainted: G      D      3.5.1 #3 Acer Aspire 1810T/JM11-MS
[   45.633336] RIP: 0010:[<ffffffff8123becc>]  [<ffffffff8123becc>] fb_deferred_io_mkwrite+0xdc/0xf0
[   45.633336] RSP: 0000:ffff880126559c98  EFLAGS: 00010246
[   45.633336] RAX: 006f732e61786562 RBX: ffffea0004bd6180 RCX: 0000000000000036
[   45.633336] RDX: ffff8801265482e0 RSI: ffff880126559cf8 RDI: ffff880130e0a800
[   45.633336] RBP: ffff880126559cb8 R08: 0c00000000000000 R09: a80012f586000000
[   45.633336] R10: 57ffd70a7ebd6180 R11: 0000003ccd37a850 R12: ffff880130e0a800
[   45.633336] R13: ffff8801265482c8 R14: ffff8801265482c0 R15: 0000000000000000
[   45.633336] FS:  00007f06d7a628c0(0000) GS:ffffffff8168a000(0000) knlGS:0000000000000000
[   45.633336] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   45.633336] CR2: 00007f06d5f09010 CR3: 000000012f138000 CR4: 00000000000407f0
[   45.633336] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   45.633336] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   45.633336] Process X (pid: 836, threadinfo ffff880126558000, task ffff8801264dd290)
[   45.633336] Stack:
[   45.633336]  ffff880127c64738 0000000000000001 ffff880138db5040 ffffea0004bd6180
[   45.633336]  ffff880126559d48 ffffffff810b658c ffff880126559d48 ffffffff810b740a
[   45.633336]  ffff880126581210 00007f06d5f09010 ffff880126574578 00000000264dd290
[   45.633336] Call Trace:
[   45.633336]  [<ffffffff810b658c>] __do_fault+0xbc/0x420
[   45.633336]  [<ffffffff810b740a>] ? do_wp_page.isra.77+0x2aa/0x640
[   45.633336]  [<ffffffff810b8acc>] handle_pte_fault+0x8c/0x7f0
[   45.633336]  [<ffffffff8103b3f0>] ? __send_signal.part.24+0x130/0x300
[   45.633336]  [<ffffffff810264aa>] ? pte_alloc_one+0x1a/0x40
[   45.633336]  [<ffffffff810b9948>] handle_mm_fault+0x208/0x2c0
[   45.633336]  [<ffffffff814c0543>] do_page_fault+0x143/0x490
[   45.633336]  [<ffffffff8104fe85>] ? check_preempt_curr+0x85/0xa0
[   45.633336]  [<ffffffff81052a2a>] ? __dequeue_entity+0x2a/0x50
[   45.633336]  [<ffffffff81052fee>] ? pick_next_task_fair+0x6e/0x180
[   45.633336]  [<ffffffff814bc6ad>] ? __schedule+0x22d/0x500
[   45.633336]  [<ffffffff814bd72f>] page_fault+0x1f/0x30
[   45.633336] Code: 89 0a 4c 89 ef e8 35 fd 27 00 49 8b 36 49 8d bc 24 90 02 00 00 e8 95 66 e0 ff 5b b8 00 02 00 00 41 5c 41 5d 41 5e 5d c3 4c 89 e7 <ff> d0 e9 5e ff ff ff 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 
[   45.633336] RIP  [<ffffffff8123becc>] fb_deferred_io_mkwrite+0xdc/0xf0
[   45.633336]  RSP <ffff880126559c98>
[   45.711547] ---[ end trace d4732d5a0bf375fb ]---
[   45.720961] released /dev/fb1 user=1 count=0
[   45.756516] open /dev/fb1 user=1 fb_info=ffff880130e0a800 count=1
[   45.756550] released /dev/fb1 user=1 count=0
[   45.756632] open /dev/fb1 user=1 fb_info=ffff880130e0a800 count=1
[   45.758195] [drm] write mode info 144
[   45.994657] [drm] write mode info 144


