Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217Ab0I0Uqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 16:46:50 -0400
Received: from www.tglx.de ([62.245.132.106]:48924 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760161Ab0I0Uqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 16:46:49 -0400
Date: Mon, 27 Sep 2010 22:46:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arthur Kepner <akepner@sgi.com>
cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [RFC/PATCHv2] x86/irq: round-robin distribution of irqs to cpus
 w/in node
In-Reply-To: <20100927203448.GC30050@sgi.com>
Message-ID: <alpine.LFD.2.00.1009272236430.2416@localhost6.localdomain6>
References: <20100927203448.GC30050@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Sep 2010, Arthur Kepner wrote:

> 
> (Fixed a small error with yesterday's version, and add x86@kernel.org 
> to cc list.)
> 
> SGI has encountered situations where particular CPUs run out of
> interrupt vectors on systems with many (several hundred or more)
> CPUs. This happens because some drivers (particularly the mlx4_core
> driver) select the number of interrupts they allocate based on the
> number of CPUs, and because of how the default irq affinity is used.
> 
> Do  psuedo round-robin distribution of irqs to CPUs within a node 
> to avoid (or at least delay) running out of vectors on any particular 
> CPU.

Sigh. Why is this a x86 specific problem ?

If we setup an irq on a node then we should set the affinity to the
target node in general. The round robin inside the node is really not
a problem unless you hit:

   nr_irqs_per_node * nr_cpus_per_node > max_vectors_per_cpu

If that's the case then we probably have some more severe problems.

Again, I agree that we should target the irq to the node, but the fine
grained details can be done in user space.

Thanks,

	tglx
