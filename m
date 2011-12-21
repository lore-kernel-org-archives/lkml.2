Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab1LUWT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 17:19:28 -0500
Received: from smtpauth03.mfg.siteprotect.com ([64.26.60.137]:45498 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764Ab1LUWTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 17:19:25 -0500
Date: Wed, 21 Dec 2011 17:19:23 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Vince Weaver <vweaver1@eecs.utk.edu>, mingo@elte.hu,
        William Cohen <wcohen@redhat.com>,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/6] perf: x86 RDPMC and RDTSC support
In-Reply-To: <1324503667.17070.7.camel@twins>
Message-ID: <alpine.DEB.2.02.1112211715350.17283@pianoman.cluster.toy>
References: <20111121145114.049265181@chello.nl>   <alpine.DEB.2.00.1112161731570.6060@cl320.eecs.utk.edu>  <1324472337.10752.11.camel@twins>  <alpine.DEB.2.02.1112210959540.10098@pianoman.cluster.toy>  <alpine.DEB.2.02.1112211622560.16411@pianoman.cluster.toy>
 <1324503667.17070.7.camel@twins>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011, Peter Zijlstra wrote:

> On Wed, 2011-12-21 at 16:32 -0500, Vince Weaver wrote:
> 
> > * One, is it possible to detect at runtime that rdpmc() is supported?  
> >   Maybe a field in the mmap'd buffer that can be read?
> 
> Ingo suggested a similar thing, will implement (although Christmas might
> interfere with delivery timelines etc..).

no rush.

> > * Second, if I try a start / run 100M instructions / read
> >   and measure retired instructions I get:
> >       281474977711543 instructions
> >   This is 0x10000000f45b7 which is 1<<48 + 100M.  I guess an artifact
> >   of how the counters are set up?  Is it possible to have this start
> >   at 0?  
> 
> Its supposed to be 0 based, clearly I messed up something and need to go
> figure out what. Thanks for reporting.

That's on a Nehalem machine, if it matters.

Speaking of bit 48, does your implementation do anything useful about
the 32/40/48 bit limitation that some processors have with rdpmc?
Or is the answer that if you might get overflow, then you have to use slow 
syscall-based read?

perfctr has some pretty clever code that manages to use rdpmc() while 
avoiding the overflow issue, but it was written at a time when older 
processors were in use and where this was more of an issue.

Vince
