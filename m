Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab2H3J6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 05:58:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49946 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab2H3J6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 05:58:15 -0400
Date: Thu, 30 Aug 2012 11:58:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jeff Garzik <jgarzik@pobox.com>, Mikael Pettersson <mikpe@it.uu.se>
Cc: Adko Branil <adkobranil@yahoo.com>, linux-ide <linux-ide@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: HDD problem, software bug, bios bug, or hardware ?
Message-ID: <20120830095808.GB24680@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jeff Garzik <jgarzik@pobox.com>, Mikael Pettersson <mikpe@it.uu.se>,
	Adko Branil <adkobranil@yahoo.com>,
	linux-ide <linux-ide@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <1345901771.8871.YahooMailNeo@web124706.mail.ne1.yahoo.com>
 <20120826130152.GA20021@liondog.tnic>
 <1346086872.65665.YahooMailNeo@web124704.mail.ne1.yahoo.com>
 <20120827215952.GA18719@liondog.tnic>
 <1346259574.81504.YahooMailNeo@web124706.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1346259574.81504.YahooMailNeo@web124706.mail.ne1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok,

one thing at a time.

Adding Jeff and Mikael.

Guys, I'm leaving in the whole mail thread with all the info.

Right near the end there's a lockdep warning about a deadlock
between sata_promise's hardreset thing and the machine getting a
ata_bmdma_interrupt.

But since I don't know this code, it would be nice if you could take a
look at it.

Kernel is 3.5.2, 32-bit.

Thanks.

