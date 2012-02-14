Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab2BNV3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:29:24 -0500
Received: from gate.crashing.org ([63.228.1.57]:58571 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932357Ab2BNV3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:29:23 -0500
Message-ID: <1329254900.3772.10.camel@pasglop>
Subject: Re: smp: Start up non-boot CPUs asynchronously
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, mikey@neuling.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, gregkh@linuxfoundation.org,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Milton Miller <miltonm@bga.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, arjanvandeven@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Wed, 15 Feb 2012 08:28:20 +1100
In-Reply-To: <4F3A2DFB.5000209@linux.vnet.ibm.com>
References: <20120130205444.22f5e26a@infradead.org>
	 <20120131125232.GD4408@elte.hu>	<20120131054155.371e8307@infradead.org>
	 <20120131143130.GF13676@elte.hu>	<20120131072216.1ce78e50@infradead.org>
	 <20120131161207.GA18357@elte.hu> <20120131082439.575978c0@infradead.org>
	 <4F3A1891.8060001@linux.vnet.ibm.com> <4F3A2DFB.5000209@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 15:18 +0530, Srivatsa S. Bhat wrote:

> > 2. Just below that we have smp_cpus_done(setup_max_cpus); and this translates
> > to native_smp_cpus_done() under x86, which calls impress_friends().
> > And that means, the bogosum calculation and the total activated processor
> > count which is printed, may get messed up.

We also have code on powerpc that relies on the bringup having been
completed in smp_cpus_done(), especially on platforms that don't support
CPU hotplug (or fake it using sleep loops).

In some case we unmap MMIO space or close access to components (i2c for
example) that we use during the bringup for things like hard synchro of
CPU timebases, etc... on some G5s we disable the elastic interface on
the northbridge for CPUs that weren't brought up, that sort of thing...

So this patch will break a LOT of stuff for us, it must at least be a
config option for now, until we find another way to fix these things.

Cheers,
Ben.


