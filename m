Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308Ab1F1QWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:22:37 -0400
Received: from jaguar.mail.utk.edu ([160.36.0.84]:44624 "EHLO
	jaguar.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759165Ab1F1QVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:21:09 -0400
Date: Tue, 28 Jun 2011 12:20:44 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Andre Przywara <andre.przywara@amd.com>
Subject: Re: [patch] perf_events: even more wrong events for AMD fam10h
In-Reply-To: <1309173741.6701.104.camel@twins>
Message-ID: <alpine.DEB.2.00.1106281215530.3859@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1106071532250.21714@cl320.eecs.utk.edu>  <alpine.DEB.2.00.1106071701560.21714@cl320.eecs.utk.edu> <1309173741.6701.104.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011, Peter Zijlstra wrote:

> On Tue, 2011-06-07 at 17:07 -0400, Vince Weaver wrote:
> > Here are two more problems I found with the superlative "generalized" 
> > events on AMD fam10h.
> > 
> > The "l1-dcache-loads" event measures loads *and* stores.
> >     This might be as close as you can get on AMD, but it's still wrong
> >       as it's not what Intel measures.  
> >     My patch removes it.  Better might be to add a proper
> >     "l1-dcache-access" event.
> 
> The question to ask is, does it still have a strong correlation?

well then shouldn't you call it something like
  "l1-dcache-highly-correlated"
instead?

Having events measure something other than their name is just going to 
confuse users.
 
> > The "l1-dcache-load-miss" event is an invalid event. (0x141).
> >     From what I can tell that event (DATA_CACHE_MISSES) does not
> >     take a mask.  It should be 0x41.  And it's actually measuring
> >     all misses, not just load misses, see above.
> 
> See commit 83112e688f5f05dea1e63787db9a6c16b2887a1d. Also same as above.

that probably warrants a comment in the code.

> > Also, is the value for "no such event" 0 or -1?  The perf_event_amd.c
> > file seems to use them interchangably from what I can tell.
> 
> 	val = hw_cache_event_ids[cache_type][cache_op][cache_result];
> 
> 	if (val == 0)
> 		return -ENOENT;
> 
> 	if (val == -1)
> 		return -EINVAL;

what about architectures where "0" is a valid event?  I know on MIPS 
R12000 "0" means "cycles".

Vince
vweaver1@eecs.utk.edu
