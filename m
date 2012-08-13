Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab2HMJLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 05:11:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51791 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2HMJLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 05:11:45 -0400
Message-ID: <5028C4CC.9070301@gmail.com>
Date: Mon, 13 Aug 2012 17:11:40 +0800
From: Liu Bo <liub.liubo@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [BUG Report] BUG: unable to handle kernel NULL pointer dereference
 at
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm using mainline upstream 3.6.0-rc1 compiled based on Fedora-16.

When I unplug my mobile usb card, I hit this:

[  247.017258] BUG: unable to handle kernel NULL pointer dereference at           (null)
[  247.017378] IP: [<ffffffffa03bf27f>] stop_read_write_urbs+0x3f/0x90 [usb_wwan]
[  247.017484] PGD 0 
[  247.017518] Oops: 0000 [#1] SMP 
[  247.017572] Modules linked in: cdc_ether usbnet mii option usb_wwan usb_storage tcp_lp fuse lockd rfcomm bnep ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ext3 jbd arc4 iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_conexant btusb bluetooth i915 snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd_page_alloc thinkpad_acpi snd iwlwifi cfg80211 soundcore e1000e rfkill wmi drm_kms_helper drm i2c_i801 i2c_algo_bit i2c_core lpc_ich mfd_core pcspkr coretemp tpm_tis tpm tpm_bios joydev uinput crc32c_intel ghash_clmulni_intel sunrpc microcode video sdhci_pci sdhci mmc_core
[  247.018728] CPU 0 
[  247.018762] Pid: 34, comm: khubd Not tainted 3.6.0-rc1+ #2 LENOVO 4291HA6/4291HA6
[  247.018860] RIP: 0010:[<ffffffffa03bf27f>]  [<ffffffffa03bf27f>] stop_read_write_urbs+0x3f/0x90 [usb_wwan]
[  247.018991] RSP: 0018:ffff88021441dba0  EFLAGS: 00010286
[  247.019080] RAX: 0000000000000000 RBX: 0000000000000000 RCX: dead000000200200
[  247.019212] RDX: ffff8801f6225228 RSI: ffff8801f190f678 RDI: ffff8801f6224a10
[  247.019350] RBP: ffff88021441dbd0 R08: ffff8801f6224a28 R09: ffffea0007c66800
[  247.019489] R10: ffffffff812ceb05 R11: 5347203a30425355 R12: ffff880212a1a780
[  247.019629] R13: ffff880212a1a780 R14: 0000000000000000 R15: 0000000000000000
[  247.019771] FS:  0000000000000000(0000) GS:ffff88021e200000(0000) knlGS:0000000000000000
[  247.019928] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  247.020045] CR2: 0000000000000000 CR3: 00000002129ed000 CR4: 00000000000407f0
[  247.020184] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  247.020309] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  247.020450] Process khubd (pid: 34, threadinfo ffff88021441c000, task ffff880214b25c00)
[  247.020605] Stack:
[  247.020649]  ffff88021441dbb0 ffff880212a1a780 ffff8801f61fb830 ffff8801f6224800
[  247.020822]  0000000000000001 ffff880212a1a788 ffff88021441dbe0 ffffffffa03bf2de
[  247.020991]  ffff88021441dc30 ffffffff81463b8d ffff8801fab7a448 ffff8801f6220800
[  247.021163] Call Trace:
[  247.021228]  [<ffffffffa03bf2de>] usb_wwan_disconnect+0xe/0x10 [usb_wwan]
[  247.021370]  [<ffffffff81463b8d>] usb_serial_disconnect+0xdd/0x130
[  247.021506]  [<ffffffff8143165d>] usb_unbind_interface+0x5d/0x1b0
[  247.021635]  [<ffffffff813b19bc>] __device_release_driver+0x7c/0xe0
[  247.021739]  [<ffffffff813b1a4c>] device_release_driver+0x2c/0x40
[  247.021822]  [<ffffffff813b1373>] bus_remove_device+0xe3/0x150
[  247.021900]  [<ffffffff813adf00>] device_del+0x120/0x1b0
[  247.021974]  [<ffffffff8142f030>] usb_disable_device+0xb0/0x280
[  247.022066]  [<ffffffff81425d4d>] usb_disconnect+0x9d/0x140
[  247.022143]  [<ffffffff81428901>] hub_thread+0xba1/0x1720
[  247.022218]  [<ffffffff810807b0>] ? remove_wait_queue+0x50/0x50
[  247.022297]  [<ffffffff81427d60>] ? usb_remote_wakeup+0x70/0x70
[  247.022375]  [<ffffffff8107ff03>] kthread+0x93/0xa0
[  247.022443]  [<ffffffff81618944>] kernel_thread_helper+0x4/0x10
[  247.022520]  [<ffffffff8107fe70>] ? flush_kthread_worker+0xb0/0xb0
[  247.022601]  [<ffffffff81618940>] ? gs_change+0x13/0x13
[  247.022667] Code: 66 90 80 7f 1a 00 49 89 fd 74 5a 49 89 fc 31 db 0f 1f 40 00 49 8b 7c 24 20 45 31 f6 48 81 c7 10 02 00 00 e8 24 25 ff e0 49 89 c7 <4b> 8b 3c 37 49 83 c6 08 e8 a4 e0 06 e1 49 83 fe 20 75 ed 45 30 
[  247.023188] RIP  [<ffffffffa03bf27f>] stop_read_write_urbs+0x3f/0x90 [usb_wwan]
[  247.026877]  RSP <ffff88021441dba0>
[  247.030500] CR2: 0000000000000000
[  247.055642] ---[ end trace d12afd8ebf250ae7 ]---


thanks,
liubo
