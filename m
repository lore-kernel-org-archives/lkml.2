Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985Ab0ENWgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 18:36:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:50858 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757293Ab0ENWgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 18:36:12 -0400
Subject: Re: [PATCH 11/35] lmb: Add find_memory_core_early()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BED7DFE.2090108@oracle.com>
References: <1273804238.21352.389.camel@pasglop>
	 <4BECF00D.6080800@oracle.com>	<1273825187.21352.590.camel@pasglop>
	 <20100514.013012.13730149.davem@davemloft.net>
	 <4BED7DFE.2090108@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 May 2010 08:34:48 +1000
Message-ID: <1273876488.21352.643.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 09:44 -0700, Yinghai Lu wrote:
> On 05/14/2010 01:30 AM, David Miller wrote:
> > From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Date: Fri, 14 May 2010 18:19:47 +1000
> >
> >   
> >> OK, I'll have to let Davem deal with the fine point of the sparc bits,
> >> but I think basically sparc has CONFIG_ARCH_POPULATES_NODE_MAP set, but
> >> the way it's NUMA affinity works, the early_node_map[] is crap, you
> >> cannot rely on the ranges in there.
> >>     
> >   
> 
> > Right, we can't use early_node_map[] on sparc, because the NUMA
> > mappings are far too granular to use that kind of representation.
> >   
> good to know.
> 
> early_node_map[] doesn't have enough slot?

I think that's the case. sparc doesn't override MAX_ACTIVE_REGIONS,
which means you get the default which is 256 or 50 per node depending
on MAX_NUMNODES. My understanding is that this may not be enough.

Dave, what does it look like in practice tho ?

Cheers,
Ben.


