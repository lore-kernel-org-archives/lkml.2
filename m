Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1JOWXc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 18:23:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40168 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028Ab1JOWXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 18:23:31 -0400
Date: Sun, 16 Oct 2011 00:23:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: David Rientjes <rientjes@google.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Tejun Heo <tj@kernel.org>, Tejun Heo <htejun@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: at kernel/lockdep.c:690 __lock_acquire+0x168/0x164b()
Message-ID: <20111015222324.GA16432@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	David Rientjes <rientjes@google.com>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Tejun Heo <tj@kernel.org>, Tejun Heo <htejun@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20111015201239.GA3475@swordfish>
 <alpine.DEB.2.00.1110151436420.15894@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110151436420.15894@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 15, 2011 at 02:42:14PM -0700, David Rientjes wrote:
> On Sat, 15 Oct 2011, Sergey Senozhatsky wrote:
> 
> > [10172.218213] ------------[ cut here ]------------
> > [10172.218233] WARNING: at kernel/lockdep.c:690 __lock_acquire+0x168/0x164b()
> > [10172.218242] Hardware name: Aspire 5741G    
> > [10172.218248] Modules linked in: ipv6 usb_storage uas microcode snd_hda_codec_hdmi snd_hda_codec_realtek broadcom tg3 snd_hda_intel snd_hda_codec snd_pcm snd_timer snd rndis_host cdc_ether usbnet evdev psmouse soundcore pcspkr mii
> > snd_page_alloc libphy ac battery wmi button ehci_hcd sr_mod cdrom usbcore sd_mod ahci
> > [10172.218330] Pid: 22953, comm: kworker/0:2 Not tainted 3.1.0-rc9-dbg-00681-gec325b2 #730
> > [10172.218335] Call Trace:
> > [10172.218346]  [<ffffffff8103e7c8>] warn_slowpath_common+0x7e/0x96
> > [10172.218353]  [<ffffffff8103e7f5>] warn_slowpath_null+0x15/0x17
> > [10172.218361]  [<ffffffff8106fee5>] __lock_acquire+0x168/0x164b
> > [10172.218370]  [<ffffffff81034645>] ? find_busiest_group+0x7b6/0x941
> > [10172.218381]  [<ffffffff8102a5e3>] ? double_rq_lock+0x4d/0x52
> > [10172.218389]  [<ffffffff8107197e>] lock_acquire+0x138/0x1ac
> > [10172.218397]  [<ffffffff8102a5e3>] ? double_rq_lock+0x4d/0x52
> > [10172.218404]  [<ffffffff8102a5c4>] ? double_rq_lock+0x2e/0x52
> > [10172.218414]  [<ffffffff8148fb49>] _raw_spin_lock_nested+0x3a/0x49
> > [10172.218421]  [<ffffffff8102a5e3>] ? double_rq_lock+0x4d/0x52
> > [10172.218428]  [<ffffffff8148fabe>] ? _raw_spin_lock+0x3e/0x45
> > [10172.218435]  [<ffffffff8102a5c4>] ? double_rq_lock+0x2e/0x52
> > [10172.218442]  [<ffffffff8102a5e3>] double_rq_lock+0x4d/0x52
> > [10172.218449]  [<ffffffff810349cc>] load_balance+0x1fc/0x769
> > [10172.218458]  [<ffffffff810075c5>] ? native_sched_clock+0x38/0x65
> > [10172.218466]  [<ffffffff8148ca17>] ? __schedule+0x2f5/0xa2d
> > [10172.218474]  [<ffffffff8148caf5>] __schedule+0x3d3/0xa2d
> > [10172.218480]  [<ffffffff8148ca17>] ? __schedule+0x2f5/0xa2d
> > [10172.218490]  [<ffffffff8104db06>] ? add_timer_on+0xd/0x196
> > [10172.218497]  [<ffffffff8148fc02>] ? _raw_spin_lock_irq+0x4a/0x51
> > [10172.218505]  [<ffffffff8105907b>] ? process_one_work+0x3ed/0x54c
> > [10172.218512]  [<ffffffff81059126>] ? process_one_work+0x498/0x54c
> > [10172.218518]  [<ffffffff81058e1b>] ? process_one_work+0x18d/0x54c
> > [10172.218526]  [<ffffffff814902d0>] ? _raw_spin_unlock_irq+0x28/0x56
> > [10172.218533]  [<ffffffff81033950>] ? get_parent_ip+0xe/0x3e
> > [10172.218540]  [<ffffffff8148d26e>] schedule+0x55/0x57
> > [10172.218547]  [<ffffffff8105970f>] worker_thread+0x217/0x21c
> > [10172.218554]  [<ffffffff810594f8>] ? manage_workers.isra.21+0x16c/0x16c
> > [10172.218564]  [<ffffffff8105d4de>] kthread+0x9a/0xa2
> > [10172.218573]  [<ffffffff81497984>] kernel_thread_helper+0x4/0x10
> > [10172.218580]  [<ffffffff8102d6d2>] ? finish_task_switch+0x76/0xf3
> > [10172.218587]  [<ffffffff81490778>] ? retint_restore_args+0x13/0x13
> > [10172.218595]  [<ffffffff8105d444>] ? __init_kthread_worker+0x53/0x53
> > [10172.218602]  [<ffffffff81497980>] ? gs_change+0x13/0x13
> > [10172.218607] ---[ end trace 9d11d6b5e4b96730 ]---
> 
> I think this is a problem with lockdep itself, could you try reverting 
> f59de8992aa6 ("lockdep: Clear whole lockdep_map on initialization") if 
> this reliably happens everytime you reboot (lockdep will only emit this 
> once and then will suppress future warnings until the next boot)?
> 
> I think the new memset() is inadvertently clearing the name for 
> double_unlock_balance().

