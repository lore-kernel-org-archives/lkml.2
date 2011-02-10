Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab1BJMkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:40:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41110 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab1BJMj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:39:59 -0500
Date: Thu, 10 Feb 2011 13:39:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: raz ben yehuda <raz@scalemp.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jack Steiner <steiner@sgi.com>,
        Cliff Wickman <cpw@sgi.com>, Mike Travis <travis@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG] soft lockup while booting machine with more than 700 cores
Message-ID: <20110210123937.GD26094@elte.hu>
References: <1297236453.2756.9.camel@raz.scalemp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297236453.2756.9.camel@raz.scalemp.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* raz ben yehuda <raz@scalemp.com> wrote:

> Mingo Hello
> 
> Bellow is a boot of a 2.6.32.19 kernel over a machine with more than 700 cores. I 
> am failing to boot it due to a soft lockup in rebalance_domains area. I did not 
> find anything related in mainline git and kernel's bugzilla.
> 
> thank you
> Raz
> 
> 
>  [  929.614315] TCP cubic registered 
>  [  929.614577] NET: Registered protocol family 17 
>  [  930.785915] Bridge firewalling registered 
>  [  930.928396] Freeing unused kernel memory: 1380k freed 
>  =============================================================================== 
>  Running /disklessrc 
>  Mounting /proc 
>  Creating /dev 
>  Creating initial device nodes 
> [  931.327841] usb 5-1: configuration #1 chosen from 1 choice 
> [  931.657469] input: HP Virtual Keyboard as /class/input/input0 
> [  931.671560] generic-usb 0003:03F0:1027.0001: input: USB HID v1.01 Keyboard [H
> P Virtual Keyboard] on usb-0000:01:04.0-1/input0 
>  [  931.911480] input: HP Virtual Keyboard as /class/input/input1 
>  [  931.926135] generic-usb 0003:03F0:1027.0002: input: USB HID v1.01 Mouse [HP V
>  irtual Keyboard] on usb-0000:01:04.0-1/input1 
>  [  932.247432] scsi 0:0:0:0: Direct-Access     Generic  USB Flash Disk   0.00 PQ
>  : 0 ANSI: 2 
>  [  932.301626] sd 0:0:0:0: Attached scsi generic sg0 type 0 
>  [  932.416279] sd 0:0:0:0: [sda] 7892992 512-byte logical blocks: (4.04 GB/3.76 
>  GiB) 
>  [  932.559424] sd 0:0:0:0: [sda] Write Protect is off 
>  [  932.563238] sd 0:0:0:0: [sda] Assuming drive cache: write through 
>  [  932.802006] sd 0:0:0:0: [sda] Assuming drive cache: write through 
>  [  932.805070]  sda: sda1 
>  [  934.315071] sd 0:0:0:0: [sda] Assuming drive cache: write through 
>  [  934.318055] sd 0:0:0:0: [sda] Attached SCSI removable disk 
>  Loading nfs module... [ 1011.681028] BUG: soft lockup - CPU#240 stuck for 62s! [
>  swapper:0] 
>  [ 1011.744482] Modules linked in: sunrpc(+) 
>  [ 1011.789117] CPU 240: 
>  [ 1011.828757] Modules linked in: sunrpc(+) 
>  [ 1011.874003] Pid: 0, comm: swapper Not tainted 2.6.32.19-3.vSMP #2 vSMP 3.5 
>  [ 1011.935843] RIP: 0010:[<ffffffff8105ac32>]  [<ffffffff8105ac32>] weighted_cpu
>  load+0x12/0x20 
>  [ 1012.051597] RSP: 0018:ffff89468e803c88  EFLAGS: 00010286 
>  [ 1012.115020] RAX: 00000000000115c0 RBX: 0000000000000002 RCX: 000000000000001d
>  [ 1012.162897] RDX: ffff8acd2e840000 RSI: 0000000000000002 RDI: 000000000000021d
>  [ 1012.243858] RBP: ffffffff81033133 R08: 0000000000000200 R09: ffff894f0ca3d450
>  [ 1012.309760] R10: 0000000000000000 R11: ffff89468e803dc0 R12: ffff89468e803c00
>  [ 1012.358023] R13: 00000000000115c0 R14: ffffffff8104b6dc R15: ffffffff81046ea6
>  [ 1012.417072] FS:  0000000000000000(0000) GS:ffff89468e800000(0000) knlGS:00000
>  00000000000 
>  [ 1012.494488] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b 
>  [ 1012.559412] CR2: 00000000008d3988 CR3: 0000000001001000 CR4: 00000000000026e0
>  [ 1012.619828] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  [ 1012.675491] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
>  [ 1012.739386] Call Trace: 
>  [ 1012.790082]  <IRQ>  [<ffffffff81039705>] ? sched_clock+0x5/0x10 
>  [ 1012.868687]  [<ffffffff8105ac6b>] ? source_load+0x2b/0x70 
>  [ 1012.923473]  [<ffffffff810602d5>] ? find_busiest_group+0x1b5/0xa30 
>  [ 1012.973482]  [<ffffffff81063487>] ? rebalance_domains+0x117/0x470 
>  [ 1013.031838]  [<ffffffff81065a4e>] ? run_rebalance_domains+0x3e/0xe0 
>  [ 1013.081837]  [<ffffffff8106fbbe>] ? __do_softirq+0xae/0x140 
>  [ 1013.134496]  [<ffffffff81085da0>] ? ktime_get+0x50/0xd0 
> [ 1013.182834]  [<ffffffff8103374c>] ? call_softirq+0x1c/0x30 
>  [ 1013.246263]  [<ffffffff81035745>] ? do_softirq+0x65/0xa0 
>  [ 1013.314801]  [<ffffffff8106fb0c>] ? irq_exit+0x7c/0x80 
>  [ 1013.355605]  [<ffffffff81046eab>] ? smp_apic_timer_interrupt+0x6b/0xa0 
>  [ 1013.391166]  [<ffffffff8104b6dc>] ? native_apic_msr_write+0x2c/0x40 
>  [ 1013.391166]  [<ffffffff81033133>] ? apic_timer_interrupt+0x13/0x20 
>  [ 1013.478307]  <EOI>  [<ffffffff8104dc92>] ? native_safe_halt+0x2/0x10 
>  [ 1013.515916]  [<ffffffff8103a481>] ? default_idle+0x21/0x40 
>  [ 1013.572168]  [<ffffffff81031537>] ? cpu_idle+0x57/0x90 
>  [ 1112.445978] BUG: soft lockup - CPU#240 stuck for 62s! [swapper:0] 
>  [ 1112.445978] Modules linked in: sunrpc(+) 

Interesting.

Could you boot up with just enough cores for it to not lock up, and run perf top and 
see where the overhead is?

Thanks,

	Ingo
