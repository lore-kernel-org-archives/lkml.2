Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471Ab1J3CDd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 22:03:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45736 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242Ab1J3CDb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 22:03:31 -0400
MIME-Version: 1.0
Date: Sat, 29 Oct 2011 22:03:29 -0400
Message-ID: <CAHFgRy93yyBh9KfOYKLP0+qr0oh8JQSO5YvOLZaauR-OSHap_w@mail.gmail.com>
Subject: 3.1.0+ (Linus GIT tree) - BUG: scheduling while atomic: cat/3303/0x00000102
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iwlwifi 0000:03:00.0: Error sending POWER_TABLE_CMD: time out after 2000ms.
iwlwifi 0000:03:00.0: Current CMD queue read_ptr 150 write_ptr 151
iwlwifi 0000:03:00.0: set power fail, ret = -110
cfg80211: Calling CRDA to update world regulatory domainBUG:
scheduling while atomic: cat/3303/0x00000102
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
iwlwifi 0000:03:00.0: Queue 4 stuck for 2000 ms.
iwlwifi 0000:03:00.0: Current read_ptr 150 write_ptr 151
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c:998
iwl_trans_pcie_send_cmd+0x34a/0x34f [iwlwifi]()
Hardware name: UL50VT
Modules linked in: snd_hrtimer rfcomm bnep bluetooth parport_pc
parport ipv6 snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm
snd_seq_dummy uvcvideo snd_seq_oss videodev v4l2_compat_ioctl32
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer iwlwifi
snd_seq_device psmouse mac80211 snd cfg80211 soundcore snd_page_alloc
evdev battery asus_laptop sparse_keymap rfkill ac power_supply
processor sr_mod sg cdrom atl1c thermal
Pid: 3303, comm: cat Not tainted 3.1.0+ #20
Call Trace:
 <IRQ>  [<ffffffff81036974>] warn_slowpath_common+0x7e/0x96
 [<ffffffff810369a1>] warn_slowpath_null+0x15/0x17
 [<ffffffffa017f04c>] iwl_trans_pcie_send_cmd+0x34a/0x34f [iwlwifi]
 [<ffffffff812d0afe>] ? dev_err+0x4e/0x50
 [<ffffffffa0174dd1>] iwl_cmd_echo_test+0x35/0x65 [iwlwifi]
 [<ffffffffa0174e45>] iwl_check_stuck_queue+0x44/0x6c [iwlwifi]
 [<ffffffffa0174eb9>] iwl_bg_watchdog+0x4c/0xb8 [iwlwifi]
 [<ffffffff8104406b>] run_timer_softirq+0x227/0x35b
 [<ffffffff81043f8d>] ? run_timer_softirq+0x149/0x35b
 [<ffffffffa0174e6d>] ? iwl_check_stuck_queue+0x6c/0x6c [iwlwifi]
 [<ffffffff8103ca37>] __do_softirq+0x129/0x24c
 [<ffffffff814128ec>] call_softirq+0x1c/0x30
 [<ffffffff810030bd>] do_softirq+0x38/0x83
 [<ffffffff8103cdcb>] irq_exit+0x58/0xc8
 [<ffffffff81018894>] smp_apic_timer_interrupt+0x76/0x84
 [<ffffffff81411170>] apic_timer_interrupt+0x70/0x80
 <EOI>  [<ffffffff81404f89>] ? __slab_alloc.isra.62.constprop.72+0x208/0x21a
 [<ffffffff811c769c>] ? aa_alloc_task_context+0x2d/0x3b
 [<ffffffff810f6e01>] ? getname_flags+0x2c/0x1db
 [<ffffffff811c769c>] ? aa_alloc_task_context+0x2d/0x3b
 [<ffffffff810f6e01>] ? getname_flags+0x2c/0x1db
 [<ffffffff810f6e01>] ? getname_flags+0x2c/0x1db
 [<ffffffff810e8cd0>] kmem_cache_alloc+0x4f/0x136
 [<ffffffff810f6e01>] getname_flags+0x2c/0x1db
 [<ffffffff810f886e>] user_path_at+0x26/0x91
 [<ffffffff810e8e69>] ? kmem_cache_alloc_trace+0xb2/0xc4
 [<ffffffff811c7700>] ? aa_dup_task_context+0x22/0x4a
 [<ffffffff811cb568>] ? apparmor_cred_prepare+0x31/0x40
 [<ffffffff8105aefd>] ? get_cred+0x22/0x29
 [<ffffffff8105af76>] ? override_creds+0x72/0x87
 [<ffffffff810ec85a>] sys_faccessat+0xa0/0x182
 [<ffffffff811fe51e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff810ec94f>] sys_access+0x13/0x15
 [<ffffffff8141063b>] system_call_fastpath+0x16/0x1b
---[ end trace 4974270bf412e95a ]---
BUG: scheduling while atomic: cat/3303/0x00000102
1 lock held by cat/3303:
 #0:  (&priv->watchdog){+.-...}, at: [<ffffffff81043f8d>]