On Wed, Aug 29, 2012 at 09:59:34AM -0700, Adko Branil wrote:
> Sorry for the delay, but i have met some difficulties, compiling kernel with this options.
> 
> >You mean 1 Gb each, right?
> 
> Right, now both banks are installed.
> 
> 
> >Ok, judging by the oopses this time, most of them are in handle_irq
> >and "nosmp" disables IO APIC so things start to point at something irq
> >handling related, if I would have to guess.
> 
> >Hm, ok, can you rebuild that 3.5.2 kernel with the following options
> >enabled:
> 
> >CONFIG_DEBUG_KERNEL
> >CONFIG_DEBUG_SHIRQ
> >CONFIG_DEBUG_OBJECTS
> >CONFIG_DEBUG_PREEMPT
> >CONFIG_PROVE_LOCKING
> >CONFIG_DEBUG_BUGVERBOSE
> >CONFIG_DEBUG_INFO
> >CONFIG_DEBUG_VM
> >CONFIG_DEBUG_MEMORY_INIT
> >CONFIG_DEBUG_LIST
> >CONFIG_DEBUG_RODATA
> 
> >Those are all under "Kernel Hacking". Then boot this new kernel and
> >catch the whole dmesg up and including a couple of oopses and send them
> >to me.
> 
> >But do not boot with "nosmp" - we want to see whether default SMP kernel
> >still triggers.
> 
> 
> First to say that from time to time appears in the system messages lines like this:
> 
>  [  918.496046] [drm] nouveau 0000:01:00.0: Setting dpms mode 1 on vga encoder (output 0)
>  [ 3308.960038] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on vga encoder (output 0)
>  [ 4211.680033] [drm] nouveau 0000:01:00.0: Setting dpms mode 1 on vga encoder (output 0)
> 
> even in the time when nobody touches the computer, so i removed this nvidia GPU, but the hangs continued, then i put it back.
> 
> Now about the debug kernel:
> There was no such option CONFIG_DEBUG_PREEMPT at first, as my model was "Voluntary Kernel Preemption (Desktop)"(hangs were on such compiled kernels), then i switched to "Preemptible Kernel (Low-Latency Desktop)" , enabled all this options, and compiled the kernel, but it refused to work - blank screen from the beginning, even not "Decompressing Linux ...". I succeed to run this kernel on a virtual machine, but it refuses to run on the "buggy machine" - "this kernel"="the same binary". Then switched this option back,to try if this kernel run. If it is vital to be "Preemptible Kernel (Low-Latency Desktop)" , i will try to do it again, but now i switched to "Voluntary Kernel Preemption (Desktop)" enabled the option you require, compilled kernel, and then interesting thing happened - every time when i do "make modules_install" - the machine hangs at some arbitrary point, during the process of modules installation, with "kernel pannic" - i saved few such
>  messages, and will put it below. Then i thought it could be some bad blocks (recently i have checked this HDD with badblocks - it is fine). But it is not the case - i can read all the directory with "find /usr/src/linux -type f | xargs md5sum), and can make big file as "dd if=/dev/zero of=file bs=512M cound=2"(the size of /lib/modules/3.5.2 after hang vary from few kb, to ~400Mb). Then i passed "nosmp" at boot time - the same picture, but when i enabled swap, it managed to install the modules ! So the kernel debug is running for 1.5 hour, without hang,  with all option you require, except CONFIG_DEBUG_PREEMPT. And when i did again "make modules_install" twice, it crashed during the second. I log on this machine trough internet, and it disappeared after the last crash, probably before "make modules_install" manage to install LAN driver, i suppose, and will be able to continue this tests just tomorow. So i have no "couple" oopses, but 1 i have. Now i put
>  link to .config, 4 oopses during "make modules_install", first 2 are from 3.2.27 without "nosmp", 3th is with "nosmp",and the last - 4th is from 2.5.2 (debug) without "nosmp", and whole dmesg after it:
> 
> /usr/src/linux/.config:  http://pastebin.com/tRimKcp1
> 
> 3.2.27
> 
> [  127.451016] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
> [  127.451069] IP: [<ffffffff819f9440>] start_show+0x30/0x30
> [  127.451069] PGD 0 
> [  127.451069] Oops: 0002 [#1] SMP 
> [  127.451069] CPU 1 
> [  127.451069] Modules linked in: netconsole snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss ipt_REJECT xt_tcpudp iptable_raw iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_filter ip_tables x_tables lp fuse nouveau mxm_wmi wmi video ttm snd_via82xx drm_kms_helper snd_ac97_codec amd64_agp drm i2c_algo_bit agpgart shpchp k8temp snd_mpu401_uart snd_rawmidi snd_seq_device snd_pcm snd_page_alloc snd_timer snd processor thermal_sys i2c_viapro hwmon soundcore ac97_bus gameport ppdev skge i2c_core parport_pc parport button evdev loop
> [  127.451069] 
> [  127.451069] Pid: 0, comm: swapper/1 Not tainted 3.2.27 #2 To Be Filled By O.E.M. To Be Filled By O.E.M./A8V Deluxe
> [  127.451069] RIP: 0010:[<ffffffff819f9440>]  [<ffffffff819f9440>] start_show+0x30/0x30
> [  127.451069] RSP: 0018:ffff88007fd03f00  EFLAGS: 00010006
> [  127.451069] RAX: 0000000000000001 RBX: ffffffff820c2fc0 RCX: ffff88007d0ec4c0
> [  127.451069] RDX: ffff88007fd11c40 RSI: 0000000000000000 RDI: ffffffff820c2fc0
> [  127.451069] RBP: ffff88007fd03f28 R08: 0000000000000000 R09: 0000000000000000
> [  127.451069] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000000007e
> [  127.451069] R13: 0000000056606b05 R14: 00000000000177f2 R15: 0000000000000000
> [  127.451069] FS:  00007f15a6e18740(0000) GS:ffff88007fd00000(0000) knlGS:00000000f6f85700
> [  127.451069] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  127.451069] CR2: 0000000000000001 CR3: 0000000075dc7000 CR4: 00000000000006e0
> [  127.451069] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  127.451069] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  127.451069] Process swapper/1 (pid: 0, threadinfo ffff88007bd18000, task ffff88007d0ec4c0)
> [  127.451069] Stack:
> [  127.451069]  ffffffff8107df04 ffff88007fd0d300 0000000000000001 000000000000d300
> [  127.451069]  0000000000000000 ffff88007fd03f68 ffffffff81085b1d 0000000000000000
> [  127.451069]  0000000000000096 0000000000000000 0000000000000001 0000000000000000
> [  127.451069] Call Trace:
> [  127.451069]  <IRQ> 
> [  127.451069]  [<ffffffff8107df04>] ? ktime_get+0x64/0xe0
> [  127.451069]  [<ffffffff81085b1d>] tick_check_idle+0x5d/0xd0
> [  127.451069]  [<ffffffff8105a749>] irq_enter+0x69/0x70
> [  127.451069]  [<ffffffff81b31653>] smp_apic_timer_interrupt+0x43/0x99
> [  127.451069]  [<ffffffff81b2f9cb>] apic_timer_interrupt+0x6b/0x70
> [  127.451069]  <EOI> 
> [  127.451069]  [<ffffffff8107aa58>] ? sched_clock_cpu+0xa8/0x120
> [  127.451069]  [<ffffffff8100a89a>] ? default_idle+0x5a/0x180
> [  127.451069]  [<ffffffff810009b6>] cpu_idle+0xf6/0x110
> [  127.944008]  [<ffffffff81b146ea>] start_secondary+0x1cf/0x1d6
> [  127.944008] Code: 66 66 66 90 48 8b 0f 48 c7 c2 0d 46 dc 81 48 89 f0 be 00 10 00 00 48 89 c7 31 c0 e8 5b 71 b9 ff 5d 48 98 c3 0f 1f 80 00 00 00 00 <55> 48 89 e5 66 66 66 66 90 8b 15 39 31 6f 00 ed 25 ff ff ff 00 
> [  127.944008] RIP  [<ffffffff819f9440>] start_show+0x30/0x30
> [  127.944008]  RSP <ffff88007fd03f00>
> [  127.944008] CR2: 0000000000000001
> [  127.944008] ---[ end trace 01731399a4823159 ]---
> [  127.944008] Kernel panic - not syncing: Fatal exception in interrupt
> [  127.944008] Pid: 0, comm: swapper/1 Tainted: G      D      3.2.27 #2
> [  127.944008] Call Trace:
> [  127.944008]  <IRQ>  [<ffffffff81b1aeea>] panic+0x91/0x189
> [  127.944008]  [<ffffffff81005491>] oops_end+0x91/0xa0
> [  127.944008]  [<ffffffff81b1a85f>] no_context+0x1fa/0x225
> [  127.944008]  [<ffffffff8167cb70>] ? scsi_request_fn+0xa0/0x4a0
> [  127.944008]  [<ffffffff81b1aa3b>] __bad_area_nosemaphore+0x1b1/0x1d0
> [  127.944008]  [<ffffffff81b1aa6d>] bad_area_nosemaphore+0x13/0x15
> [  127.944008]  [<ffffffff81028794>] do_page_fault+0x2b4/0x480
> [  127.944008]  [<ffffffff81586d37>] ? kobject_put+0x27/0x60
> [  127.944008]  [<ffffffff8163d387>] ? put_device+0x17/0x20
> [  127.944008]  [<ffffffff8167dbda>] ? scsi_next_command+0x4a/0x60
> [  127.944008]  [<ffffffff8167dfee>] ? scsi_io_completion+0x39e/0x5c0
> [  127.944008]  [<ffffffff81b2ea2f>] page_fault+0x1f/0x30
> [  127.944008]  [<ffffffff819f9440>] ? start_show+0x30/0x30
> [  127.944008]  [<ffffffff8107df04>] ? ktime_get+0x64/0xe0
> [  127.944008]  [<ffffffff81085b1d>] tick_check_idle+0x5d/0xd0
> [  127.944008]  [<ffffffff8105a749>] irq_enter+0x69/0x70
> [  127.944008]  [<ffffffff81b31653>] smp_apic_timer_interrupt+0x43/0x99
> [  127.944008]  [<ffffffff81b2f9cb>] apic_timer_interrupt+0x6b/0x70
> [  127.944008]  <EOI>  [<ffffffff8107aa58>] ? sched_clock_cpu+0xa8/0x120
> [  127.944008]  [<ffffffff8100a89a>] ? default_idle+0x5a/0x180
> [  127.944008]  [<ffffffff810009b6>] cpu_idle+0xf6/0x110
> [  127.944008]  [<ffffffff81b146ea>] start_secondary+0x1cf/0x1d6
> [  127.944008] panic occurred, switching back to text console
> [  127.944008] Rebooting in 10 seconds..
> 
> 
> 
> 
> **************************************************************************************
> 2
> 
> 
> 3.2.27
> 
> [  881.391001] BUG: unable to handle kernel paging request at ffff88007fd03ef8
> [  881.391001] IP: [<ffff88007fd03ef8>] 0xffff88007fd03ef7
> [  881.391001] PGD 2006063 PUD 1fffc067 PMD 800000007fc001e3 
> [  881.391001] Oops: 0011 [#1] SMP 
> [  881.391001] CPU 1 
> [  881.391001] Modules linked in: netconsole snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss ipt_REJECT xt_tcpudp iptable_raw iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_filter ip_tables x_tables lp fuse nouveau mxm_wmi wmi video ttm drm_kms_helper snd_via82xx snd_ac97_codec snd_mpu401_uart snd_rawmidi drm processor ppdev snd_seq_device parport_pc snd_pcm snd_page_alloc snd_timer snd soundcore ac97_bus thermal_sys amd64_agp k8temp gameport parport hwmon i2c_viapro i2c_algo_bit shpchp skge agpgart i2c_core button evdev loop
> [  881.391001] 
> [  881.391001] Pid: 0, comm: swapper/1 Not tainted 3.2.27 #2 To Be Filled By O.E.M. To Be Filled By O.E.M./A8V Deluxe
> [  881.391001] RIP: 0010:[<ffff88007fd03ef8>]  [<ffff88007fd03ef8>] 0xffff88007fd03ef7
> [  881.391001] RSP: 0018:ffff88007fd03ee0  EFLAGS: 00010006
> [  881.391001] RAX: 0000000000d0d2b8 RBX: ffffffff820c2fc0 RCX: 000000cd36e108a0
> [  881.391001] RDX: 000000000000004b RSI: ffff88007fd0d2b8 RDI: ffffffff820c2fc0
> [  881.391001] RBP: ffffffff8107e9c3 R08: 0000000000000000 R09: 0000000000000001
> [  881.391001] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000e4fd4
> [  881.391001] R13: ffff88007fd0d278 R14: 00000000137b7de3 R15: 00000000503e13fc
> [  881.391001] FS:  00007f7355284740(0000) GS:ffff88007fd00000(0000) knlGS:00000000f6fa2700
> [  881.391001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  881.391001] CR2: ffff88007fd03ef8 CR3: 0000000002005000 CR4: 00000000000006e0
> [  881.391001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  881.391001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  881.391001] Process swapper/1 (pid: 0, threadinfo ffff88007bd18000, task ffff88007d0ec4c0)
> [  881.391001] Stack:
> [  881.391001]  ffff88007fd0d2b8 ffff88007fd0d300 ffff88007fd0cc00 ffff88007fd0d1c0
> [  881.391001]  0000000000000000 0000000000000000 0000000000000000 ffff88007fd03f88
> [  881.391001]  ffffffff81078d43 ffff88007fd03f68 ffff88007fd0d2b8 ffff88007fd0d278
> [  881.391001] Call Trace:
> [  881.391001]  <IRQ> 
> [  881.391001]  [<ffffffff81078d43>] ? hrtimer_interrupt+0x73/0x220
> [  881.391001]  [<ffffffff81b31679>] ? smp_apic_timer_interrupt+0x69/0x99
> [  881.391001]  [<ffffffff81b2f9cb>] ? apic_timer_interrupt+0x6b/0x70
> [  881.391001]  <EOI> 
> [  881.391001]  [<ffffffff8107aa58>] ? sched_clock_cpu+0xa8/0x120
> [  881.391001]  [<ffffffff8100a89a>] ? default_idle+0x5a/0x180
> [  881.391001]  [<ffffffff810009b6>] ? cpu_idle+0xf6/0x110
> [  881.391001]  [<ffffffff81b146ea>] ? start_secondary+0x1cf/0x1d6
> [  881.391001] Code: 00 00 00 e0 3e d0 7f 00 88 ff ff 18 00 00 00 00 00 00 00 b8 d2 d0 7f 00 88 ff ff 00 d3 d0 7f 00 88 ff ff 00 cc d0 7f 00 88 ff ff <c0> d1 d0 7f 00 88 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 
> [  881.391001] RIP  [<ffff88007fd03ef8>] 0xffff88007fd03ef7
> [  881.391001]  RSP <ffff88007fd03ee0>
> [  881.391001] CR2: ffff88007fd03ef8
> [  881.391001] ---[ end trace 8da31a3db7829ee7 ]---
> [  881.391001] Kernel panic - not syncing: Fatal exception in interrupt
> [  881.391001] Pid: 0, comm: swapper/1 Tainted: G      D      3.2.27 #2
> [  881.391001] Call Trace:
> [  881.391001]  <IRQ>  [<ffffffff81b1aeea>] panic+0x91/0x189
> [  881.391001]  [<ffffffff81005491>] oops_end+0x91/0xa0
> [  881.391001]  [<ffffffff81b1a85f>] no_context+0x1fa/0x225
> [  881.391001]  [<ffffffff81a5ca88>] ? ip_local_deliver+0x88/0x90
> [  881.391001]  [<ffffffff81b1aa3b>] __bad_area_nosemaphore+0x1b1/0x1d0
> [  881.391001]  [<ffffffff81a5cce0>] ? ip_rcv+0x250/0x330
> [  881.391001]  [<ffffffff81b1aa6d>] bad_area_nosemaphore+0x13/0x15
> [  881.391001]  [<ffffffff81028794>] do_page_fault+0x2b4/0x480
> [  881.391001]  [<ffffffff8107a8b5>] ? sched_clock_local+0x25/0xa0
> [  881.391001]  [<ffffffff810b727b>] ? rcu_start_gp+0x16b/0x280
> [  881.391001]  [<ffffffff8107e9c3>] ? ktime_get_update_offsets+0x53/0xe0
> [  881.391001]  [<ffffffff81b2ea2f>] page_fault+0x1f/0x30
> [  881.391001]  [<ffffffff8107e9c3>] ? ktime_get_update_offsets+0x53/0xe0
> [  881.391001]  [<ffffffff81078d43>] ? hrtimer_interrupt+0x73/0x220
> [  881.391001]  [<ffffffff81b31679>] ? smp_apic_timer_interrupt+0x69/0x99
> [  881.391001]  [<ffffffff81b2f9cb>] ? apic_timer_interrupt+0x6b/0x70
> [  881.391001]  <EOI>  [<ffffffff8107aa58>] ? sched_clock_cpu+0xa8/0x120
> [  881.391001]  [<ffffffff8100a89a>] ? default_idle+0x5a/0x180
> [  881.391001]  [<ffffffff810009b6>] ? cpu_idle+0xf6/0x110
> [  881.391001]  [<ffffffff81b146ea>] ? start_secondary+0x1cf/0x1d6
> [  881.391001] panic occurred, switching back to text console
> [  881.391001] Rebooting in 10 seconds..
> 
> 
> 
> 
> **************************************************************************************
> 3
> 
> 
> 3.2.27 nosmp
> 
> [   81.006347] BUG: unable to handle kernel NULL pointer dereference at 000000000000003a
> [   81.007329] IP: [<ffffffff810b1080>] alloc_desc+0xc0/0xc0
> [   81.007329] PGD 781f8067 PUD 78082067 PMD 0 
> [   81.007329] Oops: 0002 [#1] SMP 
> [   81.007329] CPU 0 
> [   81.007329] Modules linked in: netconsole snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss ipt_REJECT xt_tcpudp iptable_raw iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_filter ip_tables x_tables lp fuse nouveau mxm_wmi wmi processor snd_via82xx video ttm drm_kms_helper drm i2c_viapro thermal_sys i2c_algo_bit i2c_core snd_ac97_codec snd_mpu401_uart snd_rawmidi snd_seq_device snd_pcm snd_page_alloc snd_timer skge ppdev parport_pc snd parport shpchp k8temp hwmon amd64_agp soundcore ac97_bus agpgart button evdev gameport loop
> [   81.007329] 
> [   81.007329] Pid: 0, comm: swapper/0 Not tainted 3.2.27 #2 To Be Filled By O.E.M. To Be Filled By O.E.M./A8V Deluxe
> [   81.007329] RIP: 0010:[<ffffffff810b1080>]  [<ffffffff810b1080>] alloc_desc+0xc0/0xc0
> [   81.007329] RSP: 0018:ffff88007fc03f60  EFLAGS: 00010092
> [   81.007329] RAX: 000000000000003a RBX: 000000000000000a RCX: 000000000074370e
> [   81.007329] RDX: fffffffffffff04b RSI: ffffffff82001e68 RDI: 000000000000000a
> [   81.007329] RBP: ffff88007fc03f78 R08: ffffffff35dc1000 R09: 00128970e6000000
> [   81.007329] R10: 0000000000743710 R11: 000000000080ffad R12: 000000000000003a
> [   81.007329] R13: 000000000000000a R14: 0000000000000000 R15: 0000000000000000
> [   81.007329] FS:  00007ffb7f691740(0000) GS:ffff88007fc00000(0000) knlGS:00000000f6f81700
> [   81.007329] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   81.007329] CR2: 000000000000003a CR3: 0000000078e1d000 CR4: 00000000000006f0
> [   81.007329] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   81.007329] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   81.007329] Process swapper/0 (pid: 0, threadinfo ffffffff82000000, task ffffffff8200d020)
> [   81.007329] Stack:
> [   81.007329]  ffffffff81003d05 ffff88007fc03f78 ffffffff82001e68 ffff88007fc03fa8
> [   81.007329]  ffffffff81b3158a ffffffff82001fd8 0000000000000000 ffff88007ff7d8c0
> [   81.007329]  ffffffffffffffff ffffffff82001f28 ffffffff81b2e82b ffffffff82001e88
> [   81.007329] Call Trace:
> [   81.007329]  <IRQ> 
> [   81.007329]  [<ffffffff81003d05>] ? handle_irq+0x15/0x40
> [   81.007329]  [<ffffffff81b3158a>] do_IRQ+0x5a/0xe0
> [   81.007329]  [<ffffffff81b2e82b>] common_interrupt+0x6b/0x6b
> [   81.007329]  <EOI> 
> [   81.007329]  [<ffffffff8107aa58>] ? sched_clock_cpu+0xa8/0x120
> [   81.007329]  [<ffffffff8100a89a>] ? default_idle+0x5a/0x180
> [   81.007329]  [<ffffffff810009b6>] cpu_idle+0xf6/0x110
> [   81.007329]  [<ffffffff81ae5b89>] rest_init+0x6d/0x74
> [   81.007329]  [<ffffffff82103b70>] start_kernel+0x385/0x390
> [   81.007329]  [<ffffffff82103322>] x86_64_start_reservations+0x132/0x136
> [   81.007329]  [<ffffffff821033fe>] x86_64_start_kernel+0xd8/0xdc
> [   81.007329] Code: 48 8b 5d e0 4c 8b 6d f0 4c 8b 75 f8 c9 c3 0f 1f 44 00 00 bb 10 00 00 00 eb 9a 90 48 89 df 31 db e8 56 27 07 00 eb d2 0f 1f 40 00 <55> 48 89 e5 66 66 66 66 90 89 fe 48 c7 c7 f0 ee 01 82 e8 c9 8f 
> [   81.007329] RIP  [<ffffffff810b1080>] alloc_desc+0xc0/0xc0
> [   81.007329]  RSP <ffff88007fc03f60>
> [   81.007329] CR2: 000000000000003a
> [   81.007329] ---[ end trace 2cefd006012bde68 ]---
> [   81.007329] Kernel panic - not syncing: Fatal exception in interrupt
> [   81.007329] Pid: 0, comm: swapper/0 Tainted: G      D      3.2.27 #2
> [   81.007329] Call Trace:
> [   81.007329]  <IRQ>  [<ffffffff81b1aeea>] panic+0x91/0x189
> [   81.007329]  [<ffffffff81005491>] oops_end+0x91/0xa0
> [   81.007329]  [<ffffffff81b1a85f>] no_context+0x1fa/0x225
> [   81.007329]  [<ffffffff81b1aa3b>] __bad_area_nosemaphore+0x1b1/0x1d0
> [   81.007329]  [<ffffffff8104cf8b>] ? scheduler_tick+0xdb/0x2c0
> [   81.007329]  [<ffffffff81b1aa6d>] bad_area_nosemaphore+0x13/0x15
> [   81.007329]  [<ffffffff81028794>] do_page_fault+0x2b4/0x480
> [   81.007329]  [<ffffffff819f95c4>] ? pit_next_event+0x34/0x50
> [   81.007329]  [<ffffffff8107df04>] ? ktime_get+0x64/0xe0
> [   81.007329]  [<ffffffff819f95c4>] ? pit_next_event+0x34/0x50
> [   81.007329]  [<ffffffff81083a66>] ? clockevents_program_event+0x76/0x120
> [   81.007329]  [<ffffffff81078948>] ? __hrtimer_start_range_ns+0x1b8/0x420
> [   81.007329]  [<ffffffff81b2ea2f>] page_fault+0x1f/0x30
> [   81.007329]  [<ffffffff810b1080>] ? alloc_desc+0xc0/0xc0
> [   81.007329]  [<ffffffff81003d05>] ? handle_irq+0x15/0x40
> [   81.007329]  [<ffffffff81b3158a>] do_IRQ+0x5a/0xe0
> [   81.007329]  [<ffffffff81b2e82b>] common_interrupt+0x6b/0x6b
> [   81.007329]  <EOI>  [<ffffffff8107aa58>] ? sched_clock_cpu+0xa8/0x120
> [   81.007329]  [<ffffffff8100a89a>] ? default_idle+0x5a/0x180
> [   81.007329]  [<ffffffff810009b6>] cpu_idle+0xf6/0x110
> [   81.007329]  [<ffffffff81ae5b89>] rest_init+0x6d/0x74
> [   81.007329]  [<ffffffff82103b70>] start_kernel+0x385/0x390
> [   81.007329]  [<ffffffff82103322>] x86_64_start_reservations+0x132/0x136
> [   81.007329]  [<ffffffff821033fe>] x86_64_start_kernel+0xd8/0xdc
> [   81.007329] panic occurred, switching back to text console
> [   81.007329] Rebooting in 10 seconds..[  145.137832] Adding 4008212k swap on /dev/sda3.  Priority:-1 extents:1 across:4008212k 
> 
> 
> 
> 
> **************************************************************************************
> 4
> 
> 
> 2.5.2
> 
> [ 5826.382007] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
> [ 5826.385025] IP: [<ffffffff81095330>] update_ts_time_stats+0x90/0x90
> [ 5826.385025] PGD 0 
> [ 5826.385025] Oops: 0002 [#1] SMP 
> [ 5826.385025] CPU 1 
> [ 5826.385025] Modules linked in:[ 5826.385025]  netconsole snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss ipt_REJECT xt_tcpudp iptable_raw iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_filter ip_tables x_tables lp fuse snd_via82xx snd_ac97_codec snd_mpu401_uart snd_rawmidi snd_seq_device nouveau snd_pcm mxm_wmi wmi video ttm drm_kms_helper drm snd_page_alloc snd_timer snd powernow_k8 mperf processor amd64_agp freq_table k8temp thermal_sys ppdev i2c_algo_bit soundcore i2c_viapro skge hwmon button evdev agpgart parport_pc parport i2c_core ac97_bus gameport shpchp loop
> 
> [ 5826.385025] Pid: 0, comm: swapper/1 Not tainted 3.5.2 #4 To Be Filled By O.E.M. To Be Filled By O.E.M./A8V Deluxe
> [ 5826.385025] RIP: 0010:[<ffffffff81095330>]  [<ffffffff81095330>] update_ts_time_stats+0x90/0x90
> [ 5826.385025] RSP: 0018:ffff88007fd03f40  EFLAGS: 00010002
> [ 5826.385025] RAX: 0000000000000001 RBX: ffff88007fd0da40 RCX: 0000000000000017
> [ 5826.385025] RDX: 0000000225c17d03 RSI: 0000054c8f6df3f2 RDI: 0000000000000001
> [ 5826.385025] RBP: ffff88007fd03f68 R08: 0000000000000000 R09: 0000000000000000
> [ 5826.385025] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
> [ 5826.385025] R13: 000000000000da40 R14: 0000054c8f6df3f2 R15: 0000000000000000
> [ 5826.385025] FS:  00007fa10e20e740(0000) GS:ffff88007fd00000(0000) knlGS:00000000f6fd0700
> [ 5826.385025] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 5826.385025] CR2: 0000000000000001 CR3: 000000000200b000 CR4: 00000000000007e0
> [ 5826.385025] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 5826.385025] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 5826.385025] Process swapper/1 (pid: 0, threadinfo ffff88007c524000, task ffff88007d07dd60)
> [ 5826.385025] Stack:
> [ 5826.385025]  ffffffff81095873 0000000000000001 0000000000000000 0000000000000000
> [ 5826.385025]  0000000000000000 ffff88007fd03f88 ffffffff8104a35c 0000000000000000
> [ 5826.385025]  000000000000cfc0 ffff88007fd03fa8 ffffffff81b4fe6e ffff88007c525fd8
> [ 5826.385025] Call Trace:
> [ 5826.385025]  <IRQ> 
> [ 5826.385025]  [<ffffffff81095873>] ? tick_check_idle+0xc3/0xe0
> [ 5826.385025]  [<ffffffff8104a35c>] irq_enter+0x7c/0x90
> [ 5826.385025]  [<ffffffff81b4fe6e>] smp_apic_timer_interrupt+0x3e/0x99
> [ 5826.385025]  [<ffffffff81b4eedc>] apic_timer_interrupt+0x6c/0x80
> [ 5826.385025]  <EOI> 
> [ 5826.385025]  [<ffffffff8100ab7d>] ? default_idle+0x5d/0x1b0
> [ 5826.385025]  [<ffffffff8100ab7f>] ? default_idle+0x5f/0x1b0
> [ 5826.385025]  [<ffffffff8100ab7d>] ? default_idle+0x5d/0x1b0
> [ 5826.385025]  [<ffffffff8100b816>] cpu_idle+0x106/0x120
> [ 5826.385025]  [<ffffffff81b2c7db>] start_secondary+0x1dd/0x1e4
> [ 5826.385025] Code: c0 48 8b 75 c8 75 14 4c 01 a6 b8 00 00 00 48 89 96 a0 00 00 00 eb a8 0f 1f 40 00 4c 01 a6 c0 00 00 00 eb ea 0f 1f 80 00 00 00 00 <55> 48 89 e5 53 48 83 ec 08 66 66 66 66 90 48 c7 c3 40 da 00 00 
> [ 5826.385025] RIP  [<ffffffff81095330>] update_ts_time_stats+0x90/0x90
> [ 5826.385025]  RSP <ffff88007fd03f40>
> [ 5826.385025] CR2: 0000000000000001
> [ 5826.949382] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on vga encoder (output 0)
> [ 5826.971364] ---[ end trace 4684667b9eecc18f ]---
> [ 5826.971364] Kernel panic - not syncing: Fatal exception in interrupt
> [ 5826.971364] panic occurred, switching back to text console
> [ 5826.971364] Rebooting in 10 seconds..
> 
> 
> 
> dmesg:
> 
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.5.2 (root@b) (gcc version 4.7.1 (GCC) ) #4 SMP Wed Aug 29 15:47:00 MSK 2012
> [    0.000000] Command line: auto BOOT_IMAGE=debug ro root=802 vt.default_utf8=0
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e4000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007ffaffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000007ffb0000-0x000000007ffbffff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x000000007ffc0000-0x000000007ffeffff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x000000007fff0000-0x000000007fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ff780000-0x00000000ffffffff] reserved
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI 2.3 present.
> [    0.000000] DMI: To Be Filled By O.E.M. To Be Filled By O.E.M./A8V Deluxe, BIOS 1013.005 05/19/2005
> [    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] AGP bridge at 00:00:00
> [    0.000000] Aperture from AGP @ ec000000 old size 32 MB
> [    0.000000] Aperture from AGP @ ec000000 size 64 MB (APSIZE f30)
> [    0.000000] e820: last_pfn = 0x7ffb0 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-EFFFF uncachable
> [    0.000000]   F0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0000000000 mask FF80000000 write-back
> [    0.000000]   1 base 00EC000000 mask FFFC000000 write-combining
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000ff780]
> [    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
> [    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x7ffaffff]
> [    0.000000]  [mem 0x00000000-0x7fdfffff] page 2M
> [    0.000000]  [mem 0x7fe00000-0x7ffaffff] page 4k
> [    0.000000] kernel direct mapping tables up to 0x7ffaffff @ [mem 0x1fbfd000-0x1fffffff]
> [    0.000000] ACPI: RSDP 00000000000fa7c0 00014 (v00 ACPIAM)
> [    0.000000] ACPI: RSDT 000000007ffb0000 00030 (v01 A M I  OEMRSDT  05000519 MSFT 00000097)
> [    0.000000] ACPI: FACP 000000007ffb0200 00081 (v01 A M I  OEMFACP  05000519 MSFT 00000097)
> [    0.000000] ACPI: DSDT 000000007ffb03f0 03A3E (v01  A0036 A0036001 00000001 MSFT 0100000D)
> [    0.000000] ACPI: FACS 000000007ffc0000 00040
> [    0.000000] ACPI: APIC 000000007ffb0390 00052 (v01 A M I  OEMAPIC  05000519 MSFT 00000097)
> [    0.000000] ACPI: OEMB 000000007ffc0040 0003F (v01 A M I  OEMBIOS  05000519 MSFT 00000097)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000]  [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff88007d600000-ffff88007f5fffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00010000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x7ffaffff]
> [    0.000000] On node 0 totalpages: 524095
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 8 pages reserved
> [    0.000000]   DMA zone: 3911 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 8127 pages used for memmap
> [    0.000000]   DMA32 zone: 511985 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
> [    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
> [    0.000000] e820: [mem 0x80000000-0xff77ffff] available for PCI devices
> [    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88007fc00000 s79104 r8192 d23296 u1048576
> [    0.000000] pcpu-alloc: s79104 r8192 d23296 u1048576 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 515896
> [    0.000000] Kernel command line: auto BOOT_IMAGE=debug ro root=802 vt.default_utf8=0
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.000000] __ex_table already sorted, skipping sort
> [    0.000000] Checking aperture...
> [    0.000000] AGP bridge at 00:00:00
> [    0.000000] Aperture from AGP @ ec000000 old size 32 MB
> [    0.000000] Aperture from AGP @ ec000000 size 64 MB (APSIZE f30)
> [    0.000000] Node 0: aperture @ ec000000 size 64 MB
> [    0.000000] Memory: 2030720k/2096832k available (11592k kernel code, 452k absent, 65660k reserved, 5906k data, 868k init)
> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000]     CONFIG_RCU_FANOUT set to non-default value of 32
> [    0.000000] NR_IRQS:4352 nr_irqs:512 16
> [    0.000000] Console: colour dummy device 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 5855 kB
> [    0.000000]  per task-struct memory footprint: 1920 bytes
> [    0.000000] allocated 8388608 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> [    0.000000] ODEBUG: 0 of 0 active objects replaced
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 2202.837 MHz processor.
> [    0.000000] Marking TSC unstable due to TSCs unsynchronized
> [    0.001011] Calibrating delay loop (skipped), value calculated using timer frequency.. 4405.67 BogoMIPS (lpj=2202837)
> [    0.001026] pid_max: default: 32768 minimum: 301
> [    0.001112] Security Framework initialized
> [    0.001147] Mount-cache hash table entries: 256
> [    0.002455] Initializing cgroup subsys cpuacct
> [    0.002464] Initializing cgroup subsys memory
> [    0.002510] Initializing cgroup subsys devices
> [    0.002518] Initializing cgroup subsys freezer
> [    0.002525] Initializing cgroup subsys net_cls
> [    0.002532] Initializing cgroup subsys blkio
> [    0.002539] Initializing cgroup subsys perf_event
> [    0.002608] tseg: 0000000000
> [    0.002674] CPU: Physical Processor ID: 0
> [    0.002679] CPU: Processor Core ID: 0
> [    0.002683] mce: CPU supports 5 MCE banks
> [    0.002744] ACPI: Core revision 20120320
> [    0.006660] ftrace: allocating 35220 entries in 138 pages
> [    0.021998] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
> [    0.031952] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ stepping 01
> [    0.031997] Performance Events: AMD PMU driver.
> [    0.031997] ... version:                0
> [    0.031997] ... bit width:              48
> [    0.031997] ... generic registers:      4
> [    0.031997] ... value mask:             0000ffffffffffff
> [    0.031997] ... max period:             00007fffffffffff
> [    0.031997] ... fixed-purpose events:   0
> [    0.031997] ... event mask:             000000000000000f
> [    0.031997] MCE: In-kernel MCE decoding enabled.
> [    0.031997] lockdep: fixing up alternatives.
> [    0.031997] Booting Node   0, Processors  #1 Ok.
> [    0.102048] Brought up 2 CPUs
> [    0.102054] Total of 2 processors activated (8810.66 BogoMIPS).
> [    0.103313] devtmpfs: initialized
> [    0.106101] PM: Registering ACPI NVS region [mem 0x7ffc0000-0x7ffeffff] (196608 bytes)
> [    0.106225] xor: automatically using best checksumming function:
> [    0.115993]    generic_sse:  7048.000 MB/sec
> [    0.116002] atomic64 test passed for x86-64 platform with CX8 and with SSE
> [    0.117080] dummy: 
> [    0.117258] NET: Registered protocol family 16
> [    0.118081] node 0 link 0: io port [1000, ffffff]
> [    0.118082] TOM: 0000000080000000 aka 2048M
> [    0.118090] node 0 link 0: mmio [a0000, bffff]
> [    0.118094] node 0 link 0: mmio [80000000, ffffffff]
> [    0.118098] bus: [00, ff] on node 0 link 0
> [    0.118101] bus: 00 [io  0x0000-0xffff]
> [    0.118103] bus: 00 [mem 0x000a0000-0x000bffff]
> [    0.118105] bus: 00 [mem 0x80000000-0xfcffffffff]
> [    0.118206] ACPI: bus type pci registered
> [    0.118234] PCI: Using configuration type 1 for base access
> [    0.163084] bio: create slab <bio-0> at 0
> [    0.179938] raid6: sse2x1     738 MB/s
> [    0.196933] raid6: sse2x2     875 MB/s
> [    0.213954] raid6: sse2x4    1398 MB/s
> [    0.213959] raid6: using algorithm sse2x4 (1398 MB/s)
> [    0.213965] raid6: using intx1 recovery algorithm
> [    0.214084] ACPI: Added _OSI(Module Device)
> [    0.214084] ACPI: Added _OSI(Processor Device)
> [    0.214084] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.214084] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.217956] ACPI: EC: Look up EC in DSDT
> [    0.221983] ACPI: Executed 1 blocks of module-level executable AML code
> [    0.226439] ACPI: Interpreter enabled
> [    0.226448] ACPI: (supports S0 S1 S3 S4 S5)
> [    0.226522] ACPI: Using IOAPIC for interrupt routing
> [    0.243376] ACPI: No dock devices found.
> [    0.243392] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
> [    0.243553] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.244179] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
> [    0.244182] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
> [    0.244186] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
> [    0.244189] pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xffffffff] (ignored)
> [    0.244192] PCI: root bus 00: hardware-probed resources
> [    0.244383] PCI host bridge to bus 0000:00
> [    0.244383] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
> [    0.244383] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.244383] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfcffffffff]
> [    0.244383] pci 0000:00:00.0: [1106:0282] type 00 class 0x060000
> [    0.244383] pci 0000:00:00.0: reg 10: [mem 0xec000000-0xefffffff pref]
> [    0.244383] pci 0000:00:00.1: [1106:1282] type 00 class 0x060000
> [    0.244386] pci 0000:00:00.2: [1106:2282] type 00 class 0x060000
> [    0.244454] pci 0000:00:00.3: [1106:3282] type 00 class 0x060000
> [    0.244521] pci 0000:00:00.4: [1106:4282] type 00 class 0x060000
> [    0.245085] pci 0000:00:00.7: [1106:7282] type 00 class 0x060000
> [    0.245168] pci 0000:00:01.0: [1106:b188] type 01 class 0x060400
> [    0.245247] pci 0000:00:01.0: supports D1
> [    0.245281] pci 0000:00:08.0: [105a:3373] type 00 class 0x010400
> [    0.245305] pci 0000:00:08.0: reg 10: [io  0xa800-0xa83f]
> [    0.245319] pci 0000:00:08.0: reg 14: [io  0xa400-0xa40f]
> [    0.245332] pci 0000:00:08.0: reg 18: [io  0xa000-0xa07f]
> [    0.245347] pci 0000:00:08.0: reg 1c: [mem 0xfaa00000-0xfaa00fff]
> [    0.245360] pci 0000:00:08.0: reg 20: [mem 0xfa900000-0xfa91ffff]
> [    0.245422] pci 0000:00:08.0: supports D1
> [    0.245452] pci 0000:00:0a.0: [11ab:4320] type 00 class 0x020000
> [    0.245478] pci 0000:00:0a.0: reg 10: [mem 0xfac00000-0xfac03fff]
> [    0.245492] pci 0000:00:0a.0: reg 14: [io  0xb000-0xb0ff]
> [    0.245549] pci 0000:00:0a.0: reg 30: [mem 0xfab00000-0xfab1ffff pref]
> [    0.245601] pci 0000:00:0a.0: supports D1 D2
> [    0.245604] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.245672] pci 0000:00:0f.0: [1106:3149] type 00 class 0x010400
> [    0.245696] pci 0000:00:0f.0: reg 10: [io  0xd000-0xd007]
> [    0.245710] pci 0000:00:0f.0: reg 14: [io  0xc800-0xc803]
> [    0.245723] pci 0000:00:0f.0: reg 18: [io  0xc400-0xc407]
> [    0.245738] pci 0000:00:0f.0: reg 1c: [io  0xc000-0xc003]
> [    0.245751] pci 0000:00:0f.0: reg 20: [io  0xb800-0xb80f]
> [    0.245765] pci 0000:00:0f.0: reg 24: [io  0xb400-0xb4ff]
> [    0.245838] pci 0000:00:0f.1: [1106:0571] type 00 class 0x01018a
> [    0.245905] pci 0000:00:0f.1: reg 20: [io  0xfc00-0xfc0f]
> [    0.246008] pci 0000:00:10.0: [1106:3038] type 00 class 0x0c0300
> [    0.246074] pci 0000:00:10.0: reg 20: [io  0xd400-0xd41f]
> [    0.246136] pci 0000:00:10.0: supports D1 D2
> [    0.246139] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.246166] pci 0000:00:10.1: [1106:3038] type 00 class 0x0c0300
> [    0.246232] pci 0000:00:10.1: reg 20: [io  0xd800-0xd81f]
> [    0.246294] pci 0000:00:10.1: supports D1 D2
> [    0.246297] pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.246324] pci 0000:00:10.2: [1106:3038] type 00 class 0x0c0300
> [    0.246390] pci 0000:00:10.2: reg 20: [io  0xe000-0xe01f]
> [    0.246451] pci 0000:00:10.2: supports D1 D2
> [    0.246454] pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.246485] pci 0000:00:10.3: [1106:3038] type 00 class 0x0c0300
> [    0.246551] pci 0000:00:10.3: reg 20: [io  0xe400-0xe41f]
> [    0.246612] pci 0000:00:10.3: supports D1 D2
> [    0.246615] pci 0000:00:10.3: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.246643] pci 0000:00:10.4: [1106:3104] type 00 class 0x0c0320
> [    0.246667] pci 0000:00:10.4: reg 10: [mem 0xfae00000-0xfae000ff]
> [    0.246770] pci 0000:00:10.4: supports D1 D2
> [    0.246773] pci 0000:00:10.4: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.246806] pci 0000:00:11.0: [1106:3227] type 00 class 0x060100
> [    0.246897] HPET not enabled in BIOS. You might try hpet=force boot option
> [    0.246910] pci 0000:00:11.0: Enabled onboard AC97/MC97 devices
> [    0.246985] pci 0000:00:11.5: [1106:3059] type 00 class 0x040100
> [    0.247009] pci 0000:00:11.5: reg 10: [io  0xe800-0xe8ff]
> [    0.247114] pci 0000:00:11.5: supports D1 D2
> [    0.247138] pci 0000:00:11.6: [1106:3068] type 00 class 0x078000
> [    0.247162] pci 0000:00:11.6: reg 10: [io  0x0000-0x00ff]
> [    0.247297] pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
> [    0.247360] pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
> [    0.247409] pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
> [    0.247457] pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
> [    0.247562] pci 0000:01:00.0: [10de:0181] type 00 class 0x030000
> [    0.247583] pci 0000:01:00.0: reg 10: [mem 0xfb000000-0xfbffffff]
> [    0.247594] pci 0000:01:00.0: reg 14: [mem 0xf0000000-0xf7ffffff pref]
> [    0.247640] pci 0000:01:00.0: reg 30: [mem 0xfaf00000-0xfaf1ffff pref]
> [    0.247731] pci 0000:00:01.0: PCI bridge to [bus 01-01]
> [    0.247743] pci 0000:00:01.0:   bridge window [mem 0xfaf00000-0xfbffffff]
> [    0.247749] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf9ffffff pref]
> [    0.247760] pci_bus 0000:00: on NUMA node 0
> [    0.247766] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.248427]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x1e)
> [    0.267173] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 *11 14 15)
> [    0.267312] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *10 11 14 15)
> [    0.267430] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 7 10 11 14 15)
> [    0.268056] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
> [    0.268176] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
> [    0.268295] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
> [    0.268418] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
> [    0.268539] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
> [    0.269104] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.269115] vgaarb: loaded
> [    0.269119] vgaarb: bridge control possible 0000:01:00.0
> [    0.269217] SCSI subsystem initialized
> [    0.270016] libata version 3.00 loaded.
> [    0.270024] ACPI: bus type usb registered
> [    0.270072] usbcore: registered new interface driver usbfs
> [    0.270072] usbcore: registered new interface driver hub
> [    0.270072] usbcore: registered new device driver usb
> [    0.271028] PCI: Using ACPI for IRQ routing
> [    0.271028] PCI: pci_cache_line_size set to 64 bytes
> [    0.271036] pci 0000:00:00.0: address space collision: [mem 0xec000000-0xefffffff pref] conflicts with GART [mem 0xec000000-0xefffffff]
> [    0.271221] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    0.271224] e820: reserve RAM buffer [mem 0x7ffb0000-0x7fffffff]
> [    0.313100] pnp: PnP ACPI init
> [    0.313100] ACPI: bus type pnp registered
> [    0.313261] pnp 00:00: [bus 00-ff]
> [    0.313265] pnp 00:00: [io  0x0cf8-0x0cff]
> [    0.313269] pnp 00:00: [io  0x0000-0x0cf7 window]
> [    0.313271] pnp 00:00: [io  0x0d00-0xffff window]
> [    0.313275] pnp 00:00: [mem 0x000a0000-0x000bffff window]
> [    0.313277] pnp 00:00: [mem 0x00000000 window]
> [    0.313280] pnp 00:00: [mem 0x80000000-0xffffffff window]
> [    0.313420] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
> [    0.313420] pnp 00:01: [dma 4]
> [    0.313420] pnp 00:01: [io  0x0000-0x000f]
> [    0.313420] pnp 00:01: [io  0x0081-0x0083]
> [    0.313420] pnp 00:01: [io  0x0087]
> [    0.313420] pnp 00:01: [io  0x0089-0x008b]
> [    0.313420] pnp 00:01: [io  0x008f]
> [    0.313420] pnp 00:01: [io  0x00c0-0x00df]
> [    0.313420] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
> [    0.313420] pnp 00:02: [io  0x0070-0x0071]
> [    0.313420] pnp 00:02: [irq 8]
> [    0.314028] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.314062] pnp 00:03: [io  0x0060]
> [    0.314065] pnp 00:03: [io  0x0064]
> [    0.314074] pnp 00:03: [irq 1]
> [    0.314163] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
> [    0.314163] pnp 00:04: [io  0x0061]
> [    0.314163] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
> [    0.314163] pnp 00:05: [io  0x00f0-0x00ff]
> [    0.314163] pnp 00:05: [irq 13]
> [    0.314163] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    0.315164] pnp 00:06: [irq 6]
> [    0.315167] pnp 00:06: [dma 2]
> [    0.315170] pnp 00:06: [io  0x03f0-0x03f5]
> [    0.315173] pnp 00:06: [io  0x03f7]
> [    0.315287] pnp 00:06: Plug and Play ACPI device, IDs PNP0700 (active)
> [    0.315455] pnp 00:07: [io  0x0378-0x037f]
> [    0.315466] pnp 00:07: [irq 7]
> [    0.316068] pnp 00:07: Plug and Play ACPI device, IDs PNP0400 (active)
> [    0.316108] pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
> [    0.316111] pnp 00:08: [io  0x0680-0x06ff]
> [    0.316114] pnp 00:08: [io  0x0290-0x0297]
> [    0.316241] system 00:08: [io  0x0680-0x06ff] has been reserved
> [    0.316241] system 00:08: [io  0x0290-0x0297] has been reserved
> [    0.316241] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.316241] pnp 00:09: [io  0x0010-0x001f]
> [    0.316241] pnp 00:09: [io  0x0022-0x003f]
> [    0.316241] pnp 00:09: [io  0x0044-0x005f]
> [    0.316241] pnp 00:09: [io  0x0062-0x0063]
> [    0.316241] pnp 00:09: [io  0x0065-0x006f]
> [    0.316241] pnp 00:09: [io  0x0072-0x007f]
> [    0.316241] pnp 00:09: [io  0x0080]
> [    0.316241] pnp 00:09: [io  0x0084-0x0086]
> [    0.316241] pnp 00:09: [io  0x0088]
> [    0.316241] pnp 00:09: [io  0x008c-0x008e]
> [    0.316241] pnp 00:09: [io  0x0090-0x009f]
> [    0.316241] pnp 00:09: [io  0x00a2-0x00bf]
> [    0.316241] pnp 00:09: [io  0x00e0-0x00ef]
> [    0.316241] pnp 00:09: [io  0x03e1-0x03e7]
> [    0.316241] pnp 00:09: [io  0x04d0-0x04d1]
> [    0.316241] pnp 00:09: [io  0x0800-0x087f]
> [    0.316241] pnp 00:09: [io  0x0400-0x041f]
> [    0.316241] pnp 00:09: [io  0x0000-0xffffffffffffffff disabled]
> [    0.316282] pnp 00:09: disabling [io  0x0010-0x001f] because it overlaps 0000:00:11.6 BAR 0 [io  0x0000-0x00ff]
> [    0.316293] pnp 00:09: disabling [io  0x0022-0x003f] because it overlaps 0000:00:11.6 BAR 0 [io  0x0000-0x00ff]
> [    0.316302] pnp 00:09: disabling [io  0x0044-0x005f] because it overlaps 0000:00:11.6 BAR 0 [io  0x0000-0x00ff]
> [    0.316311] pnp 00:09: disabling [io  0x0062-0x0063] because it overlaps 0000:00:11.6 BAR 0 [io  0x0000-0x00ff]
> [    0.316320] pnp 00:09: disabling [io  0x0065-0x006f] because it overlaps 0000:00:11.6 BAR 0 [io  0x0000-0x00ff]
> [    0.316329] pnp 00:09: disabling [io  0x0072-0x007f] because it overlaps 0000:00:11.6 BAR 0 [io  0x0000-0x00ff]
> [    0.316338] pnp 00:09: disabling [io  0x0080] because it overlaps 0000:00:11.6 BAR 0 [io  0x0000-0x00ff]
> [    0.316347] pnp 00:09: disabling [io  0x0084-0x0086] because it overlaps 0000:00:11.6 BAR 0 [io  0x0000-0x00ff]
> [    0.316356] pnp 00:09: disabling [io  0x0088] because it overlaps 0000:00:11.6 BAR 0 [io  0x0000-0x00ff]
> [    0.316365] pnp 00:09: disabling [io  0x008c-0x008e] because it overlaps 0000:00:11.6 BAR 0 [io  0x0000-0x00ff]
> [    0.316374] pnp 00:09: disabling [io  0x0090-0x009f] because it overlaps 0000:00:11.6 BAR 0 [io  0x0000-0x00ff]
> [    0.316383] pnp 00:09: disabling [io  0x00a2-0x00bf] because it overlaps 0000:00:11.6 BAR 0 [io  0x0000-0x00ff]
> [    0.316392] pnp 00:09: disabling [io  0x00e0-0x00ef] because it overlaps 0000:00:11.6 BAR 0 [io  0x0000-0x00ff]
> [    0.317005] system 00:09: [io  0x03e1-0x03e7] has been reserved
> [    0.317014] system 00:09: [io  0x04d0-0x04d1] has been reserved
> [    0.317021] system 00:09: [io  0x0800-0x087f] has been reserved
> [    0.317028] system 00:09: [io  0x0400-0x041f] has been reserved
> [    0.317039] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.317151] pnp 00:0a: [mem 0xfec00000-0xfec00fff]
> [    0.317154] pnp 00:0a: [mem 0xfee00000-0xfee00fff]
> [    0.317157] pnp 00:0a: [mem 0xfff80000-0xffffffff]
> [    0.317280] system 00:0a: [mem 0xfec00000-0xfec00fff] could not be reserved
> [    0.317280] system 00:0a: [mem 0xfee00000-0xfee00fff] has been reserved
> [    0.317280] system 00:0a: [mem 0xfff80000-0xffffffff] has been reserved
> [    0.317280] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.317459] pnp 00:0b: [irq 3]
> [    0.317462] pnp 00:0b: [dma 0 disabled]
> [    0.317465] pnp 00:0b: [io  0x02f8-0x02ff]
> [    0.318009] pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
> [    0.318432] pnp 00:0c: [io  0x03f8-0x03ff]
> [    0.318442] pnp 00:0c: [irq 4]
> [    0.318580] pnp 00:0c: Plug and Play ACPI device, IDs PNP0501 (active)
> [    0.319310] pnp 00:0d: [mem 0x00000000-0x0009ffff]
> [    0.319313] pnp 00:0d: [mem 0x000c0000-0x000dffff]
> [    0.319317] pnp 00:0d: [mem 0x000e0000-0x000fffff]
> [    0.319320] pnp 00:0d: [mem 0x00100000-0x7ffeffff]
> [    0.319322] pnp 00:0d: [mem 0x00000000-0xffffffffffffffff disabled]
> [    0.319330] pnp 00:0d: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 0 [mem 0x00000000-0x03ffffff pref]
> [    0.319342] pnp 00:0d: disabling [mem 0x000c0000-0x000dffff] because it overlaps 0000:00:00.0 BAR 0 [mem 0x00000000-0x03ffffff pref]
> [    0.319352] pnp 00:0d: disabling [mem 0x000e0000-0x000fffff] because it overlaps 0000:00:00.0 BAR 0 [mem 0x00000000-0x03ffffff pref]
> [    0.319362] pnp 00:0d: disabling [mem 0x00100000-0x7ffeffff] because it overlaps 0000:00:00.0 BAR 0 [mem 0x00000000-0x03ffffff pref]
> [    0.319520] system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.319520] pnp: PnP ACPI: found 14 devices
> [    0.319520] ACPI: ACPI bus type pnp unregistered
> [    0.335173] Switching to clocksource acpi_pm
> [    0.335305] pci 0000:00:11.6: BAR 0: assigned [io  0x1000-0x10ff]
> [    0.335318] pci 0000:00:01.0: PCI bridge to [bus 01-01]
> [    0.335329] pci 0000:00:01.0:   bridge window [mem 0xfaf00000-0xfbffffff]
> [    0.335339] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf9ffffff pref]
> [    0.335364] pci 0000:00:01.0: setting latency timer to 64
> [    0.335369] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
> [    0.335372] pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff]
> [    0.335375] pci_bus 0000:00: resource 6 [mem 0x80000000-0xfcffffffff]
> [    0.335378] pci_bus 0000:01: resource 1 [mem 0xfaf00000-0xfbffffff]
> [    0.335381] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf9ffffff pref]
> [    0.335457] NET: Registered protocol family 2
> [    0.335600] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.336370] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
> [    0.338748] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
> [    0.348019] TCP: Hash tables configured (established 262144 bind 65536)
> [    0.348083] TCP: reno registered
> [    0.348104] UDP hash table entries: 1024 (order: 5, 163840 bytes)
> [    0.348413] UDP-Lite hash table entries: 1024 (order: 5, 163840 bytes)
> [    0.348875] NET: Registered protocol family 1
> [    0.349246] RPC: Registered named UNIX socket transport module.
> [    0.349259] RPC: Registered udp transport module.
> [    0.349264] RPC: Registered tcp transport module.
> [    0.349270] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    0.349368] pci 0000:00:01.0: disabling DAC on VIA PCI bridge
> [    0.349385] PCI: CLS mismatch (580 != 64), using 64 bytes
> [    0.349605] pci 0000:01:00.0: Boot video device
> [    0.351738] audit: initializing netlink socket (disabled)
> [    0.351797] type=2000 audit(1346246761.350:1): initialized
> [    0.364668] VFS: Disk quotas dquot_6.5.2
> [    0.364861] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.367808] NFS: Registering the id_resolver key type
> [    0.367939] Key type id_resolver registered
> [    0.367945] Key type id_legacy registered
> [    0.368666] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [    0.369454] NTFS driver 2.1.30 [Flags: R/W].
> [    0.369788] ROMFS MTD (C) 2007 Red Hat, Inc.
> [    0.370393] JFS: nTxBlock = 8192, nTxLock = 65536
> [    0.376707] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
> [    0.378035] OCFS2 1.5.0
> [    0.378326] ocfs2: Registered cluster interface o2cb
> [    0.378336] OCFS2 DLMFS 1.5.0
> [    0.378564] OCFS2 User DLM kernel interface loaded
> [    0.378573] OCFS2 Node Manager 1.5.0
> [    0.379247] OCFS2 DLM 1.5.0
> [    0.380884] Btrfs loaded
> [    0.380907] msgmni has been set to 3966
> [    0.383850] async_tx: api initialized (async)
> [    0.384215] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> [    0.384376] io scheduler noop registered
> [    0.384388] io scheduler deadline registered
> [    0.384600] io scheduler cfq registered (default)
> [    0.385456] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    0.385765] vesafb: mode is 1024x768x16, linelength=2048, pages=1
> [    0.385771] vesafb: scrolling: redraw
> [    0.385777] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
> [    0.386104] vesafb: framebuffer at 0xf0000000, mapped to 0xffffc90000700000, using 3072k, total 65536k
> [    0.422852] Console: switching to colour frame buffer device 128x48
> [    0.456134] fb0: VESA VGA frame buffer device
> [    0.456672] GHES: HEST is not enabled!
> [    0.466562] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    0.732291] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    0.997289] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> [    1.020196] 00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> [    1.041571] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    1.043410] Floppy drive(s): fd0 is 1.44M
> [    1.057982] FDC 0 is a post-1991 82077
> [    1.066402] brd: module loaded
> [    1.066619] Compaq SMART2 Driver (v 2.6.0)
> [    1.067336] HP CISS Driver (v 3.6.26)
> [    1.070622] fnic: Cisco FCoE HBA Driver, ver 1.5.0.2
> [    1.072101] Adaptec aacraid driver 1.2-0[28900]-ms
> [    1.072920] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
> [    1.073957] scsi: <fdomain> Detection failed (no card)
> [    1.074461] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.04.00.03-k.
> [    1.075183] Emulex LightPulse Fibre Channel SCSI driver 8.3.31
> [    1.086630] Copyright(c) 2004-2009 Emulex.  All rights reserved.
> [    1.098503] Brocade BFA FC/FCOE SCSI driver - version: 3.0.23.0
> [    1.110585] DC390: clustering now enabled by default. If you get problems load
> [    1.122137]        with "disable_clustering=1" and report to maintainers
> [    1.134055] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
> [    1.146184] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
> [    1.158397] megasas: 00.00.06.15-rc1 Mon. Mar. 19 17:00:00 PDT 2012
> [    1.170724] mpt2sas version 13.100.00.00 loaded
> [    1.183336] GDT-HA: Storage RAID Controller Driver. Version: 3.05
> [    1.196196] 3ware Storage Controller device driver for Linux v1.26.02.003.
> [    1.209111] 3ware 9000 Storage Controller device driver for Linux v2.26.02.014.
> [    1.222272] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v3.26.02.000.
> [    1.235683] ipr: IBM Power RAID SCSI Device Driver version: 2.5.3 (March 10, 2012)
> [    1.249146] RocketRAID 3xxx/4xxx Controller driver v1.6 (090910)
> [    1.262466] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
> [    1.276286] st: Version 20101219, fixed bufsize 32768, s/g segs 256
> [    1.291908] sata_promise 0000:00:08.0: version 2.12
> [    1.305272] scsi0 : sata_promise
> [    1.319375] scsi1 : sata_promise
> [    1.333087] scsi2 : sata_promise
> [    1.346344] ata1: SATA max UDMA/133 mmio m4096@0xfaa00000 ata 0xfaa00200 irq 18
> [    1.359696] ata2: SATA max UDMA/133 mmio m4096@0xfaa00000 ata 0xfaa00280 irq 18
> [    1.372854] ata3: PATA max UDMA/133 mmio m4096@0xfaa00000 ata 0xfaa00300 irq 18
> [    1.386920] sata_via 0000:00:0f.0: version 2.6
> [    1.387026] sata_via 0000:00:0f.0: routed to hard irq line 10
> [    1.400982] scsi3 : sata_via
> [    1.413857] scsi4 : sata_via
> [    1.426325] ata4: SATA max UDMA/133 cmd 0xd000 ctl 0xc800 bmdma 0xb800 irq 20
> [    1.438985] ata5: SATA max UDMA/133 cmd 0xc400 ctl 0xc000 bmdma 0xb808 irq 20
> [    1.455989] pata_via 0000:00:0f.1: version 0.3.4
> [    1.457804] scsi5 : pata_via
> [    1.470493] scsi6 : pata_via
> [    1.486232] ata6: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
> [    1.498656] ata7: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
> [    1.512403] I2O subsystem v1.325
> [    1.524679] i2o: max drivers = 8
> [    1.537342] I2O Configuration OSM v1.323
> [    1.549732] I2O Bus Adapter OSM v1.317
> [    1.562070] I2O Block Device OSM v1.325
> [    1.574615] I2O SCSI Peripheral OSM v1.316
> [    1.586856] I2O ProcFS OSM v1.316
> [    1.598969] Fusion MPT base driver 3.04.20
> [    1.610891] Copyright (c) 1999-2008 LSI Corporation
> [    1.622769] Fusion MPT SPI Host driver 3.04.20
> [    1.634555] Fusion MPT FC Host driver 3.04.20
> [    1.646080] Fusion MPT SAS Host driver 3.04.20
> [    1.657311] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    1.663083] Fusion MPT misc device (ioctl) driver 3.04.20
> [    1.663249] mptctl: Registered with Fusion MPT base driver
> [    1.663251] mptctl: /dev/mptctl @ (major,minor=10,220)
> [    1.663252] Fusion MPT LAN driver 3.04.20
> [    1.663593] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    1.663672] ehci_hcd 0000:00:10.4: EHCI Host Controller
> [    1.664256] ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
> [    1.664375] ehci_hcd 0000:00:10.4: irq 21, io mem 0xfae00000
> [    1.670025] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00
> [    1.670170] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    1.670173] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.670175] usb usb1: Product: EHCI Host Controller
> [    1.670177] usb usb1: Manufacturer: Linux 3.5.2 ehci_hcd
> [    1.670178] usb usb1: SerialNumber: 0000:00:10.4
> [    1.671025] hub 1-0:1.0: USB hub found
> [    1.671058] hub 1-0:1.0: 8 ports detected
> [    1.671844] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    1.671965] uhci_hcd: USB Universal Host Controller Interface driver
> [    1.672057] uhci_hcd 0000:00:10.0: UHCI Host Controller
> [    1.672272] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
> [    1.672307] uhci_hcd 0000:00:10.0: irq 21, io base 0x0000d400
> [    1.672443] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.672445] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.672447] usb usb2: Product: UHCI Host Controller
> [    1.672449] usb usb2: Manufacturer: Linux 3.5.2 uhci_hcd
> [    1.672451] usb usb2: SerialNumber: 0000:00:10.0
> [    1.672868] hub 2-0:1.0: USB hub found
> [    1.672881] hub 2-0:1.0: 2 ports detected
> [    1.673132] uhci_hcd 0000:00:10.1: UHCI Host Controller
> [    1.673322] uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
> [    1.673353] uhci_hcd 0000:00:10.1: irq 21, io base 0x0000d800
> [    1.673427] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.673429] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.673431] usb usb3: Product: UHCI Host Controller
> [    1.673433] usb usb3: Manufacturer: Linux 3.5.2 uhci_hcd
> [    1.673434] usb usb3: SerialNumber: 0000:00:10.1
> [    1.673830] hub 3-0:1.0: USB hub found
> [    1.673840] hub 3-0:1.0: 2 ports detected
> [    1.674082] uhci_hcd 0000:00:10.2: UHCI Host Controller
> [    1.674266] uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
> [    1.674297] uhci_hcd 0000:00:10.2: irq 21, io base 0x0000e000
> [    1.674372] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.674374] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.674376] usb usb4: Product: UHCI Host Controller
> [    1.674378] usb usb4: Manufacturer: Linux 3.5.2 uhci_hcd
> [    1.674380] usb usb4: SerialNumber: 0000:00:10.2
> [    1.674771] hub 4-0:1.0: USB hub found
> [    1.674781] hub 4-0:1.0: 2 ports detected
> [    1.674986] uhci_hcd 0000:00:10.3: UHCI Host Controller
> [    1.675203] uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
> [    1.675233] uhci_hcd 0000:00:10.3: irq 21, io base 0x0000e400
> [    1.675312] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.675314] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.675316] usb usb5: Product: UHCI Host Controller
> [    1.675318] usb usb5: Manufacturer: Linux 3.5.2 uhci_hcd
> [    1.675320] usb usb5: SerialNumber: 0000:00:10.3
> [    1.675721] hub 5-0:1.0: USB hub found
> [    1.675731] hub 5-0:1.0: 2 ports detected
> [    1.677086] Initializing USB Mass Storage driver...
> [    1.677214] usbcore: registered new interface driver usb-storage
> [    1.677215] USB Mass Storage support registered.
> [    1.677303] usbcore: registered new interface driver ums-alauda
> [    1.677389] usbcore: registered new interface driver ums-cypress
> [    1.677477] usbcore: registered new interface driver ums-datafab
> [    1.677562] usbcore: registered new interface driver ums-freecom
> [    1.677650] usbcore: registered new interface driver ums-isd200
> [    1.677734] usbcore: registered new interface driver ums-jumpshot
> [    1.677819] usbcore: registered new interface driver ums-karma
> [    1.677907] usbcore: registered new interface driver ums-onetouch
> [    1.677998] usbcore: registered new interface driver ums-sddr09
> [    1.678105] usbcore: registered new interface driver ums-sddr55
> [    1.678190] usbcore: registered new interface driver ums-usbat
> [    1.678395] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
> [    1.678396] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
> [    1.678750] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    1.679583] mousedev: PS/2 mouse device common for all mice
> [    1.679749] rtc_cmos 00:02: RTC can wake from S4
> [    1.680491] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
> [    1.680558] rtc0: alarms up to one year, y3k, 114 bytes nvram
> [    1.680675] md: linear personality registered for level -1
> [    1.680677] md: raid0 personality registered for level 0
> [    1.680678] md: raid1 personality registered for level 1
> [    1.680680] md: raid10 personality registered for level 10
> [    1.680681] md: raid6 personality registered for level 6
> [    1.680682] md: raid5 personality registered for level 5
> [    1.680683] md: raid4 personality registered for level 4
> [    1.680685] md: multipath personality registered for level -4
> [    1.680988] device-mapper: uevent: version 1.0.3
> [    1.681350] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
> [    1.681706] cpuidle: using governor ladder
> [    1.681708] cpuidle: using governor menu
> [    1.681892] input: Speakup as /devices/virtual/input/input0
> [    1.682165] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
> [    1.682240] speakup 3.1.6: initialized
> [    1.682240] synth name on entry is: (null)
> [    1.682420] TCP: cubic registered
> [    1.682420] Initializing XFRM netlink socket
> [    1.682449] NET: Registered protocol family 17
> [    1.682558] Key type dns_resolver registered
> [    1.709879] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [    1.711034] ata1: SATA link down (SStatus 0 SControl 300)
> [    2.016029] ata2: SATA link down (SStatus 0 SControl 300)
> [    2.979596] 
> [    2.980587] =================================
> [    2.980587] [ INFO: inconsistent lock state ]
> [    2.980587] 3.5.2 #4 Not tainted
> [    2.980587] ---------------------------------
> [    2.980587] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
> [    2.980587] swapper/1/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
> [    2.980587]  (&(&host->lock)->rlock){?.+...}, at: [<ffffffff818f4e47>] ata_bmdma_interrupt+0x27/0x1d0
> [    2.980587] {HARDIRQ-ON-W} state was registered at:
> [    2.980587]   [<ffffffff810998fb>] __lock_acquire+0x61b/0x1af0
> [    2.980587]   [<ffffffff8109b31a>] lock_acquire+0x8a/0x110
> [    2.980587]   [<ffffffff81b4d051>] _raw_spin_lock+0x31/0x40
> [    2.980587]   [<ffffffff8190b3c5>] pdc_sata_hardreset+0x85/0x100
> [    2.980587]   [<ffffffff818eabba>] ata_do_reset+0x3a/0x90
> [    2.980587]   [<ffffffff818edd72>] ata_eh_reset+0x372/0xe00
> [    2.980587]   [<ffffffff818eec25>] ata_eh_recover+0x2a5/0x13d0
> [    2.980587]   [<ffffffff818f073d>] ata_do_eh+0x4d/0xb0
> [    2.980587]   [<ffffffff818f33ba>] ata_sff_error_handler+0xca/0x120
> [    2.980587]   [<ffffffff8190a9e4>] pdc_error_handler+0x24/0x30
> [    2.980587]   [<ffffffff818f029c>] ata_scsi_port_error_handler+0x47c/0x800
> [    2.980587]   [<ffffffff818f06be>] ata_scsi_error+0x9e/0xd0
> [    2.980587]   [<ffffffff816732e8>] scsi_error_handler+0xf8/0x500
> [    2.980587]   [<ffffffff810654fe>] kthread+0xae/0xc0
> [    2.980587]   [<ffffffff81b4f5f4>] kernel_thread_helper+0x4/0x10
> [    2.980587] irq event stamp: 44044
> [    2.980587] hardirqs last  enabled at (44041): [<ffffffff8100ab7d>] default_idle+0x5d/0x1b0
> [    2.980587] hardirqs last disabled at (44042): [<ffffffff81b4da67>] common_interrupt+0x67/0x6c
> [    2.980587] softirqs last  enabled at (44044): [<ffffffff810498d3>] _local_bh_enable+0x13/0x20
> [    2.980587] softirqs last disabled at (44043): [<ffffffff8104a355>] irq_enter+0x75/0x90
> [    2.980587] 
> [    2.980587] other info that might help us debug this:
> [    2.980587]  Possible unsafe locking scenario:
> [    2.980587] 
> [    2.980587]        CPU0
> [    2.980587]        ----
> [    2.980587]   lock(&(&host->lock)->rlock);
> [    2.980587]   <Interrupt>
> [    2.980587]     lock(&(&host->lock)->rlock);
> [    2.980587] 
> [    2.980587]  *** DEADLOCK ***
> [    2.980587] 
> [    2.980587] no locks held by swapper/1/0.
> [    2.980587] 
> [    2.980587] stack backtrace:
> [    2.980587] Pid: 0, comm: swapper/1 Not tainted 3.5.2 #4
> [    2.980587] Call Trace:
> [    2.980587]  <IRQ>  [<ffffffff81b35961>] print_usage_bug+0x1f7/0x208
> [    2.980587]  [<ffffffff8101001f>] ? save_stack_trace+0x2f/0x50
> [    2.980587]  [<ffffffff81098730>] ? print_shortest_lock_dependencies+0x1d0/0x1d0
> [    2.980587]  [<ffffffff810992a2>] mark_lock+0x262/0x2a0
> [    2.980587]  [<ffffffff81099af3>] __lock_acquire+0x813/0x1af0
> [    2.980587]  [<ffffffff8107da11>] ? load_balance+0xd1/0x730
> [    2.980587]  [<ffffffff8107baa0>] ? update_cfs_shares+0x100/0x100
> [    2.980587]  [<ffffffff8109b31a>] lock_acquire+0x8a/0x110
> [    2.980587]  [<ffffffff818f4e47>] ? ata_bmdma_interrupt+0x27/0x1d0
> [    2.980587]  [<ffffffff81b4d151>] _raw_spin_lock_irqsave+0x41/0x60
> [    2.980587]  [<ffffffff818f4e47>] ? ata_bmdma_interrupt+0x27/0x1d0
> [    2.980587]  [<ffffffff8107e070>] ? load_balance+0x730/0x730
> [    2.980587]  [<ffffffff818f4e47>] ata_bmdma_interrupt+0x27/0x1d0
> [    2.980587]  [<ffffffff810c2d5d>] handle_irq_event_percpu+0x5d/0x1f0
> [    2.980587]  [<ffffffff810c2f38>] handle_irq_event+0x48/0x70
> [    2.980587]  [<ffffffff81b4d059>] ? _raw_spin_lock+0x39/0x40
> [    2.980587]  [<ffffffff810c5f0e>] ? handle_fasteoi_irq+0x1e/0xf0
> [    2.980587]  [<ffffffff810c5f4a>] handle_fasteoi_irq+0x5a/0xf0
> [    2.980587]  [<ffffffff81003ce2>] handle_irq+0x22/0x40
> [    2.980587]  [<ffffffff81b4fdaa>] do_IRQ+0x5a/0xe0
> [    2.980587]  [<ffffffff81b4da6c>] common_interrupt+0x6c/0x6c
> [    2.980587]  <EOI>  [<ffffffff8100ab7f>] ? default_idle+0x5f/0x1b0
> [    2.980587]  [<ffffffff8100ab7d>] ? default_idle+0x5d/0x1b0
> [    2.980587]  [<ffffffff8100b816>] cpu_idle+0x106/0x120
> [    2.980587]  [<ffffffff81b2c7db>] start_secondary+0x1dd/0x1e4
> [    3.680628] ata4.00: ATA-6: ST3200822AS, 3.01, max UDMA/133
> [    3.689097] ata4.00: 390721968 sectors, multi 16: LBA48 
> [    3.719600] ata4.00: configured for UDMA/133
> [    3.728236] scsi 3:0:0:0: Direct-Access     ATA      ST3200822AS      3.01 PQ: 0 ANSI: 5
> [    3.737545] sd 3:0:0:0: [sda] 390721968 512-byte logical blocks: (200 GB/186 GiB)
> [    3.746818] sd 3:0:0:0: [sda] Write Protect is off
> [    3.756109] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    3.765428] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    3.822517]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
> [    3.833451] sd 3:0:0:0: [sda] Attached SCSI disk
> [    3.938019] ata5: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
> [    4.121436] registered taskstats version 1
> [    4.132352] rtc_cmos 00:02: setting system clock to 2012-08-29 13:26:05 UTC (1346246765)
> [    4.143433] md: Waiting for all devices to be available before autodetect
> [    4.154521] md: If you don't use raid, use raid=noautodetect
> [    4.166163] md: Autodetecting RAID arrays.
> [    4.177349] md: Scanned 0 and added 0 devices.
> [    4.188521] md: autorun ...
> [    4.199442] md: ... autorun DONE.
> [    4.231279] EXT3-fs (sda2): error: couldn't mount because of unsupported optional features (240)
> [    4.250247] EXT2-fs (sda2): error: couldn't mount because of unsupported optional features (240)
> [    4.288970] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
> [    4.300227] VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
> [    4.325724] devtmpfs: mounted
> [    4.338730] Freeing unused kernel memory: 868k freed
> [    4.350638] Write protecting the kernel read-only data: 16384k
> [    4.365030] Freeing unused kernel memory: 684k freed
> [    4.377568] Freeing unused kernel memory: 112k freed
> [    5.419243] loop: module loaded
> [    5.609483] udevd[1366]: starting version 182
> [    6.522401] microcode: AMD CPU family 0xf not supported
> [    6.655672] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> [    6.843767] parport_pc 00:07: reported by Plug and Play ACPI
> [    6.856734] parport0: PC-style at 0x378, irq 7 [PCSPP]
> [    6.973779] Linux agpgart interface v0.103
> [    7.063376] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
> [    7.076658] ACPI: Power Button [PWRB]
> [    7.089628] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
> [    7.102852] ACPI: Sleep Button [SLPB]
> [    7.115993] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
> [    7.116305] skge 0000:00:0a.0: PCI: Disallowing DAC for device
> [    7.116342] skge: 1.14 addr 0xfac00000 irq 17 chip Yukon-Lite rev 9
> [    7.116534] skge 0000:00:0a.0: eth0: addr 00:15:f2:09:ed:bf
> [    7.169302] ACPI: Power Button [PWRF]
> [    7.287407] ppdev: user-space parallel port driver
> [    7.695675] agpgart-amd64 0000:00:00.0: AGP bridge [1106/0282]
> [    7.711535] agpgart-amd64 0000:00:00.0: AGP aperture is 64M @ 0xec000000
> [    8.049819] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ (2 cpu cores) (version 2.20.00)
> [    8.063857] powernow-k8: fid 0xe (2200 MHz), vid 0x8
> [    8.077436] powernow-k8: fid 0xc (2000 MHz), vid 0xa
> [    8.091026] powernow-k8: fid 0xa (1800 MHz), vid 0xc
> [    8.104258] powernow-k8: fid 0x2 (1000 MHz), vid 0x12
> [    8.545648] [drm] Initialized drm 1.1.0 20060810
> [    8.727695] wmi: Mapper loaded
> [    9.537504] [drm] nouveau 0000:01:00.0: Detected an NV10 generation card (0x018100c1)
> [    9.551302] checking generic (f0000000 4000000) vs hw (f0000000 8000000)
> [    9.564505] fb: conflicting fb hw usage nouveaufb vs VESA VGA - removing generic driver
> [    9.578309] Console: switching to colour dummy device 80x25
> [    9.578806] [drm] nouveau 0000:01:00.0: Checking PRAMIN for VBIOS
> [    9.626640] [drm] nouveau 0000:01:00.0: ... appears to be valid
> [    9.626649] [drm] nouveau 0000:01:00.0: Using VBIOS from PRAMIN
> [    9.626860] [drm] nouveau 0000:01:00.0: BMP BIOS found
> [    9.626868] [drm] nouveau 0000:01:00.0: BMP version 5.40
> [    9.626876] [drm] nouveau 0000:01:00.0: Bios version 04.18.20.42
> [    9.627068] [drm] nouveau 0000:01:00.0: MXM: no VBIOS data, nothing to do
> [    9.627078] [drm] nouveau 0000:01:00.0: DCB version 2.2
> [    9.627087] [drm] nouveau 0000:01:00.0: DCB outp 00: 01000300 000088b8
> [    9.627099] [drm] nouveau 0000:01:00.0: DCB outp 01: 02010321 00000733
> [    9.627267] [drm] nouveau 0000:01:00.0: Loading NV17 power sequencing microcode
> [    9.627279] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xED14
> [    9.629327] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xF20C
> [    9.629358] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xEE96
> [    9.644421] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xF57F
> [    9.644435] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xF59C
> [    9.644448] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 5 at offset 0xF081
> [    9.655425] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 6 at offset 0xF1A7
> [    9.655712] [TTM] Zone  kernel: Available graphics memory: 1016192 kiB
> [    9.655730] [TTM] Initializing pool allocator
> [    9.655743] [TTM] Initializing DMA pool allocator
> [    9.655771] [drm] nouveau 0000:01:00.0: Detected 64MiB VRAM (DDR1)
> [    9.656188] agpgart-amd64 0000:00:00.0: AGP 3.0 bridge
> [    9.656220] agpgart: udevd tried to set rate=x12. Setting to AGP3 x8 mode.
> [    9.656234] agpgart-amd64 0000:00:00.0: putting AGP V3 device into 8x mode
> [    9.656334] nouveau 0000:01:00.0: putting AGP V3 device into 8x mode
> [    9.656343] [drm] nouveau 0000:01:00.0: 64 MiB GART (aperture)
> [    9.658112] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [    9.658122] [drm] No driver support for vblank timestamp query.
> [    9.664243] [drm] nouveau 0000:01:00.0: 0 available performance level(s)
> [    9.664262] [drm] nouveau 0000:01:00.0: c: core 274MHz memory 300MHz
> [    9.666667] [drm] nouveau 0000:01:00.0: MM: using M2MF for buffer copies
> [    9.685815] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on vga encoder (output 0)
> [    9.685824] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on TV encoder (output 1)
> [    9.710508] snd_via82xx 0000:00:11.5: setting latency timer to 64
> [    9.750214] [drm] nouveau 0000:01:00.0: allocated 1280x1024 fb: 0x49000, bo ffff88007a961400
> [    9.750317] fbcon: nouveaufb (fb0) is primary device
> [   10.411090] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on vga encoder (output 0)
> [   10.411093] [drm] nouveau 0000:01:00.0: Output VGA-1 is running on CRTC 0 using output A
> [   10.411126] Console: switching to colour frame buffer device 160x64
> [   10.413031] fb0: nouveaufb frame buffer device
> [   10.413032] drm: registered panic notifier
> [   10.413039] [drm] Initialized nouveau 1.0.0 20120316 for 0000:01:00.0 on minor 0
> [   10.659241] fuse init (API version 7.19)
> [   10.919831] EXT4-fs (sda2): re-mounted. Opts: (null)
> [   12.320662] lp0: using parport0 (interrupt-driven).
> [   12.320694] lp0: console ready
> [   15.703016] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> [   15.704557] REISERFS (device sda5): found reiserfs format "3.6" with standard journal
> [   15.704587] REISERFS (device sda5): using ordered data mode
> [   15.704597] reiserfs: using flush barriers
> [   15.705022] REISERFS (device sda5): journal params: device sda5, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
> [   15.706483] REISERFS (device sda5): checking transaction log (sda5)
> [   15.783261] REISERFS (device sda5): Using r5 hash to sort names
> [   15.824579] REISERFS (device sda6): found reiserfs format "3.6" with standard journal
> [   15.825093] REISERFS (device sda6): using ordered data mode
> [   15.825755] reiserfs: using flush barriers
> [   15.835069] REISERFS (device sda6): journal params: device sda6, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
> [   15.837852] REISERFS (device sda6): checking transaction log (sda6)
> [   15.925045] REISERFS (device sda6): Using r5 hash to sort names
> 
> 
> Thanks for helping !
> 
> Best regards
> Adko.
> 
> [
> 
> 

-- 
Regards/Gruss,
    Boris.
