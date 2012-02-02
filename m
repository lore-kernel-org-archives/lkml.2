Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab2BCAAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 19:00:21 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53309 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756006Ab2BCAAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 19:00:18 -0500
Date: Thu, 2 Feb 2012 15:58:52 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kevin Hilman <khilman@ti.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC 0/41] RCU commits for 3.4
Message-ID: <20120202235852.GO2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <871uqcc0p9.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871uqcc0p9.fsf@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020300-7182-0000-0000-000000A9931C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 02:47:14PM -0800, Kevin Hilman wrote:
> Hi Paul,
> 
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> 
> > This patchset makes RCU more aggressive about entering dyntick-idle mode
> > in order to improve energy efficiency, 
> 
> I gave this series a spin on an ARM/SMP platform (OMAP4) and the boot
> hung (tail end of boot log below.)  I then realized that had isolcpus=1
> on the cmdline from a previous experiment.  Removing isolcpus from the
> cmdline got me back to a working boot.
> 
> IIRC, some want to remove isolcpus, so I'm not sure if it's expected to
> work with your series, but thought you'd want to know.

Not expected behavior, thank you for testing!

Could you please share your .config?

							Thanx, Paul

> Kevin
> 
> 
> 
> [    1.105834] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    1.353942] omap_uart.0: ttyO0 at MMIO 0x4806a000 (irq = 104) is a OMAP UART0
> [    1.462707] omap_uart.1: ttyO1 at MMIO 0x4806c000 (irq = 105) is a OMAP UART1
> [    1.548614] omap_uart.2: ttyO2 at MMIO 0x48020000 (irq = 106) is a OMAP UART2
> [    1.556304] console [ttyO2] enabled, bootconsole disabled
> [    1.556304] console [ttyO2] enabled, bootconsole disabled
> [   61.587493] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=7682 jiffies)
> [   61.596649] INFO: Stall ended before state dump start
> 

