Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab1BXMSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 07:18:13 -0500
Received: from www.tglx.de ([62.245.132.106]:35797 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab1BXMSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 07:18:10 -0500
Date: Thu, 24 Feb 2011 13:18:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Schaefer Dr, Frank-Rene ()" <fschaef9@visteon.com>
cc: linux-kernel@vger.kernel.org
Subject: RE: Interrupt Latencies
In-Reply-To: <060E4307CE6CA14BB4F7B4A25ECA052904BB7841@VEUMBV03.vistcorp.ad.visteon.com>
Message-ID: <alpine.LFD.2.00.1102241304250.2701@localhost6.localdomain6>
References: <060E4307CE6CA14BB4F7B4A25ECA052904B73AD1@VEUMBV03.vistcorp.ad.visteon.com> <4D63AD35.6050808@ladisch.de> <060E4307CE6CA14BB4F7B4A25ECA052904BB7841@VEUMBV03.vistcorp.ad.visteon.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank,

On Thu, 24 Feb 2011, Schaefer Dr, Frank-Rene () wrote:

> In response to Thomas Gleixner:
> 
> > Interrupt latency depends on various factors:
> > 
> >   - Interrupt disabled code regions
> Could you tell us how this could be detected or measured?
> Is there a central place, where we could toggle a pin to 
> see when interrupts are enabled/disabled? 

ftrace allows you to analyse that.
 
> >   - Concurrent interrupts and the ordering of handling
> We are only considering the best times that we measure.

Ok.

> >   - Deep idle states
> You mean 'suspend' or some type of CPU sleep. Could you elaborate?
> We do not suspend. This should also only be the case for the 
> first chunk that is transmitted. But the latencies remain
> over longer time spans.

NOHZ idle can push the cpu into deeper power states (C2/C3). But there
are also BIOSes which do agressive power management behind the kernels
back.

Turn off CONFIG_NOHZ and add "processor.max_cstate=1" to the kernel
command line. You might also try "idle=poll" for a test.
 
> >   - Bus contention
> Nothing else is running. 

That does not guarantee anything. Think DMA.

> > How is that interrupt connected to the CPU/chipset? 
> The port is part of the chipset connected internally 
> via PCI.
> 
> > Which driver(s) is/are involved ? 
> http://lxr.free-electrons.com/source/drivers/gpio/pl061.c
> 
> > How is the pin OUT accessed from the driver?
> gpio_set_value(Pin, Value);
> 
> we measured the delay and could find that it was in the range
> of some nano seconds.

Is the SPI controller part of the chipset or comes the interrupt via
one of the GPIOs as well?

Thanks,

	tglx
