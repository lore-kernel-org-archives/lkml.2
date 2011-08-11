Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab1HKQPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 12:15:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:41626 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab1HKQPH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 12:15:07 -0400
Subject: Re: [ANNOUNCE] 3.0.1-rt8 - Regression to 3.0-rt7
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Sander <tim.sander@hbm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 11 Aug 2011 18:14:45 +0200
In-Reply-To: <201108111804.11136.tim.sander@hbm.com>
References: <1312580681.28695.44.camel@twins>
	 <201108111330.28168.tim.sander@hbm.com> <1313066498.8491.1.camel@twins>
	 <201108111804.11136.tim.sander@hbm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313079285.8491.4.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 18:04 +0200, Tim Sander wrote:
> 
> kernel BUG at kernel/posix-cpu-timers.c:1315!
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
> pgd = c0004000
> [00000000] *pgd=00000000
> Internal error: Oops: 817 [#1] PREEMPT
> Modules linked in: i2c_imx(+) netx netx_reset dspload fpgaload mxc_nand(+) nand nand_ids nand_ecc
> CPU: 0    Not tainted  (3.0.0-pmx-rt8-00009-g39305ab #167)
> PC is at __bug+0x24/0x30
> LR is at walk_stackframe+0x24/0x40
> pc : [<c002cbf0>]    lr : [<c002cbb0>]    psr: 60000113
> sp : c782ff40  ip : c782fe28  fp : c782ff4c
> r10: 00000001  r9 : 00000000  r8 : c78663c0
> r7 : c030463c  r6 : c782e000  r5 : 00000000  r4 : c78663c0
> r3 : 00000000  r2 : 00000001  r1 : c782fe58  r0 : 00000034
> Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> Control: 00c5387d  Table: 87b70008  DAC: 00000017
> Process posixcputmr/0 (pid: 6, stack limit = 0xc782e268)
> Stack: (0xc782ff40 to 0xc7830000)
> ff40: c782ff8c c782ff50 c005a5c0 c002cbd8 00000000 c782ff54 c782ff54 00000000
> ff60: 00000000 c78663c0 00000000 c782e000 c030463c c78663c0 00000000 00000001
> ff80: c782ffbc c782ff90 c005a88c c005a594 00000000 c7817f28 00000000 c782ffcc
> ffa0: c005a800 00000000 00000000 00000000 c782fff4 c782ffc0 c00570f0 c005a80c
> ffc0: c7817f28 00000000 00000000 00000000 c782ffd0 c782ffd0 c7817f28 c0057064
> ffe0: c0040868 00000013 00000000 c782fff8 c0040868 c0057070 cccdcd6c ffdec890
> Backtrace: 
> [<c002cbcc>] (__bug+0x0/0x30) from [<c005a5c0>] (__run_posix_cpu_timers+0x38/0x278)
> [<c005a588>] (__run_posix_cpu_timers+0x0/0x278) from [<c005a88c>] (posix_cpu_timers_thread+0x8c/0x124)
> [<c005a800>] (posix_cpu_timers_thread+0x0/0x124) from [<c00570f0>] (kthread+0x8c/0x94)
> [<c0057064>] (kthread+0x0/0x94) from [<c0040868>] (do_exit+0x0/0x2d8)
>  r7:00000013 r6:c0040868 r5:c0057064 r4:c7817f28
> Code: e59f0010 e1a01003 eb086a88 e3a03000 (e5833000) 
> ---[ end trace d632afeaa11559d4 ]--- 

Yay a new one, and this is a PREEMPT_LL build right? /me goes poke at
it.
