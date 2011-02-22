Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab1BVOjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:39:16 -0500
Received: from www.tglx.de ([62.245.132.106]:38380 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab1BVOjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:39:13 -0500
Date: Tue, 22 Feb 2011 15:39:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Schaefer Dr, Frank-Rene ()" <fschaef9@visteon.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Interrupt Latencies
In-Reply-To: <060E4307CE6CA14BB4F7B4A25ECA052904B73AD1@VEUMBV03.vistcorp.ad.visteon.com>
Message-ID: <alpine.LFD.2.00.1102221527180.2701@localhost6.localdomain6>
References: <060E4307CE6CA14BB4F7B4A25ECA052904B73AD1@VEUMBV03.vistcorp.ad.visteon.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011, Schaefer Dr, Frank-Rene () wrote:
> Having read "Moving interrupts to threads" at
> 
>            http://lwn.net/Articles/302043/
> 
> I expected to reduce interrupt latency during a SPI 
> communication by handling the transmit-receive in a 
> 'quick_check_handler' using 
> 
>            request_threaded_irq(...);

The quick check handler has the same latencies as the normal handler
of an interrupt requested by request_irq.
 
Interrupt latency depends on various factors:

  - Interrupt disabled code regions
  - Concurrent interrupts and the ordering of handling
  - Deep idle states
  - Bus contention
  - Cache misses

The maximum latency is the worst case of all the above added together.

> or vice versa. We are able to measure the latency precisely
> as the difference of the time when the interrupt pin 'IN'
> is raised and we raise our response pin 'OUT' as shown below.
> 
>       pin IN        .-------------------------
>       ______________|
>                     
>       pin OUT                     .-----------
>       ____________________________|
>                           
>                     |<- latency ->|
> 
> Could anyone point to locations in the kernel so that I can
> precisely understand the mechanisms that cause the latency? It 

There is no single mechanism.

> is totally incomprehensible to me why the 'quick_check_handler' 
> must have a latency of 60us at min. (that are many thousand 
> instructions).

How is that interrupt connected to the CPU/chipset? Which driver(s)
is/are involved ? How is the pin OUT accessed from the driver?

Thanks,

	tglx
