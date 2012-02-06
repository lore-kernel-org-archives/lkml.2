Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab2BFQrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:47:06 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:57731 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab2BFQrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:47:04 -0500
Date: Mon, 6 Feb 2012 17:46:26 +0100
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, mingo@elte.hu, robert.richter@amd.com,
        eric.dumazet@gmail.com, Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [BUG] perf: perf sched warning possibly due to clock granularity
 on AMD
Message-ID: <20120206164626.GA31704@aftab>
References: <20120206132546.GA30854@quad>
 <1328538403.2482.4.camel@laptop>
 <20120206153408.GA31237@aftab>
 <1328546246.2482.10.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328546246.2482.10.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 05:37:26PM +0100, Peter Zijlstra wrote:
> On Mon, 2012-02-06 at 16:34 +0100, Borislav Petkov wrote:
> > + Andreas.
> > 
> > On Mon, Feb 06, 2012 at 03:26:43PM +0100, Peter Zijlstra wrote:
> > > On Mon, 2012-02-06 at 14:25 +0100, Stephane Eranian wrote:
> > > > In summary, two issues:
> > > >   - Why is sched_clock_stable not set or even tested on recent AMD systems?
> > 
> > AFAICT, sched_clock_stable is set on Intel under the following conditions:
> > 
> >         /*
> >          * c->x86_power is 8000_0007 edx. Bit 8 is TSC runs at constant rate
> >          * with P/T states and does not stop in deep C-states.
> >          *
> >          * It is also reliable across cores and sockets. (but not across
> >          * cabinets - we turn it off in that case explicitly.)
> >          */
> >         if (c->x86_power & (1 << 8)) {
> >                 set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
> >                 set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
> >                 if (!check_tsc_unstable())
> >                         sched_clock_stable = 1;
> >         }
> > 
> > and yes, we can do CONSTANT_TSC and NONSTOP_TSC on the now older F10h
> > already, so Bulldozer can do that too, implicitly.
> > 
> > I don't see why sched_clock_stable shouldn't be moved to generic x86
> > code and set based on the two CPUID cap flags above.
> 
> stable means more than both those flags together.. 
> 
>  - CONSTANT_TSC means freq independent
>  - NONSTOP_TSC means it doesn't get stopped in any C state
> 
> Together they make TSC completely C-state independent.
> sched_clock_stable actually means that TSC is both _AND_ is consistent

yes.

> across all CPUs in the entire system.

Right, by the "entire system" you mean consistent across cores and
sockets but not necessarily across cabinets, as in the comment above,
correct?

If so, let me ask around if this holds true too.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
