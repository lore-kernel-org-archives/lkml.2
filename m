Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab1IGMFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 08:05:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54544 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab1IGMFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 08:05:51 -0400
Date: Wed, 7 Sep 2011 11:46:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frank Rowand <frank.rowand@am.sony.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@tglx.de>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: [ANNOUNCE] 3.0.1-rt11
Message-ID: <20110907104633.GR6619@n2100.arm.linux.org.uk>
References: <1313232790.25267.7.camel@twins> <4E559039.8060209@am.sony.com> <20110826235507.GJ2342@linux.vnet.ibm.com> <4E66DCAB.8090801@am.sony.com> <alpine.LFD.2.02.1109071115410.2723@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1109071115410.2723@ionos>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 11:25:29AM +0200, Thomas Gleixner wrote:
> This smells badly like the problem we've seen on x86 before. And
> looking at the arm SMP boot code:
> 
> asmlinkage void __cpuinit secondary_start_kernel(void)
> {
> 	.....
> 
> 	/*
> 	 * Give the platform a chance to do its own initialisation.
> 	 */
> 	platform_secondary_init(cpu);
> 
> 	/*
> 	 * Enable local interrupts.
> 	 */
> 	notify_cpu_starting(cpu);
> 	local_irq_enable();
> 
> Here we enable interrupts, but the CPU is neither online nor active.
> 
> 	local_fiq_enable();

That's intentional.  Some of the code below needs IRQs enabled.

I think we had this reported before and I got to the bottom of it - the
platform was doing something it shouldn't.  I don't remember the details,
maybe when all the emails come through I can see the original bug report
I'll remember.
