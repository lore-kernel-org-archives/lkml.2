Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446Ab2EXRPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:15:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36617 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266Ab2EXRPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:15:33 -0400
Date: Thu, 24 May 2012 18:15:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: linux-kernel@vger.kernel.org, Russ.Dill@ti.com, mporter@ti.com,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [ARM] Unconditional call to smp_cross_call on UP
	crashes
Message-ID: <20120524171524.GG6908@n2100.arm.linux.org.uk>
References: <1337889024-10416-1-git-send-email-panto@antoniou-consulting.com> <20120524161733.GF6908@n2100.arm.linux.org.uk> <F138E222-D587-4264-8B80-E041D44BF770@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F138E222-D587-4264-8B80-E041D44BF770@antoniou-consulting.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 07:55:56PM +0300, Pantelis Antoniou wrote:
> Hi Russell,
> 
> On May 24, 2012, at 7:17 PM, Russell King - ARM Linux wrote:
> 
> > On Thu, May 24, 2012 at 07:50:24PM +0000, Pantelis Antoniou wrote:
> >> omap2plus_defconfig builds with SMP & SMP_ON_UP set.
> >> On beagle (which is UP) is_smp() returns false and we don't call
> >> smp_init_cpus which in turn does not initialize smp_cross_call which
> >> remains NULL.
> >> 
> >> When issuing a reboot we OOPS with a NULL dereference on stop smp_call.
> > 
> > I've been wondering whether we should make smp_cross_call() a no-op instead
> > by default, rather than a NULL pointer.
> > 
> > Alternatively, if may be well worth changing this to do:
> > 
> > 	if (!cpumask_empty(&mask))
> > 		smp_cross_call(&mask, IPI_CPU_STOP);
> > 
> > instead, so we avoid calling smp_cross_call() when we're on a SMP system
> > with only one CPU online.  I like this approach better because it removes
> > a potential call into platform code which is inappropriate.
> 
> Both of these can work, and in fact have been tried.
> 
> I am partial on both to be honest. Have a default no-op function for smp_cross_call()
> and guard with cpumask_empty().
> 
> Which do you want me to make a patch for?

I think the cpumask_empty() is the best approach, thanks.
