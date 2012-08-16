Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab2HPOMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:12:32 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51484 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667Ab2HPOM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:12:29 -0400
Date: Thu, 16 Aug 2012 15:11:53 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH v2 26/31] arm64: Miscellaneous library functions
Message-ID: <20120816141153.GC30876@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <201208151521.14663.arnd@arndb.de>
 <20120816105709.GK31784@mudshark.cambridge.arm.com>
 <201208161300.32830.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208161300.32830.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 02:00:32PM +0100, Arnd Bergmann wrote:
> On Thursday 16 August 2012, Will Deacon wrote:
> > > > +
> > > > +#include <linux/kernel.h>
> > > > +#include <linux/spinlock.h>
> > > > +#include <linux/atomic.h>
> > > > +
> > > > +#ifdef CONFIG_SMP
> > > > +arch_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned = {
> > > > +       [0 ... (ATOMIC_HASH_SIZE-1)]  = __ARCH_SPIN_LOCK_UNLOCKED
> > > > +};
> > > > +#endif
> > > 
> > > What?
> > > 
> > > I suppose this is a leftover from an earlier version using the
> > > generic bitops, right?
> > 
> > We currently use the generic atomic bitops (asm-generic/bitops/atomic.h)
> > which contains:
> > 
> > #  define ATOMIC_HASH(a) (&(__atomic_hash[ (((unsigned long) a)/L1_CACHE_BYTES) & (ATOMIC_HASH_SIZE-1) ]))
> > 
> > so we have to provide a definition for the array. We have additional patches
> > containing optimised assembly implementations of the atomic bitops which we
> > will push later, once we've got some hardware to benchmark with.
> > 
> 
> Ah, I was confusing this with the asm/atomic.h stuff, for which you already
> provide an optimized version.
> 
> The generic atomic bitops are really horrible in performance and I would
> expect that there is just one obvious way to implement bitops using ldaxr/stlxr,
> so I recommend just doing that even if you have no hardware for benchmarking.

As Will said, we have the code already but I dropped it from the initial
set patches to be reviewed to keep them simpler. They will be added
later.

-- 
Catalin
