Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068Ab0I0WNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 18:13:12 -0400
Received: from www.tglx.de ([62.245.132.106]:39310 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755048Ab0I0WNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 18:13:10 -0400
Date: Tue, 28 Sep 2010 00:12:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arthur Kepner <akepner@sgi.com>
cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [RFC/PATCHv2] x86/irq: round-robin distribution of irqs to cpus
 w/in node
In-Reply-To: <20100927220113.GD30050@sgi.com>
Message-ID: <alpine.LFD.2.00.1009280003300.2416@localhost6.localdomain6>
References: <20100927203448.GC30050@sgi.com> <alpine.LFD.2.00.1009272236430.2416@localhost6.localdomain6> <20100927220113.GD30050@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Sep 2010, Arthur Kepner wrote:

> On Mon, Sep 27, 2010 at 10:46:02PM +0200, Thomas Gleixner wrote:
> > ...
> > Sigh. Why is this a x86 specific problem ?
> >
> 
> It's obviously not. But we're particularly seeing it on x86 
> systems, so an x86-specific fix would address our problem.

Even more sigh.
  
> > If we setup an irq on a node then we should set the affinity to the
> > target node in general. 
> 
> OK.
> 
> > .... The round robin inside the node is really not
> > a problem unless you hit:
> > 
> >    nr_irqs_per_node * nr_cpus_per_node > max_vectors_per_cpu
> > 
> 
> No, I don't think that's true. 
> 
> The problem we're seeing is that one driver asks for a large 
> number of interrupts (on no CPU in particular). And because of the 

It does it for a node, dammit. Otherwise your patch would be
absolutely useless.

> > > +               if ((node != -1) && alloc_cpumask_var(&tmp_mask, GFP_ATOMIC)) {

> way that the vectors are initially assigned to CPUs (in 
> __assign_irq_vector()), a particular CPU can have all its vectors 
> consumed. 

Stop selling me crap already.

Thanks,

	tglx
