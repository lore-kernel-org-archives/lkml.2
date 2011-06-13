Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab1FMSqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:46:43 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:37068 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab1FMSqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:46:40 -0400
Date: Mon, 13 Jun 2011 21:46:39 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: 3.0-rc2-00256 BUG at fs/inode.c:1368
Message-ID: <alpine.SOC.1.00.1106130830070.11247@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got this BUG in3.0.0-rc2-00256-gb99ca60 and processes are hanging:

Jun 13 07:54:28 tulp kernel: kernel BUG at fs/inode.c:1368!a
Jun 13 07:54:28 tulp kernel: invalid opcode: 0000 [#1] 
Jun 13 07:54:28 tulp kernel: Modules linked in: speedstep_lib cpufreq_ondemand cpufreq_conservative mperf cpufreq_stats freq_table lp bnep rfcomm bluetooth uinput fuse cpufreq_powersave cpufreq_userspace snd_cs4281 gameport snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_opl3_lib snd_hwdep thinkpad_acpi rfkill snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device pcmcia snd uhci_hcd ehci_hcd yenta_socket pcmcia_rsrc battery usbcore parport_pc pcmcia_core soundcore evdev psmouse serio_raw pcspkr parport ac intel_agp intel_gtt agpgart thermal processor button
Jun 13 07:54:28 tulp kernel: 
Jun 13 07:54:28 tulp kernel: Pid: 296, comm: kswapd0 Not tainted 3.0.0-rc2-00256-gb99ca60 #55 IBM 266231G/266231G
Jun 13 07:54:28 tulp kernel: EIP: 0060:[<c10aedb9>] EFLAGS: 00010202 CPU: 0
Jun 13 07:54:28 tulp kernel: EIP is at iput+0x29/0x30
Jun 13 07:54:28 tulp kernel: EAX: d37d79e8 EBX: d37d79e8 ECX: d3a58b58 EDX: 00000000
Jun 13 07:54:28 tulp kernel: ESI: d261d240 EDI: d37d79e8 EBP: d3889e34 ESP: d3889e30
Jun 13 07:54:28 tulp kernel:  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
Jun 13 07:54:28 tulp kernel: Process kswapd0 (pid: 296, ti=d3888000 task=d38ffb80 task.ti=d3888000)
Jun 13 07:54:28 tulp kernel: Stack:
Jun 13 07:54:28 tulp kernel:  d3a58b58 d3889e4c c10c9707 00000000 d3889e34 d3a58b58 d3889e54 d3889e68
Jun 13 07:54:28 tulp kernel:  c10c91f3 d3a58b78 d3a58b78 d37d79e8 c131d1e0 00000080 d3889e70 c10c8628
Jun 13 07:54:28 tulp kernel:  d3889e7c c10ae40d d37d79e8 d3889e88 c10ae845 d37d79e8 d3889e98 c10ae922
Jun 13 07:54:28 tulp kernel: Call Trace:
Jun 13 07:54:28 tulp kernel:  [<c10c9707>] fsnotify_destroy_mark+0xe7/0x100
Jun 13 07:54:28 tulp kernel:  [<c10c91f3>] fsnotify_clear_marks_by_inode+0x83/0xa0
Jun 13 07:54:29 tulp kernel:  [<c10c8628>] __fsnotify_inode_delete+0x8/0x10
Jun 13 07:54:29 tulp kernel:  [<c10ae40d>] __destroy_inode+0x1d/0x90
Jun 13 07:54:29 tulp kernel:  [<c10ae845>] destroy_inode+0x15/0x50
Jun 13 07:54:29 tulp kernel:  [<c10ae922>] evict+0xa2/0x130
Jun 13 07:54:29 tulp kernel:  [<c10ae9d7>] dispose_list+0x27/0x40
Jun 13 07:54:29 tulp kernel:  [<c10aee93>] prune_icache+0xd3/0x1f0
Jun 13 07:54:29 tulp kernel:  [<c10aefcb>] shrink_icache_memory+0x1b/0x40
Jun 13 07:54:29 tulp kernel:  [<c1076e1f>] shrink_slab+0x10f/0x170
Jun 13 07:54:29 tulp kernel:  [<c1078756>] balance_pgdat+0x2e6/0x520
Jun 13 07:54:29 tulp kernel:  [<c1078abc>] kswapd+0x12c/0x140
Jun 13 07:54:29 tulp kernel:  [<c1078990>] ? balance_pgdat+0x520/0x520
Jun 13 07:54:29 tulp kernel:  [<c103a567>] kthread+0x67/0x70
Jun 13 07:54:29 tulp kernel:  [<c103a500>] ? kthread_worker_fn+0x110/0x110
Jun 13 07:54:29 tulp kernel:  [<c130e97e>] kernel_thread_helper+0x6/0xd
Jun 13 07:54:29 tulp kernel: Code: ff 90 55 85 c0 89 e5 53 89 c3 74 1c f6 40 18 40 75 19 8d 50 14 8d 40 5c e8 35 5e 0c 00 85 c0 74 07 89 d8 e8 3a fc ff ff 5b 5d c3 <0f> 0b 90 8d 74 26 00 55 89 e5 57 89 c7 56 8d 45 ec 53 83 ec 10 
Jun 13 07:54:29 tulp kernel: EIP: [<c10aedb9>] iput+0x29/0x30 SS:ESP 0068:d3889e30

-- 
Meelis Roos (mroos@linux.ee)
