Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab2BBWrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:47:14 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:48887 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753776Ab2BBWrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:47:13 -0500
From: Kevin Hilman <khilman@ti.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC 0/41] RCU commits for 3.4
Organization: Texas Instruments, Inc.
References: <20120201194131.GA10028@linux.vnet.ibm.com>
Date: Thu, 02 Feb 2012 14:47:14 -0800
In-Reply-To: <20120201194131.GA10028@linux.vnet.ibm.com> (Paul E. McKenney's
	message of "Wed, 1 Feb 2012 11:41:31 -0800")
Message-ID: <871uqcc0p9.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

> This patchset makes RCU more aggressive about entering dyntick-idle mode
> in order to improve energy efficiency, 

I gave this series a spin on an ARM/SMP platform (OMAP4) and the boot
hung (tail end of boot log below.)  I then realized that had isolcpus=1
on the cmdline from a previous experiment.  Removing isolcpus from the
cmdline got me back to a working boot.

IIRC, some want to remove isolcpus, so I'm not sure if it's expected to
work with your series, but thought you'd want to know.

Kevin



[    1.105834] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.353942] omap_uart.0: ttyO0 at MMIO 0x4806a000 (irq = 104) is a OMAP UART0
[    1.462707] omap_uart.1: ttyO1 at MMIO 0x4806c000 (irq = 105) is a OMAP UART1
[    1.548614] omap_uart.2: ttyO2 at MMIO 0x48020000 (irq = 106) is a OMAP UART2
[    1.556304] console [ttyO2] enabled, bootconsole disabled
[    1.556304] console [ttyO2] enabled, bootconsole disabled
[   61.587493] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=7682 jiffies)
[   61.596649] INFO: Stall ended before state dump start