run_timer_softirq+0x149/0x35b
Modules linked in: snd_hrtimer rfcomm bnep bluetooth parport_pc
parport ipv6 snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm
snd_seq_dummy uvcvideo snd_seq_oss videodev v4l2_compat_ioctl32
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer iwlwifi
snd_seq_device psmouse mac80211 snd cfg80211 soundcore snd_page_alloc
evdev battery asus_laptop sparse_keymap rfkill ac power_supply
processor sr_mod sg cdrom atl1c thermal
CPU 0
Modules linked in: snd_hrtimer rfcomm bnep bluetooth parport_pc
parport ipv6 snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm
snd_seq_dummy uvcvideo snd_seq_oss videodev v4l2_compat_ioctl32
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer iwlwifi
snd_seq_device psmouse mac80211 snd cfg80211 soundcore snd_page_alloc
evdev battery asus_laptop sparse_keymap rfkill ac power_supply
processor sr_mod sg cdrom atl1c thermal
Pid: 3303, comm: cat Tainted: G        W   3.1.0+ #20 ASUSTeK Computer
Inc.         UL50VT              /UL50VT    Oct 29 19:35:03 localhost
kernel: [ 3785.923634] RIP: 0010:[<ffffffff81404f89>]
[<ffffffff81404f89>] __slab_alloc.isra.62.constprop.72+0x208/0x21a
RSP: 0018:ffff88011ed1bd18  EFLAGS: 00000296
RAX: ffff8801189e93a0 RBX: ffff88013709c600 RCX: 0000000000000000
RDX: 000000000000ab92 RSI: 0000000000000001 RDI: ffff8801189e93a0
RBP: ffff88011ed1bda8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffff88013709d610
R13: 0000000000000007 R14: 0000000100070001 R15: ffffffff810f6e01
FS:  0000000000000000(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000060aed0 CR3: 000000011ed6f000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cat (pid: 3303, threadinfo ffff88011ed1a000, task ffff8801189e93a0)
Stack:
 ffffffff811c769c 0000000100160013 0000000000000009 ffffffff810f6e01
 ffffffff811c769c ffff880112fe69d8 ffff88011ed1bd88 ffff8801189e93a0
 0000000000000246 0000000000000080 00000000000000d0 ffffffff810f6e01
Call Trace:
 [<ffffffff811c769c>] ? aa_alloc_task_context+0x2d/0x3b
 [<ffffffff810f6e01>] ? getname_flags+0x2c/0x1db
 [<ffffffff811c769c>] ? aa_alloc_task_context+0x2d/0x3b
 [<ffffffff810f6e01>] ? getname_flags+0x2c/0x1db
 [<ffffffff810f6e01>] ? getname_flags+0x2c/0x1db
 [<ffffffff810e8cd0>] kmem_cache_alloc+0x4f/0x136
 [<ffffffff810f6e01>] getname_flags+0x2c/0x1db
 [<ffffffff810f886e>] user_path_at+0x26/0x91
 [<ffffffff810e8e69>] ? kmem_cache_alloc_trace+0xb2/0xc4
 [<ffffffff811c7700>] ? aa_dup_task_context+0x22/0x4a
 [<ffffffff811cb568>] ? apparmor_cred_prepare+0x31/0x40
 [<ffffffff8105aefd>] ? get_cred+0x22/0x29
 [<ffffffff8105af76>] ? override_creds+0x72/0x87
 [<ffffffff810ec85a>] sys_faccessat+0xa0/0x182
 [<ffffffff811fe51e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff810ec94f>] sys_access+0x13/0x15
 [<ffffffff8141063b>] system_call_fastpath+0x16/0x1b
Code: 00 48 89 03 e8 0f 3a ce ff c7 43 20 ff ff ff ff 41 f7 c6 00 02
00 00 75 0a 41 56 9d e8 9f 07 c6 ff eb 08 e8 bb 20 c6 ff 41 56 9d
Call Trace:
 [<ffffffff811c769c>] ? aa_alloc_task_context+0x2d/0x3b
 [<ffffffff810f6e01>] ? getname_flags+0x2c/0x1db
 [<ffffffff811c769c>] ? aa_alloc_task_context+0x2d/0x3b
 [<ffffffff810f6e01>] ? getname_flags+0x2c/0x1db
 [<ffffffff810f6e01>] ? getname_flags+0x2c/0x1db
 [<ffffffff810e8cd0>] kmem_cache_alloc+0x4f/0x136
 [<ffffffff810f6e01>] getname_flags+0x2c/0x1db
 [<ffffffff810f886e>] user_path_at+0x26/0x91
 [<ffffffff810e8e69>] ? kmem_cache_alloc_trace+0xb2/0xc4
 [<ffffffff811c7700>] ? aa_dup_task_context+0x22/0x4a
 [<ffffffff811cb568>] ? apparmor_cred_prepare+0x31/0x40
 [<ffffffff8105aefd>] ? get_cred+0x22/0x29
 [<ffffffff8105af76>] ? override_creds+0x72/0x87
 [<ffffffff810ec85a>] sys_faccessat+0xa0/0x182
 [<ffffffff811fe51e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff810ec94f>] sys_access+0x13/0x15
 [<ffffffff8141063b>] system_call_fastpath+0x16/0x1b
iwlwifi 0000:03:00.0: HCMD_ACTIVE already clear for command REPLY_ECHO
