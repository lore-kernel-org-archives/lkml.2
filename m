Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1CZT5n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 15:57:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48417 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745Ab1CZT5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 15:57:42 -0400
Date: Sat, 26 Mar 2011 20:57:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, npiggin@kernel.dk,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] slub: Disable the lockless allocator
Message-ID: <20110326195722.GA7748@elte.hu>
References: <20110324185258.GA28370@elte.hu>
 <alpine.LFD.2.00.1103242005530.31464@localhost6.localdomain6>
 <20110324192247.GA5477@elte.hu>
 <AANLkTinBwM9egao496WnaNLAPUxhMyJmkusmxt+ARtnV@mail.gmail.com>
 <20110326112725.GA28612@elte.hu>
 <20110326114736.GA8251@elte.hu>
 <1301161507.2979.105.camel@edumazet-laptop>
 <alpine.DEB.2.00.1103261406420.24195@router.home>
 <alpine.DEB.2.00.1103261428200.25375@router.home>
 <alpine.DEB.2.00.1103261440160.25375@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103261440160.25375@router.home>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Sat, 26 Mar 2011, Christoph Lameter wrote:
> 
> > Tejun: Whats going on there? I should be getting offsets into the per cpu
> > area and not kernel addresses.
> 
> Its a UP kernel running on dual Athlon. So its okay ... Argh.... The
> following patch fixes it by using the fallback code for cmpxchg_double:
> 
> 
> 
> Subject: per_cpu: Fixup cmpxchg_double for !SMP
> 
> cmpxchg_double should only be provided for SMP. In the UP case
> the GS register is not defined and the function will fail.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

I.e. the bug got introduced by:

 | commit b9ec40af0e18fb7d02106be148036c2ea490fdf9
 | Author: Christoph Lameter <cl@linux.com>
 | Date:   Mon Feb 28 11:02:24 2011 +0100
 |
 |     percpu, x86: Add arch-specific this_cpu_cmpxchg_double() support

and then the lockless allocator made use of it, right?

Thanks,

	Ingo
