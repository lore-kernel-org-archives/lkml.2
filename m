Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab0EXLbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 07:31:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46323 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831Ab0EXLbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 07:31:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RqbvD+s6+ITPp7dS2r9Gy03QOWT+obXSqgVwEkxy5+B/zm1vfdAQ3Be/UsfccwI6JT
         xzR50kA21Mf1X2IQr5U2y4vaAzSQ18BMaGNOklshqOxRYOV+apKdEzlZMYPdoBQPsFUT
         Vd6WZAFdLXP2SChiPsHDWWSfLsue+DVpKF06o=
Date: Mon, 24 May 2010 13:31:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] perf, trace: Remove IRQ-disable from
	perf/tracepoint interaction
Message-ID: <20100524113104.GA5325@nowhere>
References: <20100521090201.326791353@chello.nl> <20100521090710.419716197@chello.nl> <20100523121159.GB3194@brick.ozlabs.ibm.com> <1274638587.1674.1729.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274638587.1674.1729.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 23, 2010 at 08:16:27PM +0200, Peter Zijlstra wrote:
> On Sun, 2010-05-23 at 22:11 +1000, Paul Mackerras wrote:
> > On Fri, May 21, 2010 at 11:02:02AM +0200, Peter Zijlstra wrote:
> > 
> > >  	entry = (struct trace_entry *)raw_data;
> > > -	tracing_generic_entry_update(entry, *irq_flags, pc);
> > > +	tracing_generic_entry_update(entry, regs->flags, pc);
> > >  	entry->type = type;
> > 
> > This is breaking on powerpc -- we don't have a "flags" element in
> > struct pt_regs.  What is it trying to do?  Get the interrupt enable
> > state, as local_irq_save(flags) would provide?
> 
> Yes, I fouled that up.
> 
> On x86 perf_arch_fetch_caller_regs() stores pt_regs::flags, which is the
> same as used in local_save_flags().
> 
> So to avoid another local_save_flags() for the ftrace code, I wanted to
> reuse it, and totally forgot the !x86 side of things.
> 
> Possibly we could remove the local_save_flags() from the
> perf_arch_fetch_caller_regs() as I'm not sure we actually use
> pt_regs::flags (Frederic?) and leave the ftrace thing to use
> local_save_flags().


It was an anticipation for further uses. But since further are not
appearing, you can safely remove it.


Thanks.

