Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab0HXJIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:08:48 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55554 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab0HXJIp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:08:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DXOsi8kI22N2oYvRiFbnp80JzSyJpYrXzR1tgmn02RR1ymXgTuwyAXSlMH7VAxIYAv
         EzpypxXVV2Ha517V6c7++HQq7qkX9A9TIcacdLVz5RjtjqeUCX7F06GZRvh+LSa4LAdp
         F+5xencp7tJhxP/yrnoqYQuUdjtDd2uHjvc2U=
MIME-Version: 1.0
In-Reply-To: <20100813134756.GA5235@swordfish.minsk.epam.com>
References: <20100813134756.GA5235@swordfish.minsk.epam.com>
Date: Tue, 24 Aug 2010 17:08:43 +0800
Message-ID: <AANLkTindn3Sdbbv-4vjf+5MO4T_s_1e759Mkf1Mpbuz1@mail.gmail.com>
Subject: Re: general protection fault: 0000 [#1] PREEMPT SMP
From: Yong Zhang <yong.zhang0@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 9:47 PM, Sergey Senozhatsky
<sergey.senozhatsky@gmail.com> wrote:
> Hello,
>
> Got this traces today:
>
> [   29.940248] CPU 1 is now offline
> [   29.941025] general protection fault: 0000 [#1] PREEMPT SMP
> [   29.941103] last sysfs file: /sys/devices/system/cpu/cpu1/online
> [   29.941157] CPU 0
> [   29.941178] Modules linked in: snd_hwdep snd_hda_codec_atihdmi snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device battery ac wmi snd_pcm_oss snd_mixer_oss button snd_hda_codec_realtek radeon broadcom snd_hda_intel
> snd_hda_codec snd_pcm snd_timer snd soundcore snd_page_alloc usbhid hid tg3 libphy psmouse serio_raw evdev ttm drm_kms_helper ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   29.941679]
> [   29.941699] Pid: 5208, comm: bash Not tainted 2.6.36-rc0-git12-07921-g60bf26a-dirty #124 Aspire 5741G    /Aspire 5741G
> [   29.941792] RIP: 0010:[<ffffffff810640a1>]  [<ffffffff810640a1>] __lock_acquire+0x4e9/0x17fd
> [   29.941878] RSP: 0018:ffff88015751dbc8  EFLAGS: 00010082
> [   29.941926] RAX: 0000000000000001 RBX: ffff880152284920 RCX: 0000000000000000
> [   29.941988] RDX: dead4ead00000202 RSI: 0000000000000000 RDI: ffff880152284920
> [   29.942049] RBP: ffff88015751dca8 R08: 0000000000000002 R09: 0000000000000001
> [   29.942111] R10: 0000000000000000 R11: 0000000000000005 R12: ffff8801504c3f60
> [   29.942171] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000002
> [   29.942233] FS:  00007f53580ca700(0000) GS:ffff880002200000(0000) knlGS:0000000000000000
> [   29.942303] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   29.942353] CR2: 00007fb030079000 CR3: 0000000151b5a000 CR4: 00000000000006f0
> [   29.942414] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   29.942475] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   29.942536] Process bash (pid: 5208, threadinfo ffff88015751c000, task ffff8801504c3f60)
> [   29.942604] Stack:
> [   29.942625]  ffff8801569a4888 ffff88015751dc48 ffff88015751dcb8 ffffffff81132b2a
> [   29.942702] <0> ffff8801504c3f60 0000000000000001 ffff880100000000 ffffffff8186c0a0
> [   29.942789] <0> ffffffff00000000 0000000000000004 ffff8801504c3f60 ffff8801504c3f60
> [   29.942880] Call Trace:
> [   29.942910]  [<ffffffff81132b2a>] ? sysfs_deactivate+0x3e/0xec
> [   29.942966]  [<ffffffff81062ddd>] ? mark_held_locks+0x50/0x72
> [   29.943019]  [<ffffffff81065893>] lock_acquire+0x97/0xb6
> [   29.943072]  [<ffffffff8137145b>] ? percpu_counter_hotcpu_callback+0x3e/0x93
> [   29.943136]  [<ffffffff81374321>] ? mutex_lock_nested+0x2f3/0x31b
> [   29.943192]  [<ffffffff81371446>] ? percpu_counter_hotcpu_callback+0x29/0x93
> [   29.943257]  [<ffffffff8137568d>] _raw_spin_lock_irqsave+0x4e/0x60
> [   29.943313]  [<ffffffff8137145b>] ? percpu_counter_hotcpu_callback+0x3e/0x93
> [   29.943376]  [<ffffffff8137145b>] percpu_counter_hotcpu_callback+0x3e/0x93
> [   29.943441]  [<ffffffff81057344>] notifier_call_chain+0x32/0x5e
> [   29.943494]  [<ffffffff8105738f>] __raw_notifier_call_chain+0x9/0xb
> [   29.943552]  [<ffffffff8103c6e3>] __cpu_notify+0x1b/0x2d
> [   29.943602]  [<ffffffff8103c703>] cpu_notify+0xe/0x10
> [   29.943649]  [<ffffffff8103c70e>] cpu_notify_nofail+0x9/0x11
> [   29.943703]  [<ffffffff81362d82>] _cpu_down+0x151/0x206
> [   29.943751]  [<ffffffff81362ea8>] cpu_down+0x28/0x35
> [   29.943798]  [<ffffffff8136430d>] store_online+0x27/0x6e
> [   29.943850]  [<ffffffff812923ab>] sysdev_store+0x1b/0x1d
> [   29.943899]  [<ffffffff811321b2>] sysfs_write_file+0x103/0x13f
> [   29.943955]  [<ffffffff810daf92>] vfs_write+0xb0/0x14f
> [   29.944003]  [<ffffffff810db22e>] sys_write+0x45/0x6c
> [   29.944054]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   29.946132] Code: 85 c0 0f 84 a4 12 00 00 be 0b 03 00 00 83 3d 5e c4 f5 00 00 0f 85 92 12 00 00 e9 a4 11 00 00 45 31 f6 48 85 d2 0f 84 81 12 00 00 <f0> ff 82 98 01 00 00 45 8b 84 24 20 07 00 00 83 3d 79 ce 6a 00
> [   29.951109] RIP  [<ffffffff810640a1>] __lock_acquire+0x4e9/0x17fd
> [   29.953421]  RSP <ffff88015751dbc8>
> [   29.965605] ---[ end trace 34832156140843b2 ]---
> [   29.967758] note: bash[5208] exited with preempt_count 1
> [   29.969997] BUG: scheduling while atomic: bash/5208/0x10000002
> [   29.972098] INFO: lockdep is turned off.
> [   29.974167] Modules linked in: snd_hwdep snd_hda_codec_atihdmi snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device battery ac wmi snd_pcm_oss snd_mixer_oss button snd_hda_codec_realtek radeon broadcom snd_hda_intel
> snd_hda_codec snd_pcm snd_timer snd soundcore snd_page_alloc usbhid hid tg3 libphy psmouse serio_raw evdev ttm drm_kms_helper ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   29.981076] Pid: 5208, comm: bash Tainted: G      D     2.6.36-rc0-git12-07921-g60bf26a-dirty #124
> [   29.983375] Call Trace:
> [   29.985672]  [<ffffffff8102dd6a>] __schedule_bug+0x72/0x77
> [   29.987996]  [<ffffffff81372790>] schedule+0xdc/0x8f2
> [   29.990342]  [<ffffffff810360f9>] __cond_resched+0x13/0x1f
> [   29.992607]  [<ffffffff813730c5>] _cond_resched+0x29/0x30
> [   29.994912]  [<ffffffff810bbe97>] unmap_vmas+0x747/0x92b
> [   29.997198]  [<ffffffff810c15cd>] exit_mmap+0xda/0x184
> [   29.999410]  [<ffffffff8103888e>] mmput+0x28/0xcf
> [   30.001623]  [<ffffffff8103cd21>] exit_mm+0x109/0x116
> [   30.003791]  [<ffffffff81375db0>] ? _raw_spin_unlock_irq+0x55/0x59
> [   30.005931]  [<ffffffff8103e387>] do_exit+0x1fe/0x6c0
> [   30.008070]  [<ffffffff8103c6a5>] ? kmsg_dump+0x14f/0x16a
> [   30.010205]  [<ffffffff810060c4>] oops_end+0x8f/0x94
> [   30.012285]  [<ffffffff81006206>] die+0x55/0x5e
> [   30.014369]  [<ffffffff8100371c>] do_general_protection+0x135/0x13d
> [   30.016453]  [<ffffffff81376304>] ? irq_return+0x0/0xc
> [   30.018546]  [<ffffffff813764e5>] general_protection+0x25/0x30
> [   30.020643]  [<ffffffff810640a1>] ? __lock_acquire+0x4e9/0x17fd
> [   30.022719]  [<ffffffff81132b2a>] ? sysfs_deactivate+0x3e/0xec
> [   30.024804]  [<ffffffff81062ddd>] ? mark_held_locks+0x50/0x72
> [   30.026883]  [<ffffffff81065893>] lock_acquire+0x97/0xb6
> [   30.028932]  [<ffffffff8137145b>] ? percpu_counter_hotcpu_callback+0x3e/0x93
> [   30.031017]  [<ffffffff81374321>] ? mutex_lock_nested+0x2f3/0x31b
> [   30.033076]  [<ffffffff81371446>] ? percpu_counter_hotcpu_callback+0x29/0x93
> [   30.035171]  [<ffffffff8137568d>] _raw_spin_lock_irqsave+0x4e/0x60
> [   30.037272]  [<ffffffff8137145b>] ? percpu_counter_hotcpu_callback+0x3e/0x93
> [   30.039372]  [<ffffffff8137145b>] percpu_counter_hotcpu_callback+0x3e/0x93
> [   30.041515]  [<ffffffff81057344>] notifier_call_chain+0x32/0x5e
> [   30.043653]  [<ffffffff8105738f>] __raw_notifier_call_chain+0x9/0xb
> [   30.045777]  [<ffffffff8103c6e3>] __cpu_notify+0x1b/0x2d
> [   30.047927]  [<ffffffff8103c703>] cpu_notify+0xe/0x10
> [   30.050049]  [<ffffffff8103c70e>] cpu_notify_nofail+0x9/0x11
> [   30.052172]  [<ffffffff81362d82>] _cpu_down+0x151/0x206
> [   30.054308]  [<ffffffff81362ea8>] cpu_down+0x28/0x35
> [   30.056413]  [<ffffffff8136430d>] store_online+0x27/0x6e
> [   30.058546]  [<ffffffff812923ab>] sysdev_store+0x1b/0x1d
> [   30.060537]  [<ffffffff811321b2>] sysfs_write_file+0x103/0x13f
> [   30.062357]  [<ffffffff810daf92>] vfs_write+0xb0/0x14f
> [   30.064167]  [<ffffffff810db22e>] sys_write+0x45/0x6c
> [   30.065943]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b

Seems this is resolved by commit 602586a8, can you try it?

Thanks,
Yong
