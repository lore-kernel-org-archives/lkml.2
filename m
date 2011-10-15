Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab1JOUPF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 16:15:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34400 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab1JOUPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 16:15:02 -0400
Date: Sat, 15 Oct 2011 23:12:40 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: WARNING: at kernel/lockdep.c:690 __lock_acquire+0x168/0x164b()
Message-ID: <20111015201239.GA3475@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

3.1-rc9

[10172.218213] ------------[ cut here ]------------
[10172.218233] WARNING: at kernel/lockdep.c:690 __lock_acquire+0x168/0x164b()
[10172.218242] Hardware name: Aspire 5741G    
[10172.218248] Modules linked in: ipv6 usb_storage uas microcode snd_hda_codec_hdmi snd_hda_codec_realtek broadcom tg3 snd_hda_intel snd_hda_codec snd_pcm snd_timer snd rndis_host cdc_ether usbnet evdev psmouse soundcore pcspkr mii
snd_page_alloc libphy ac battery wmi button ehci_hcd sr_mod cdrom usbcore sd_mod ahci
[10172.218330] Pid: 22953, comm: kworker/0:2 Not tainted 3.1.0-rc9-dbg-00681-gec325b2 #730
[10172.218335] Call Trace:
[10172.218346]  [<ffffffff8103e7c8>] warn_slowpath_common+0x7e/0x96
[10172.218353]  [<ffffffff8103e7f5>] warn_slowpath_null+0x15/0x17
[10172.218361]  [<ffffffff8106fee5>] __lock_acquire+0x168/0x164b
[10172.218370]  [<ffffffff81034645>] ? find_busiest_group+0x7b6/0x941
[10172.218381]  [<ffffffff8102a5e3>] ? double_rq_lock+0x4d/0x52
[10172.218389]  [<ffffffff8107197e>] lock_acquire+0x138/0x1ac
[10172.218397]  [<ffffffff8102a5e3>] ? double_rq_lock+0x4d/0x52
[10172.218404]  [<ffffffff8102a5c4>] ? double_rq_lock+0x2e/0x52
[10172.218414]  [<ffffffff8148fb49>] _raw_spin_lock_nested+0x3a/0x49
[10172.218421]  [<ffffffff8102a5e3>] ? double_rq_lock+0x4d/0x52
[10172.218428]  [<ffffffff8148fabe>] ? _raw_spin_lock+0x3e/0x45
[10172.218435]  [<ffffffff8102a5c4>] ? double_rq_lock+0x2e/0x52
[10172.218442]  [<ffffffff8102a5e3>] double_rq_lock+0x4d/0x52
[10172.218449]  [<ffffffff810349cc>] load_balance+0x1fc/0x769
[10172.218458]  [<ffffffff810075c5>] ? native_sched_clock+0x38/0x65
[10172.218466]  [<ffffffff8148ca17>] ? __schedule+0x2f5/0xa2d
[10172.218474]  [<ffffffff8148caf5>] __schedule+0x3d3/0xa2d
[10172.218480]  [<ffffffff8148ca17>] ? __schedule+0x2f5/0xa2d
[10172.218490]  [<ffffffff8104db06>] ? add_timer_on+0xd/0x196
[10172.218497]  [<ffffffff8148fc02>] ? _raw_spin_lock_irq+0x4a/0x51
[10172.218505]  [<ffffffff8105907b>] ? process_one_work+0x3ed/0x54c
[10172.218512]  [<ffffffff81059126>] ? process_one_work+0x498/0x54c
[10172.218518]  [<ffffffff81058e1b>] ? process_one_work+0x18d/0x54c
[10172.218526]  [<ffffffff814902d0>] ? _raw_spin_unlock_irq+0x28/0x56
[10172.218533]  [<ffffffff81033950>] ? get_parent_ip+0xe/0x3e
[10172.218540]  [<ffffffff8148d26e>] schedule+0x55/0x57
[10172.218547]  [<ffffffff8105970f>] worker_thread+0x217/0x21c
[10172.218554]  [<ffffffff810594f8>] ? manage_workers.isra.21+0x16c/0x16c
[10172.218564]  [<ffffffff8105d4de>] kthread+0x9a/0xa2
[10172.218573]  [<ffffffff81497984>] kernel_thread_helper+0x4/0x10
[10172.218580]  [<ffffffff8102d6d2>] ? finish_task_switch+0x76/0xf3
[10172.218587]  [<ffffffff81490778>] ? retint_restore_args+0x13/0x13
[10172.218595]  [<ffffffff8105d444>] ? __init_kthread_worker+0x53/0x53
[10172.218602]  [<ffffffff81497980>] ? gs_change+0x13/0x13
[10172.218607] ---[ end trace 9d11d6b5e4b96730 ]---



Really not sure what's going on and how to reproduce.


	Sergey
