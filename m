Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab0IPJDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 05:03:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41326 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab0IPJDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 05:03:01 -0400
Date: Thu, 16 Sep 2010 10:02:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (tip
	tree related)
Message-ID: <20100916090214.GA20197@n2100.arm.linux.org.uk>
References: <20100914002932.850d02f3.sfr@canb.auug.org.au> <20100916163218.e09be473.sfr@canb.auug.org.au> <20100916063922.GA17596@elte.hu> <20100916070835.GB19994@n2100.arm.linux.org.uk> <20100916073433.GA21228@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916073433.GA21228@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 09:34:33AM +0200, Ingo Molnar wrote:
> 
> * Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > On Thu, Sep 16, 2010 at 08:39:22AM +0200, Ingo Molnar wrote:
> > > 
> > > * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > 
> > > > Hi all,
> > > > 
> > > > On Tue, 14 Sep 2010 00:29:32 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > > >
> > > > > After merging the final tree, today's linux-next build (arm
> > > > > assabet_defconfig and serveral other arm configs) failed like this:
> > > > > 
> > > > > arch/arm/mm/init.c: In function 'arm_memory_present':
> > > > > arch/arm/mm/init.c:260: warning: ISO C90 forbids mixed declarations and code
> > > > > arch/arm/mm/init.c:338: error: invalid storage class for function 'free_area'
> > > > > arch/arm/mm/init.c:357: error: invalid storage class for function 'free_memmap'
> > > > > arch/arm/mm/init.c:386: error: invalid storage class for function 'free_unused_memmap'
> > > > > arch/arm/mm/init.c:601: error: invalid storage class for function 'keepinitrd_setup'
> > > > > arch/arm/mm/init.c:606: error: initializer element is not constant
> > > > > arch/arm/mm/init.c:606: error: (near initialization for '__setup_keepinitrd_setup.setup_func')
> > > > > arch/arm/mm/init.c:606: error: expected declaration or statement at end of input
> > > > > arch/arm/mm/init.c:252: warning: unused variable 'i'
> > > > > 
> > > > > Caused by commit 719c1514f2fef5f01fcfa2bba81b7bb079c7c6a1 ("memblock/arm:
> > > > > Use new accessors") which forgot a closing brace on a new
> > > > > for_each_memblock() in arm_memory_present().
> > > > 
> > > > So this commit is back in tip and the error is back in the builds ...
> > > 
> > > The ARM defconfig build doesnt fail here:
> > > 
> > >   WARNING: modpost: Found 5 section mismatch(es).
> > >   To see full details build your kernel with:
> > >   'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> > 
> > It probably passes because that configuration doesn't result in the
> > failing code being built (maybe the failing code is only used for
> > sparsemem ?)
> 
> Yeah. If sparsemem is important then it would be helpful if you could 
> enable it in the ARM defconfig if possible - that's what most people 
> build.

But then so is flatmem too - and it's the same story for lots of other
combinations.  If we had sparsemem enabled then a similar bug could
have crept into the !SPARSEMEM code just a few lines above.

There's no correct answer here - the only answer is technologies such
as linux-next and kautobuild to build a range of configs to get the
build coverage.
