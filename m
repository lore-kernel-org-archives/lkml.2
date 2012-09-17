Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab2IQJKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 05:10:33 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43143 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab2IQJKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 05:10:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120914175322.GI4257@linux.vnet.ibm.com>
References: <CACRpkdYgxsF1G7Dc_xCcQcFV9G+foz1czOCmROcMQ5NfR-ziCA@mail.gmail.com>
	<50520E8A.9030408@linaro.org>
	<20120913165844.GW4257@linux.vnet.ibm.com>
	<CACRpkdatjfk_eUof5G4fwa-Qf8SoF_NvSUJQAZ7U8yjcSYFuTA@mail.gmail.com>
	<20120914175322.GI4257@linux.vnet.ibm.com>
Date: Mon, 17 Sep 2012 11:10:30 +0200
Message-ID: <CACRpkdbw+VgaV26U6uZeKr9g28ax2shrieQSxFuj-Pi9RXPtLQ@mail.gmail.com>
Subject: Re: RCU lockup in the SMP idle thread, help...
From: Linus Walleij <linus.walleij@linaro.org>
To: paulmck@linux.vnet.ibm.com
Cc: John Stultz <john.stultz@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 7:53 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:

> Could you please try reproducing with CONFIG_RCU_CPU_STALL_INFO=y?

Yep: looks like this:

INFO: rcu_preempt detected stalls on CPUs/tasks:
        0: (0 ticks this GP) idle=458/0/0
        (detected by 1, t=29904 jiffies)
[<c0014710>] (unwind_backtrace+0x0/0xf8) from [<c00687dc>]
(rcu_check_callbacks+0x6f8/0x730)
[<c00687dc>] (rcu_check_callbacks+0x6f8/0x730) from [<c0029cbc>]
(update_process_times+0x38/0x4c)
[<c0029cbc>] (update_process_times+0x38/0x4c) from [<c0055088>]
(tick_sched_timer+0x80/0xe4)
[<c0055088>] (tick_sched_timer+0x80/0xe4) from [<c003c120>]
(__run_hrtimer.isra.18+0x44/0xd0)
[<c003c120>] (__run_hrtimer.isra.18+0x44/0xd0) from [<c003cae0>]
(hrtimer_interrupt+0x118/0x2b4)
[<c003cae0>] (hrtimer_interrupt+0x118/0x2b4) from [<c0013658>]
(twd_handler+0x30/0x44)
[<c0013658>] (twd_handler+0x30/0x44) from [<c00638c8>]
(handle_percpu_devid_irq+0x80/0xa0)
[<c00638c8>] (handle_percpu_devid_irq+0x80/0xa0) from [<c00603b8>]
(generic_handle_irq+0x20/0x30)
[<c00603b8>] (generic_handle_irq+0x20/0x30) from [<c000ef58>]
(handle_IRQ+0x4c/0xac)
[<c000ef58>] (handle_IRQ+0x4c/0xac) from [<c00084bc>] (gic_handle_irq+0x24/0x58)
[<c00084bc>] (gic_handle_irq+0x24/0x58) from [<c000dc80>] (__irq_svc+0x40/0x70)
Exception stack(0xcf865f88 to 0xcf865fd0)
5f80:                   00000020 c05c0a20 00000001 00000000 cf864000 cf864000
5fa0: c05dfe48 c02de0b4 c05c3e90 412fc091 cf864000 00000000 01000000 cf865fd0
5fc0: c000f234 c000f238 60000013 ffffffff
[<c000dc80>] (__irq_svc+0x40/0x70) from [<c000f238>] (default_idle+0x28/0x30)
[<c000f238>] (default_idle+0x28/0x30) from [<c000f438>] (cpu_idle+0x98/0xe4)
[<c000f438>] (cpu_idle+0x98/0xe4) from [<002d3114>] (0x2d3114)

Yours,
Linus Walleij
