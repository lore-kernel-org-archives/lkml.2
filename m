Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422760Ab2JLPWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:22:46 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:59594 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756485Ab2JLPWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:22:44 -0400
Date: Fri, 12 Oct 2012 20:46:42 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [Linux 3.5] kernel BUG at mm/slub.c:3474!
Message-ID: <20121012151641.GH798@markyou.marvell.com>
References: <20120724122032.GA4120@markyou.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120724122032.GA4120@markyou.marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 12 Oct 2012 15:21:10.0591 (UTC) FILETIME=[358D24F0:01CDA88D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 05:20:37AM -0700, Yogesh Ashok Powar wrote:
> Hello All,
> 
> I am seeing the bug_on being hit on ARM  Kirkwood based board.
> I am on Linux 3.5 stable tree.

Also seeing similar on 3.6.1 with default kirkwood_defconfig on 6281
board.

New crash is as following

Thanks
Yogesh
------------[ cut here ]------------
kernel BUG at mm/slub.c:3483!
Internal error: Oops - BUG: 0 [#1] PREEMPT ARM
Modules linked in:
CPU: 0    Not tainted  (3.6.1-02158-g2eb8803 #854)
PC is at kfree+0xf4/0x104
LR is at 0xc0762260
pc : [<c0098f98>]    lr : [<c0762260>]    psr: 40000013
sp : c059fcfc  ip : 07b13000  fp : c7b13040
r10: c7bd09c0  r9 : c05cc6f0  r8 : c7b13038
r7 : c02b54ec  r6 : c7bff400  r5 : c7b13040  r4 : c7b13000
r3 : 00000000  r2 : 00000000  r1 : c06580c4  r0 : c066c000
Flags: nZcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0005397f  Table: 0709c000  DAC: 00000017
Process swapper (pid: 0, stack limit = 0xc059e270)
Stack: (0xc059fcfc to 0xc05a0000)
fce0:                                                                c7bd09c0
fd00: c7b13040 c7bff400 c78c1600 c02b54ec c7bfce00 c03180c8 c7bff400 c05a6500
fd20: c70d07b8 00000000 c7aede40 00000000 c70d0000 00000000 c70d0000 c059fe1c
fd40: c059e000 c039e034 0f821f0a 01821f0a 00000188 c7bd09c0 c05a648c c05a798c
fd60: 00000608 00000000 c0666a60 c05a64b0 00200000 c02bdec0 c059e000 c7bff400
fd80: 00000000 00020020 00000037 c7bd09c0 c70d03a0 c05a64b0 0000000f c7bd09c0
fda0: c7aafb40 c7bd09c0 00000000 c7b13032 00000010 c7a84d00 00200000 c0355c78
fdc0: 000e1180 c000df38 c0011d5c c7bd09c0 c05a64ac c05a82f4 0000dada 00000000
fde0: c0666a60 c05a64d0 00200000 c02bdec0 c059e000 c7814000 00000002 00000000
fe00: c7aede40 c7bd09c0 00000010 c05a64d0 c0011d70 60004803 00000000 c78144e8
fe20: c78143a0 c7814070 c7bd09c0 2cc7fffe c78143a0 c0235578 00000000 3fffa0c4
fe40: 00000000 00000080 c7814474 00000000 00000010 c059e000 00000001 00000000
fe60: c7816280 00000080 c7814474 0000012c 0000000c c05d3540 c05d3548 ffffa0c7
fe80: c05aff80 c02c2f60 0000000b 00000003 00000001 c065594c 0000000c 00000102
fea0: 0000000a c059e000 c05b09b4 c001d698 c7bf5c00 c059ff34 c027d138 00200000
fec0: c05acf48 c059e000 c05b8d84 00000000 c059ff34 c027d138 56251311 c05acf48
fee0: 00000000 c001dc18 0000000b c00095f4 c027d730 20000013 fed20200 c03be994
ff00: 16c34c98 0000000d 3b9aca00 0000000d 16b42c27 0000000d 00000000 00000000
ff20: c027d138 56251311 c05acf48 00000000 0000001d c059ff48 3145144d c027d730
ff40: 20000013 ffffffff 16c34c98 0000000d 16b42c27 0000000d c05acf48 00000001
ff60: 063ae6d0 c05acf48 c05acf48 c05accd0 00000000 c06668d0 c05a6000 c027d170
ff80: ffffffff 00000000 c05acf48 c05accd0 00000000 c027d834 c059e000 c05d4134
ffa0: c05a9f40 ffffffff 3fffffff c0009e58 c05a6118 c05d40a0 c0597e40 c05798e4
ffc0: ffffffff ffffffff c0579214 00000000 00000000 c0597e40 00000000 00053975
ffe0: c05a6038 c0598244 c05a9f34 00004000 005965b8 00008040 00000000 00000000
[<c0098f98>] (kfree+0xf4/0x104) from [<c02b54ec>] (__kfree_skb+0xc/0xbc)
[<c02b54ec>] (__kfree_skb+0xc/0xbc) from [<c03180c8>] (arp_process+0x60/0x5e8)
[<c03180c8>] (arp_process+0x60/0x5e8) from [<c02bdec0>] (__netif_receive_skb+0x304/0x5ac)
[<c02bdec0>] (__netif_receive_skb+0x304/0x5ac) from [<c0355c78>] (edsa_rcv+0x1d4/0x26c)
[<c0355c78>] (edsa_rcv+0x1d4/0x26c) from [<c02bdec0>] (__netif_receive_skb+0x304/0x5ac)
[<c02bdec0>] (__netif_receive_skb+0x304/0x5ac) from [<c0235578>] (mv643xx_eth_poll+0x5e0/0x724)
[<c0235578>] (mv643xx_eth_poll+0x5e0/0x724) from [<c02c2f60>] (net_rx_action+0xc8/0x184)
[<c02c2f60>] (net_rx_action+0xc8/0x184) from [<c001d698>] (__do_softirq+0x9c/0x154)
[<c001d698>] (__do_softirq+0x9c/0x154) from [<c001dc18>] (irq_exit+0x9c/0xa4)
[<c001dc18>] (irq_exit+0x9c/0xa4) from [<c00095f4>] (handle_IRQ+0x38/0x84)
[<c00095f4>] (handle_IRQ+0x38/0x84) from [<c03be994>] (__irq_svc+0x34/0x98)
[<c03be994>] (__irq_svc+0x34/0x98) from [<c027d730>] (cpuidle_wrap_enter+0x54/0xbc)
[<c027d730>] (cpuidle_wrap_enter+0x54/0xbc) from [<c027d170>] (cpuidle_enter_state+0x18/0x6c)
[<c027d170>] (cpuidle_enter_state+0x18/0x6c) from [<c027d834>] (cpuidle_idle_call+0x90/0xe0)
[<c027d834>] (cpuidle_idle_call+0x90/0xe0) from [<c0009e58>] (cpu_idle+0x84/0xd0)
[<c0009e58>] (cpu_idle+0x84/0xd0) from [<c05798e4>] (start_kernel+0x238/0x2bc)
Code: e1a02004 e1a03007 e8bd40f0 eaffff01 (e7f001f2) 
---[ end trace 2ec24a7206cf01b2 ]---

