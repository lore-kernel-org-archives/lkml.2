Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab1FOS4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 14:56:52 -0400
Received: from relay2.sgi.com ([192.48.179.30]:35099 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753258Ab1FOS4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 14:56:50 -0400
Date: Wed, 15 Jun 2011 13:58:01 -0500
From: Cliff Wickman <cpw@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1 of 6] x86, UV: smp_processor_id in a preemptable region
Message-ID: <20110615185801.GA2461@sgi.com>
References: <E1QWcgn-0004Mv-T6@eag09.americas.sgi.com> <BANLkTinpqPhTNRtqPGnfZznefESwD19iXA@mail.gmail.com> <20110615135213.GA29493@sgi.com> <20110615155445.GC4096@elte.hu> <20110615160743.GA32008@sgi.com> <20110615161518.GA24948@elte.hu> <20110615164027.GA32641@sgi.com> <4DF8EA26.2000301@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF8EA26.2000301@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 10:21:42AM -0700, H. Peter Anvin wrote:
> On 06/15/2011 09:40 AM, Cliff Wickman wrote:
> > 
> > So would you say I should really widen the scope of the non-preemptible
> > region to include everything done with the results of that call to
> > smp_processor_id()?  
> > Which in this case is the call to parse_tunables_write().
> > Like this:
> > 
> >         preempt_disable();
> >         bcp = &per_cpu(bau_control, smp_processor_id());
> > 
> >         ret = parse_tunables_write(bcp, instr, count);
> >         preempt_enable_no_resched();
> > 
> 
> Funny enough, this is such a common pattern that we have helpers for it.
> We call this get_cpu() ... put_cpu().
> 
> 	-hpa

OK thanks.  I'll use them.


I'll fix that patch (1 of 8) and refresh/resend the whole series after a
little time to allow for more reviews of the others.

-Cliff
-- 
Cliff Wickman
SGI
cpw@sgi.com
(651) 683-3824
