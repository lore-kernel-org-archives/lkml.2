Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0FSHnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 03:43:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54258 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab0FSHnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 03:43:46 -0400
Date: Sat, 19 Jun 2010 09:43:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andres Salomon <dilinger@queued.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
       Mitch Bradley <wmb@laptop.org>
Subject: Re: [PATCH] x86: OLPC: add support for calling into OpenFirmware (v5)
Message-ID: <20100619074335.GB31805@elte.hu>
References: <20100618154245.2e00af2a@dev.queued.net>
 <4C1BCDD5.5040805@zytor.com>
 <20100618195656.GA3821@elte.hu>
 <4C1BD053.3050409@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1BD053.3050409@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 06/18/2010 12:56 PM, Ingo Molnar wrote:
> > 
> > * H. Peter Anvin <hpa@zytor.com> wrote:
> > 
> >> On 06/18/2010 12:42 PM, Andres Salomon wrote:
> >>> +
> >>> +	/* install OFW's PDE permanently into the kernel's pgtable */
> >>> +	set_pgd(&swapper_pg_dir[OLPC_OFW_PDE_NR], *ofw_pde);
> >>> +	flush_tlb();
> >>> +	early_iounmap(base, sizeof(olpc_ofw_pgd) * PTRS_PER_PGD);
> >>
> >> I just realized... this flush_tlb() is actually not necessary since on x86 
> >> it is always legal to go from a less permissive configuration to a more 
> >> permissive, and the initial configuration is "not present" which is 
> >> maximally nonpermissive.
> >>
> >> Could you take it out and make sure it still works?
> > 
> > small nit: an optimization barrier would still be needed if the result is 
> > being relied on by the kernel.
> > 
> 
> In this case the optimization barrier is implicit at the return from an
> out of line function.

Which non-obvious side-effect at minimum deserves a comment. (but yes, i'm 
just nitpicking)

Thanks,

	Ingo
