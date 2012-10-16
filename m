Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2JPO3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:29:07 -0400
Received: from fieldses.org ([174.143.236.118]:55672 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab2JPO3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:29:05 -0400
Date: Tue, 16 Oct 2012 10:29:02 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: lenb@kernel.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_INTEL_IDLE causing crashes?
Message-ID: <20121016142902.GD30649@fieldses.org>
References: <20121005222357.GC30139@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121005222357.GC30139@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 06:23:57PM -0400, bfields wrote:
> I find that I can reliably crash 3.6 by booting to a kernel with
> CONFIG_INTEL_IDLE set and running
> 
> 	dd if=/dev/zero of=BIG

For any archives: see further discussion at

	https://bugzilla.redhat.com/show_bug.cgi?id=715485

Upgrading the BIOS or booting with intel_idle.max_cstate=0 work around
this particular problem for me.

--b.

> 
> If I turn off CONFIG_INTEL_IDLE there's no crash.  (dd just hits ENOSPC
> eventually.)
> 
> This isn't new--I originally saw it on 2.6.35.6.  (An upgrade to F14
> failed, and by trial and error I found CONFIG_INTEL_IDLE seemed to make
> the difference.)
> 
> I only see it on this one machine, which has an i7-870 and discrete ATI
> graphics.  Another machine with an i3-530 and integrated graphics, but
> otherwise similar hardware (they were built from the same barebones), is
> not crashing.
> 
> The first oops messages from one such crash follows.  (For what it's
> worth, my memory is that they aren't always in ext4--but I don't have
> any others in front of me.)
> 
> Any ideas?  Let me know of anything else that might be useful.
> 
> --b.
> 
> [   32.010103] stack segment: 0000 [#1] SMP 
> [   32.010135] Modules linked in: ipv6 cpufreq_ondemand acpi_cpufreq freq_table mperf uinput snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq iTCO_wdt snd_seq_device iTCO_vendor_support snd_pcm snd_timer snd microcode serio_raw lpc_ich i2c_i801 r8169 soundcore mii mfd_core snd_page_alloc usb_storage radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
> [   32.010401] CPU 1 
> [   32.010412] Pid: 1305, comm: dd Not tainted 3.6.0 #3 Shuttle Inc. SH55J/SH55J
> [   32.010439] RIP: 0010:[<ffffffff811a87d8>]  [<ffffffff811a87d8>] ext4_test_inode_state+0xd/0xf
> [   32.010476] RSP: 0018:ffff880234f6d958  EFLAGS: 00010246
> [   32.010495] RAX: 0000000000000000 RBX: ffff88022e35d570 RCX: ffff88022e168340
> [   32.010519] RDX: ffff880234f6d9e8 RSI: 0000000000000001 RDI: ffff88022e35d570
> [   32.010543] RBP: ffff880234f6d958 R08: ffff88022e10d168 R09: ffff88022e168340
> [   32.010566] R10: ffff88022e10d168 R11: ffff8802315b1dc0 R12: ffff88022e35d4c0
> [   32.010590] R13: ffff88022e35d4c0 R14: ffff88022a4c8900 R15: ffff88022e10d168
> [   32.010614] FS:  00007f8e5f83d700(0000) GS:ffff88023fc40000(0000) knlGS:0000000000000000
> [   32.010641] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   32.010661] CR2: ffffffffff600400 CR3: 0000000234d43000 CR4: 00000000000007e0
> [   32.010684] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   32.010708] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   32.010732] Process dd (pid: 1305, threadinfo ffff880234f6c000, task ffff8802315b16f0)
> [   32.010758] Stack:
> [   32.010767]  ffff880234f6d9b8 ffffffff811a89c4 ffff880234f6d9e8 ffff88022e35d570
> [   32.010806]  ffff88022e168340 ffff880234f6d9e8 0000000000000286 ffff88022e35d570
> [   32.010845]  ffff88022f302800 ffff88022e35d4c0 ffffffff811ab66e ffff88022e10d168
> [   32.010883] Call Trace:
> [   32.010896]  [<ffffffff811a89c4>] ext4_mark_iloc_dirty+0x73/0x5fb
> [   32.010918]  [<ffffffff811ab66e>] ? ext4_dirty_inode+0x33/0x4c
> [   32.010939]  [<ffffffff811ab608>] ext4_mark_inode_dirty+0x1bc/0x1ef
> [   32.010962]  [<ffffffff811e857b>] ? jbd2_journal_start+0x13/0x15
> [   32.010984]  [<ffffffff811ab66e>] ext4_dirty_inode+0x33/0x4c
> [   32.011006]  [<ffffffff8114c0aa>] __mark_inode_dirty+0x31/0x195
> [   32.011027]  [<ffffffff81152c20>] generic_write_end+0x67/0x79
> [   32.011047]  [<ffffffff811acf93>] ext4_da_write_end+0x1c4/0x245
> [   32.011070]  [<ffffffff810e5436>] ? iov_iter_copy_from_user_atomic+0x73/0xe3
> [   32.011094]  [<ffffffff810e5743>] generic_file_buffered_write+0x186/0x289
> [   32.011117]  [<ffffffff8114c0aa>] ? __mark_inode_dirty+0x31/0x195
> [   32.011139]  [<ffffffff810e693e>] __generic_file_aio_write+0x1c2/0x1f7
> [   32.011162]  [<ffffffff810e69eb>] generic_file_aio_write+0x78/0xdd
> [   32.011185]  [<ffffffff810e6979>] ? generic_file_aio_write+0x6/0xdd
> [   32.011207]  [<ffffffff811a6019>] ext4_file_write+0x3ec/0x43d
> [   32.011229]  [<ffffffff810713c0>] ? __dequeue_entity+0x33/0x38
> [   32.011251]  [<ffffffff8100e73b>] ? __switch_to+0x227/0x380
> [   32.011271]  [<ffffffff8107370e>] ? pick_next_task_fair+0xd4/0x126
> [   32.011294]  [<ffffffff8112b226>] do_sync_write+0x9d/0xda
> [   32.011314]  [<ffffffff8112bbc9>] vfs_write+0xae/0x10a
> [   32.011333]  [<ffffffff8112bce8>] sys_write+0x4a/0x71
> [   32.011352]  [<ffffffff814acca9>] system_call_fastpath+0x16/0x1b
> [   32.011373] Code: e8 a7 fe ff ff 85 c0 74 10 48 89 df e8 a7 fe ff ff 83 e0 01 83 f0 01 eb 02 31 c0 5b c9 c3 55 8d 46 20 48 89 e5 0f a3 47 a0 19 c0 <c9> c3 55 48 89 e5 41 54 53 48 83 ec 10 66 66 66 66 90 4c 8b 26 
> [   32.011766] RIP  [<ffffffff811a87d8>] ext4_test_inode_state+0xd/0xf
> [   32.011792]  RSP <ffff880234f6d958>
> [   32.011909] ---[ end trace 9aa419bb9a9cdab0 ]---
> [   32.011942] BUG: scheduling while atomic: dd/1305/0x10000001
> [   32.011968] Modules linked in: ipv6 cpufreq_ondemand acpi_cpufreq freq_table mperf uinput snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq iTCO_wdt snd_seq_device iTCO_vendor_support snd_pcm snd_timer snd microcode serio_raw lpc_ich i2c_i801 r8169 soundcore mii mfd_core snd_page_alloc usb_storage radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
> [   32.012246] Pid: 1305, comm: dd Tainted: G      D      3.6.0 #3
> [   32.012266] Call Trace:
> [   32.012277]  <#SS>  [<ffffffff8106ca92>] __schedule_bug+0x4d/0x59
> [   32.012308]  [<ffffffff814a4c6f>] __schedule+0xa2/0x569
> [   32.012328]  [<ffffffff8106feeb>] __cond_resched+0x2a/0x36
> [   32.012349]  [<ffffffff814a51b1>] _cond_resched+0x2c/0x37
> [   32.012370]  [<ffffffff814a485d>] down_read+0x16/0x28
> [   32.012389]  [<ffffffff810551df>] exit_signals+0x26/0x122
> [   32.014303]  [<ffffffff810655ac>] ? blocking_notifier_call_chain+0x14/0x16
> [   32.016112]  [<ffffffff81048164>] do_exit+0x113/0x7bb
> [   32.017940]  [<ffffffff814a3ed6>] ? printk+0x77/0x79
> [   32.019769]  [<ffffffff814a6fd7>] oops_end+0xc0/0xc8
> [   32.021789]  [<ffffffff81011c13>] die+0x5a/0x63
> [   32.023537]  [<ffffffff814a6be6>] do_trap+0x121/0x130
> [   32.025270]  [<ffffffff8100fcc5>] do_stack_segment+0x7a/0x9e
> [   32.026952]  [<ffffffff814a6415>] stack_segment+0x25/0x30
> [   32.028933]  [<ffffffff811a87d8>] ? ext4_test_inode_state+0xd/0xf
> [   32.030593]  <<EOE>>  [<ffffffff811a89c4>] ext4_mark_iloc_dirty+0x73/0x5fb
> [   32.032259]  [<ffffffff811ab66e>] ? ext4_dirty_inode+0x33/0x4c
> [   32.034125]  [<ffffffff811ab608>] ext4_mark_inode_dirty+0x1bc/0x1ef
> [   32.035763]  [<ffffffff811e857b>] ? jbd2_journal_start+0x13/0x15
> [   32.037417]  [<ffffffff811ab66e>] ext4_dirty_inode+0x33/0x4c
> [   32.039071]  [<ffffffff8114c0aa>] __mark_inode_dirty+0x31/0x195
> [   32.041029]  [<ffffffff81152c20>] generic_write_end+0x67/0x79
> [   32.042660]  [<ffffffff811acf93>] ext4_da_write_end+0x1c4/0x245
> [   32.044289]  [<ffffffff810e5436>] ? iov_iter_copy_from_user_atomic+0x73/0xe3
> [   32.046099]  [<ffffffff810e5743>] generic_file_buffered_write+0x186/0x289
> [   32.047672]  [<ffffffff8114c0aa>] ? __mark_inode_dirty+0x31/0x195
> [   32.049269]  [<ffffffff810e693e>] __generic_file_aio_write+0x1c2/0x1f7
> [   32.050862]  [<ffffffff810e69eb>] generic_file_aio_write+0x78/0xdd
> [   32.052430]  [<ffffffff810e6979>] ? generic_file_aio_write+0x6/0xdd
> [   32.054182]  [<ffffffff811a6019>] ext4_file_write+0x3ec/0x43d
> [   32.055723]  [<ffffffff810713c0>] ? __dequeue_entity+0x33/0x38
> [   32.057275]  [<ffffffff8100e73b>] ? __switch_to+0x227/0x380
> [   32.058825]  [<ffffffff8107370e>] ? pick_next_task_fair+0xd4/0x126
> [   32.060534]  [<ffffffff8112b226>] do_sync_write+0x9d/0xda
> [   32.062031]  [<ffffffff8112bbc9>] vfs_write+0xae/0x10a
> [   32.063548]  [<ffffffff8112bce8>] sys_write+0x4a/0x71
> [   32.065068]  [<ffffffff814acca9>] system_call_fastpath+0x16/0x1b
> [   32.066855] note: dd[1305] exited with preempt_count 1
> [   32.068341] ------------[ cut here ]------------
> [   32.069809] WARNING: at arch/x86/kernel/irq_64.c:70 handle_irq+0xf3/0x135()
> [   32.071293] Hardware name: SH55J
> [   32.072770] do_IRQ(): dd has overflown the kernel stack (cur:ffff880234f6c000,sp:ffff88023fc45cf8,irq stk top-bottom:ffff88023fc00080-ffff88023fc03fc0,exception stk top-bottom:ffff88023fc05080-ffff88023fc0b000)
> [   32.075898] Modules linked in: ipv6 cpufreq_ondemand acpi_cpufreq freq_table mperf uinput snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq iTCO_wdt snd_seq_device iTCO_vendor_support snd_pcm snd_timer snd microcode serio_raw lpc_ich i2c_i801 r8169 soundcore mii mfd_core snd_page_alloc usb_storage radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
> [   32.079345] Pid: 1305, comm: dd Tainted: G      D W    3.6.0 #3
> [   32.081004] Call Trace:
> [   32.082677]  <IRQ>  [<ffffffff8104324a>] warn_slowpath_common+0x85/0x9d
> [   32.084359]  [<ffffffff81043305>] warn_slowpath_fmt+0x46/0x48
> [   32.086039]  [<ffffffff810707df>] ? sched_clock_idle_wakeup_event+0x12/0x14
> [   32.087717]  [<ffffffff81010cb6>] handle_irq+0xf3/0x135
> [   32.089417]  [<ffffffff814ae67d>] do_IRQ+0x4d/0xb4
> [   32.091104]  [<ffffffff814a622a>] common_interrupt+0x6a/0x6a
> [   32.092784]  <EOI> 
> [   32.092793] ---[ end trace 9aa419bb9a9cdab1 ]---
> 
