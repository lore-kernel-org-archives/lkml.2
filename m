Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab0CaVHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:07:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54472 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab0CaVHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:07:43 -0400
Date: Wed, 31 Mar 2010 22:05:55 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rabin Vincent <rabin@rab.in>,
       lkml <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       penberg@cs.helsinki.fi, cl@linux-foundation.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-arch@vger.kernel.org
Subject: Re: start_kernel(): bug: interrupts were enabled early
Message-ID: <20100331210555.GA17715@flint.arm.linux.org.uk>
Mail-Followup-To: Yinghai Lu <yinghai@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rabin Vincent <rabin@rab.in>, lkml <linux-kernel@vger.kernel.org>,
	hpa@zytor.com, penberg@cs.helsinki.fi, cl@linux-foundation.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linux-arch@vger.kernel.org
References: <20100325194100.GA2364@debian> <20100331134048.da4e35a7.akpm@linux-foundation.org> <4BB3B4DB.7040904@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB3B4DB.7040904@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 01:47:23PM -0700, Yinghai Lu wrote:
> On 03/31/2010 01:40 PM, Andrew Morton wrote:
> > We have two checks in start_kernel():
> > 
> > 	if (!irqs_disabled()) {
> > 		printk(KERN_WARNING "start_kernel(): bug: interrupts were "
> > 				"enabled *very* early, fixing it\n");
> > 		local_irq_disable();
> > 	}
> > 	rcu_init();
> > 	radix_tree_init();
> > 	/* init some links before init_ISA_irqs() */
> > 	early_irq_init();
> > 	init_IRQ();
> > 	prio_tree_init();
> > 	init_timers();
> > 	hrtimers_init();
> > 	softirq_init();
> > 	timekeeping_init();
> > 	time_init();
> > 	profile_init();
> > 	if (!irqs_disabled())
> > 		printk(KERN_CRIT "start_kernel(): bug: interrupts were "
> > 				 "enabled early\n");
> > 
> > perhaps the second one isn't needed?  Perhaps no architecture requires
> > that local interrupts be disabled across the above initialisations?
> 	
> spin_unlock_irq from arm is different from other archs?

We use the standard generic kernel implementation.  Is x86 different? ;)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