Great,

so I'm not the only one seeing the above:
http://marc.info/?l=linux-kernel&m=131468805610527

Due to it being very hard to reproduce, we dismissed it then as a
possible hw corruption.

But yeah, it looks like I have triggered it on -rc9 too, just the
other day. Oh, and I see -rc6 and -rc8 warnings in the logs too. Ok,
correction, not that hard to trigger.

Oct 11 09:08:11 liondog kernel: [15367.473110] ------------[ cut here ]------------
Oct 11 09:08:11 liondog kernel: [15367.473135] WARNING: at kernel/lockdep.c:690 __lock_acquire+0x173/0x17b5()
Oct 11 09:08:11 liondog kernel: [15367.473145] Hardware name: System Product Name
Oct 11 09:08:11 liondog kernel: [15367.473152] Modules linked in: cryptd aes_x86_64 aes_generic nls_iso8859_15 nls_cp437 tun cpufreq_powersave cpufreq_userspace cpufreq_conservative powernow_k8 mperf cpufreq_stats binfmt_misc fuse dm_crypt dm_mod ipv6 kvm_amd kvm vfat fat radeon 8250_pnp 8250 ttm drm_kms_helper cfbcopyarea edac_core serial_core cfbimgblt cfbfillrect k10temp
Oct 11 09:08:11 liondog kernel: [15367.473256] Pid: 0, comm: kworker/0:1 Not tainted 3.1.0-rc9-00005-g538d2882213e #5
Oct 11 09:08:11 liondog kernel: [15367.473264] Call Trace:
Oct 11 09:08:11 liondog kernel: [15367.473270]  <IRQ>  [<ffffffff810367ff>] warn_slowpath_common+0x83/0x9b
Oct 11 09:08:11 liondog kernel: [15367.473298]  [<ffffffff81036831>] warn_slowpath_null+0x1a/0x1c
Oct 11 09:08:11 liondog kernel: [15367.473309]  [<ffffffff810691fc>] __lock_acquire+0x173/0x17b5
Oct 11 09:08:11 liondog kernel: [15367.473321]  [<ffffffff8106a82c>] ? __lock_acquire+0x17a3/0x17b5
Oct 11 09:08:11 liondog kernel: [15367.473334]  [<ffffffff81029c53>] ? double_rq_lock+0x4d/0x52
Oct 11 09:08:11 liondog kernel: [15367.473346]  [<ffffffff8106ae67>] lock_acquire+0x154/0x198
Oct 11 09:08:11 liondog kernel: [15367.473356]  [<ffffffff81029c53>] ? double_rq_lock+0x4d/0x52
Oct 11 09:08:11 liondog kernel: [15367.473368]  [<ffffffff810659de>] ? put_lock_stats.isra.15+0xe/0x29
Oct 11 09:08:11 liondog kernel: [15367.473382]  [<ffffffff813c1c49>] _raw_spin_lock_nested+0x44/0x79
Oct 11 09:08:11 liondog kernel: [15367.473392]  [<ffffffff81029c53>] ? double_rq_lock+0x4d/0x52
Oct 11 09:08:11 liondog kernel: [15367.473403]  [<ffffffff813c1b84>] ? _raw_spin_lock+0x6c/0x73
Oct 11 09:08:11 liondog kernel: [15367.473413]  [<ffffffff81029c34>] ? double_rq_lock+0x2e/0x52
Oct 11 09:08:11 liondog kernel: [15367.473423]  [<ffffffff81029c53>] double_rq_lock+0x4d/0x52
Oct 11 09:08:11 liondog kernel: [15367.473434]  [<ffffffff8102e7d5>] load_balance+0x1b7/0x4f7
Oct 11 09:08:11 liondog kernel: [15367.473447]  [<ffffffff8102ec79>] rebalance_domains+0x164/0x1f9
Oct 11 09:08:11 liondog kernel: [15367.473458]  [<ffffffff8102eb15>] ? load_balance+0x4f7/0x4f7
Oct 11 09:08:11 liondog kernel: [15367.473470]  [<ffffffff8102edcb>] run_rebalance_domains+0xbd/0x12a
Oct 11 09:08:11 liondog kernel: [15367.473487]  [<ffffffff8103d180>] __do_softirq+0x165/0x2eb
Oct 11 09:08:11 liondog kernel: [15367.473499]  [<ffffffff81070ff4>] ? generic_smp_call_function_single_interrupt+0x9f/0xd8
Oct 11 09:08:11 liondog kernel: [15367.473512]  [<ffffffff813c472c>] call_softirq+0x1c/0x30
Oct 11 09:08:11 liondog kernel: [15367.473525]  [<ffffffff810036bb>] do_softirq+0x3d/0x86
Oct 11 09:08:11 liondog kernel: [15367.473535]  [<ffffffff8103d561>] irq_exit+0x53/0xbd
Oct 11 09:08:11 liondog kernel: [15367.473548]  [<ffffffff81018155>] smp_call_function_single_interrupt+0x34/0x37
Oct 11 09:08:11 liondog kernel: [15367.473560]  [<ffffffff813c41b0>] call_function_single_interrupt+0x70/0x80
Oct 11 09:08:11 liondog kernel: [15367.473567]  <EOI>  [<ffffffff8105b7f3>] ? local_clock+0xf/0x3b
Oct 11 09:08:11 liondog kernel: [15367.473586]  [<ffffffff8105b7f3>] ? local_clock+0xf/0x3b
Oct 11 09:08:11 liondog kernel: [15367.473598]  [<ffffffff810090b7>] ? default_idle+0xf1/0x1fd
Oct 11 09:08:11 liondog kernel: [15367.473610]  [<ffffffff810090b5>] ? default_idle+0xef/0x1fd
Oct 11 09:08:11 liondog kernel: [15367.473621]  [<ffffffff8100931a>] amd_e400_idle+0xc4/0xe7
Oct 11 09:08:11 liondog kernel: [15367.473632]  [<ffffffff8100074c>] cpu_idle+0x67/0xbe
Oct 11 09:08:11 liondog kernel: [15367.473645]  [<ffffffff813b54af>] start_secondary+0x1ad/0x1b2
Oct 11 09:08:11 liondog kernel: [15367.473655] ---[ end trace 63070f7e22365bb6 ]---

-- 
Regards/Gruss,
    Boris.
