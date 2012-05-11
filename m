Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2EKFLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 01:11:30 -0400
Received: from sour.ops.eusc.inter.net ([84.23.254.154]:60958 "EHLO
	sour.ops.eusc.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab2EKFL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 01:11:26 -0400
X-Greylist: delayed 1397 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 May 2012 01:11:26 EDT
X-Trace: 507c73656261737469616e2e6b6c6f736b6140736e6166752e64657c38352e3137
	382e36372e3230317c315353686c762d3030304b4a4f2d34747c31333336373131
	363837
Message-ID: <4FAC9A06.4060002@snafu.de>
Date: Fri, 11 May 2012 06:48:06 +0200
From: Oncaphillis <oncaphillis@snafu.de>
Reply-To: oncaphillis@snafu.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Memory corruption in SLUB from within USB Driver
References: <4FAADBD4.3050604@snafu.de>
In-Reply-To: <4FAADBD4.3050604@snafu.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 85.178.67.201
X-SA-Exim-Mail-From: oncaphillis@snafu.de
X-SA-Exim-Scanned: No (on sour.ops.eusc.inter.net); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 11:04 PM, Oncaphillis wrote:
> Hallo,
>
> I'm developing a hardware application based on theEZ-USB SX2 Chip
> from Cypress using libusb-1.0.8 and I see kernel crashes like:
>
> <snip>
> May 03 19:11:59 [kernel] Pid: 3998, comm: Engine25DeviceP Tainted: P
> 2.6.38.2+ #1 To be filled by O.E.M. To be fil
> May 03 19:11:59 [kernel] RIP: 0010:[<ffffffff810b6e7c>]
> [<ffffffff810b6e7c>] kfree+0x84/0xda
> May 03 19:11:59 [kernel] RSP: 0018:ffff88013bfc1dc8 EFLAGS: 00010246
> May 03 19:11:59 [kernel] RAX: 4000000000000000 RBX: ffff8800ba814100
> RCX: 00007fffb5035158
> May 03 19:11:59 [kernel] RDX: ffffea0000000000 RSI: ffffea00028cc460
> RDI: ffff8800ba814100
> May 03 19:11:59 [kernel] RBP: ffff88013bfc1de8 R08: ffff88013c4c1f00
> R09: 0000000000000f9e
> May 03 19:11:59 [kernel] R10: 0000000000000000 R11: 0000000000000206
> R12: ffff88013cea2c00
> May 03 19:11:59 [kernel] R13: ffffffff8137ccde R14: ffff88013c30fd98
> R15: 000000004008550d
> May 03 19:11:59 [kernel] FS: 00007f8fa39f9720(0000)
> GS:ffff88001fd00000(0000) knlGS:0000000000000000
> May 03 19:11:59 [kernel] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> May 03 19:11:59 [kernel] CR2: 00007f8f93fff000 CR3: 000000013bfa5000
> CR4: 00000000000406e0
> May 03 19:11:59 [kernel] DR0: 0000000000000000 DR1: 0000000000000000
> DR2: 0000000000000000
> May 03 19:11:59 [kernel] DR3: 0000000000000000 DR6: 00000000ffff0ff0
> DR7: 0000000000000400
> May 03 19:11:59 [kernel] Process Engine25DeviceP (pid: 3998, threadinfo
> ffff88013bfc0000, task ffff88014035e540)
> May 03 19:11:59 [kernel] 0000000180000000 ffff88013cea2c00
> ffff88013cea2c00 00007fffb5035158
> May 03 19:11:59 [kernel] ffff88013bfc1e08 ffffffff8137ccde
> 00007fffb5035158 0000000000000000
> May 03 19:11:59 [kernel] ffff88013bfc1e98 ffffffff8137f494
> ffff880138886800 ffff8801388868e8
> May 03 19:11:59 [kernel] [<ffffffff8137ccde>] free_async+0x22/0x47
> May 03 19:11:59 [kernel] [<ffffffff8137f494>] usbdev_do_ioctl+0xa51/0xd3f
> May 03 19:11:59 [kernel] [<ffffffff81050d8c>] ?
> __hrtimer_start_range_ns+0x2f3/0x305
> May 03 19:11:59 [kernel] [<ffffffff8137f79a>] usbdev_ioctl+0x9/0xd
> May 03 19:11:59 [kernel] [<ffffffff810c76a3>] do_vfs_ioctl+0x3e9/0x438
> May 03 19:11:59 [kernel] [<ffffffff810c811e>] ?
> poll_select_set_timeout+0x61/0x7c
> May 03 19:11:59 [kernel] [<ffffffff810c7734>] sys_ioctl+0x42/0x65
> May 03 19:11:59 [kernel] [<ffffffff81001f3b>]
> system_call_fastpath+0x16/0x1b
> May 03 19:11:59 [kernel] RIP [<ffffffff810b6e7c>] kfree+0x84/0xda
> May 03 19:11:59 [kernel] RSP <ffff88013bfc1dc8>
> May 03 19:11:59 [kernel] ---[ end trace bcf8fadb3664e4f9 ]---
> </snip>
>
>
> Here it crashes in the context of the usbdev but sometimes it happens
> from within the
> network driver. So in essence the memory management if SLUB seems to be
> corrupted.
> I've activated Memory poisoning via /sys/kernel/slab/kmalloc-512/poison and
> found the following.
>
> <snip>
>
> May 09 18:46:34 [kernel] [ 133.013088]
> =============================================================================
>
> May 09 18:46:34 [kernel] [ 133.013091] BUG kmalloc-512 (Not tainted):
> Poison overwritten
> May 09 18:46:34 [kernel] [ 133.013093]
> -----------------------------------------------------------------------------
>
> May 09 18:46:34 [kernel] [ 133.013093]
> May 09 18:46:34 [kernel] [ 133.013096] INFO:
> 0xffff880079b253b0-0xffff880079b253b1. First byte 0x9d instead of 0x6b
> May 09 18:46:34 [kernel] [ 133.013102] INFO: Allocated in
> proc_do_submiturb+0x41a/0x876 age=188 cpu=0 pid=4468
> May 09 18:46:34 [kernel] [ 133.013105] _T.987+0x1fc/0x239
> May 09 18:46:34 [kernel] [ 133.013106] ___kmalloc+0xc8/0x15b
> May 09 18:46:34 [kernel] [ 133.013108] _proc_do_submiturb+0x41a/0x876
> May 09 18:46:34 [kernel] [ 133.013110] _usbdev_do_ioctl+0x83b/0xd30
> May 09 18:46:34 [kernel] [ 133.013112] _usbdev_ioctl+0x9/0xd
> May 09 18:46:34 [kernel] [ 133.013114] _do_vfs_ioctl+0x3cc/0x412
> May 09 18:46:34 [kernel] [ 133.013116] _sys_ioctl+0x42/0x65
> May 09 18:46:34 [kernel] [ 133.013119] _system_call_fastpath+0x16/0x1b
> May 09 18:46:34 [kernel] [ 133.013122] INFO: Freed in
> free_async+0x3a/0x69 age=63 cpu=0 pid=4468
> May 09 18:46:34 [kernel] [ 133.013123] ___slab_free+0x2d/0x2a5
> May 09 18:46:34 [kernel] [ 133.013125] _kfree+0xe4/0xed
> May 09 18:46:34 [kernel] [ 133.013126] _free_async+0x3a/0x69
> May 09 18:46:34 [kernel] [ 133.013128] _usbdev_do_ioctl+0xa48/0xd30
> May 09 18:46:34 [kernel] [ 133.013130] _usbdev_ioctl+0x9/0xd
> May 09 18:46:34 [kernel] [ 133.013132] _do_vfs_ioctl+0x3cc/0x412
> May 09 18:46:34 [kernel] [ 133.013133] _sys_ioctl+0x42/0x65
> May 09 18:46:34 [kernel] [ 133.013135] _system_call_fastpath+0x16/0x1b
> May 09 18:46:34 [kernel] [ 133.013137] INFO: Slab 0xffffea0001e6c900
> objects=19 used=19 fp=0x (null) flags=0x4000000000004080
> May 09 18:46:34 [kernel] [ 133.013139] INFO: Object 0xffff880079b253b0
> @offset=5040 fp=0xffff880079b24000
> May 09 18:46:34 [kernel] [ 133.013140]
>
> May 09 18:46:34 [kernel] [ 133.013142] Bytes b4 ffff880079b253a0: f3 5b
> ff ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a .[......ZZZZZZZZ
> May 09 18:46:34 [kernel] [ 133.013144] Object ffff880079b253b0: 9d 8d 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b ..kkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013146] Object ffff880079b253c0: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013148] Object ffff880079b253d0: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013149] Object ffff880079b253e0: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013153] Object ffff880079b25400: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013155] Object ffff880079b25410: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013157] Object ffff880079b25420: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013158] Object ffff880079b25430: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013160] Object ffff880079b25440: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013162] Object ffff880079b25450: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013164] Object ffff880079b25460: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013166] Object ffff880079b25470: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013167] Object ffff880079b25480: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013169] Object ffff880079b25490: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013171] Object ffff880079b254a0: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013173] Object ffff880079b254b0: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013175] Object ffff880079b254c0: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013176] Object ffff880079b254d0: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013178] Object ffff880079b254e0: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013180] Object ffff880079b254f0: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013182] Object ffff880079b25500: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013184] Object ffff880079b25510: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013193] Object ffff880079b25560: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013195] Object ffff880079b25570: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013196] Object ffff880079b25580: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013198] Object ffff880079b25590: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> May 09 18:46:34 [kernel] [ 133.013200] Object ffff880079b255a0: 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk.
> May 09 18:46:34 [kernel] [ 133.013202] Redzone ffff880079b255b0: bb bb
> bb bb bb bb bb bb ........
> May 09 18:46:34 [kernel] [ 133.013204] Padding ffff880079b256f0: 5a 5a
> 5a 5a 5a 5a 5a 5a ZZZZZZZZ
> May 09 18:46:34 [kernel] [ 133.013206] Pid: 0, comm: swapper/2 Not
> tainted 3.3.4 #2
> May 09 18:46:34 [kernel] [ 133.013207] Call Trace:
> May 09 18:46:34 [kernel] [ 133.013209] <IRQ> [<ffffffff810ca00b>]
> print_trailer+0x129/0x132
> May 09 18:46:34 [kernel] [ 133.013215] [<ffffffff810ca53f>]
> check_bytes_and_report+0xb2/0xeb
> May 09 18:46:34 [kernel] [ 133.013218] [<ffffffff81437fbb>] ?
> ___pskb_trim+0x43/0x248
> May 09 18:46:34 [kernel] [ 133.013220] [<ffffffff810ca62d>]
> check_object+0xb5/0x1e2
> May 09 18:46:34 [kernel] [ 133.013222] [<ffffffff81437f5c>] ?
> __netdev_alloc_skb+0x1d/0x39
> May 09 18:46:34 [kernel] [ 133.013224] [<ffffffff810cbf0e>]
> alloc_debug_processing+0xa4/0x138
> May 09 18:46:34 [kernel] [ 133.013226] [<ffffffff810cc94f>]
> T.987+0x1fc/0x239
> May 09 18:46:34 [kernel] [ 133.013228] [<ffffffff81437f5c>] ?
> __netdev_alloc_skb+0x1d/0x39
> May 09 18:46:34 [kernel] [ 133.013231] [<ffffffff8143dfb6>] ?
> netif_receive_skb+0x71/0x78
> May 09 18:46:34 [kernel] [ 133.013233] [<ffffffff810ce104>]
> __kmalloc_track_caller+0xc9/0x155
> May 09 18:46:34 [kernel] [ 133.013235] [<ffffffff81437f5c>] ?
> __netdev_alloc_skb+0x1d/0x39
> May 09 18:46:34 [kernel] [ 133.013237] [<ffffffff81436f54>]
> __alloc_skb+0x69/0x12e
> May 09 18:46:34 [kernel] [ 133.013239] [<ffffffff81437f5c>]
> __netdev_alloc_skb+0x1d/0x39
> May 09 18:46:34 [kernel] [ 133.013243] [<ffffffff81379a25>]
> e1000_clean_rx_irq+0x1b8/0x2c1
> May 09 18:46:34 [kernel] [ 133.013246] [<ffffffff8104b1a4>] ?
> check_preempt_curr+0x3e/0x6c
> May 09 18:46:34 [kernel] [ 133.013248] [<ffffffff8137be80>]
> e1000_clean+0x75/0x23e
> May 09 18:46:34 [kernel] [ 133.013251] [<ffffffff81051d63>] ?
> T.1553+0x3a/0x3f
> May 09 18:46:34 [kernel] [ 133.013253] [<ffffffff8143e726>]
> net_rx_action+0x6a/0x1cb
> May 09 18:46:34 [kernel] [ 133.013256] [<ffffffff81030459>]
> __do_softirq+0xc2/0x182
> May 09 18:46:34 [kernel] [ 133.013258] [<ffffffff81520e0c>]
> call_softirq+0x1c/0x30
> May 09 18:46:34 [kernel] [ 133.013261] [<ffffffff81003207>]
> do_softirq+0x33/0x68
> May 09 18:46:34 [kernel] [ 133.013263] [<ffffffff810301d3>]
> irq_exit+0x44/0x9c
> May 09 18:46:34 [kernel] [ 133.013265] [<ffffffff81002a76>]
> do_IRQ+0x98/0xaf
> May 09 18:46:34 [kernel] [ 133.013268] [<ffffffff815198ab>]
> common_interrupt+0x6b/0x6b
> May 09 18:46:34 [kernel] [ 133.013269] <EOI> [<ffffffff810080af>] ?
> mwait_idle+0xad/0xeb
> May 09 18:46:34 [kernel] [ 133.013273] [<ffffffff81001553>]
> cpu_idle+0x68/0xa4
> May 09 18:46:34 [kernel] [ 133.013275] [<ffffffff81513d8a>]
> start_secondary+0x1bd/0x1c1
> May 09 18:46:34 [kernel] [ 133.013278] FIX kmalloc-512: Restoring
> 0xffff880079b253b0-0xffff880079b253b1=0x6b
> May 09 18:46:34 [kernel] [ 133.013279]
> May 09 18:46:34 [kernel] [ 133.013280] FIX kmalloc-512: Marking all
> objects used
> </snip>
>
> So the USB Driver seems to exceed the memory it has allocated:
>
> This is for the kernel 3.3.4 but I saw it in 2.6.x kernels as well
>
> Here's a lspci as well
>
> <snip>
>
> 00:00.0 Host bridge: Intel Corporation 82Q35 Express DRAM Controller
> (rev 02)
> 00:02.0 VGA compatible controller: Intel Corporation 82Q35 Express
> Integrated Graphics Controller (rev 02)
> 00:03.0 Communication controller: Intel Corporation 82Q35 Express MEI
> Controller (rev 02)
> 00:03.2 IDE interface: Intel Corporation 82Q35 Express PT IDER
> Controller (rev 02)
> 00:03.3 Serial controller: Intel Corporation 82Q35 Express Serial KT
> Controller (rev 02)
> 00:19.0 Ethernet controller: Intel Corporation 82566DM-2 Gigabit Network
> Connection (rev 02)
> 00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #4 (rev 02)
> 00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #5 (rev 02)
> 00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
> Controller #2 (rev 02)
> 00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
> Port 1 (rev 02)
> 00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
> Port 5 (rev 02)
> 00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #1 (rev 02)
> 00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #2 (rev 02)
> 00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #3 (rev 02)
> 00:1d.3 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #6 (rev 02)
> 00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
> Controller #1 (rev 02)
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
> 00:1f.0 ISA bridge: Intel Corporation 82801IO (ICH9DO) LPC Interface
> Controller (rev 02)
> 00:1f.2 IDE interface: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 4
> port SATA IDE Controller (rev 02)
> 00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller
> (rev 02)
> 00:1f.5 IDE interface: Intel Corporation 82801I (ICH9 Family) 2 port
> SATA IDE Controller (rev 02)
> 00:1f.6 Signal processing controller: Intel Corporation 82801I (ICH9
> Family) Thermal Subsystem (rev 02)
> 01:00.0 PCI bridge: PLX Technology, Inc. PEX8112 x1 Lane PCI
> Express-to-PCI Bridge (rev aa)
> 03:00.0 Ethernet controller: Intel Corporation 82573V Gigabit Ethernet
> Controller (Copper) (rev 03)
>
> </snip>
>
> Thanks
>
> O.
>
>
It looks like

drivers/usb/core/devio.c:proc_do_submiturb()

is involved. it does a copy_from_user in the transfer_buffer and fills 
it with this two byte sequence 9d 8d. Srange thing seems to be that the
contents of this array seems to be 6b 6b many more times then the one 
time eher SLUB complains about memor corruption.

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/

