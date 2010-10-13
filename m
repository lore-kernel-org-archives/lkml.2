Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab0JMUtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 16:49:01 -0400
Received: from smtp-out.google.com ([74.125.121.35]:7100 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab0JMUs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 16:48:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=DuqMXjMSk3Wbk2w5kUv/YvUjm0v3fkcD/DZsuguNO5SId9Q+SgzECKC7O86Cg66lOo
         /2N0NmHgNE6hDFUnEurA==
Date: Wed, 13 Oct 2010 13:48:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        Eilon Greenstein <eilong@broadcom.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH net-next] net:  allocate skbs on local node
In-Reply-To: <alpine.DEB.2.00.1010131056180.29099@router.home>
Message-ID: <alpine.DEB.2.00.1010131342310.15185@chino.kir.corp.google.com>
References: <1286838210.30423.128.camel@edumazet-laptop> <1286839363.30423.130.camel@edumazet-laptop> <1286859925.30423.184.camel@edumazet-laptop> <20101011230322.f0f6dd47.akpm@linux-foundation.org> <1286866699.30423.234.camel@edumazet-laptop>
 <20101012002435.f51f2c0e.akpm@linux-foundation.org> <1286869793.2732.24.camel@edumazet-laptop> <20101012005856.994bea6d.akpm@linux-foundation.org> <4CB441CB.2000708@cs.helsinki.fi> <alpine.DEB.2.00.1010120745360.31832@router.home>
 <alpine.DEB.2.00.1010121234380.10165@chino.kir.corp.google.com> <alpine.DEB.2.00.1010131056180.29099@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010, Christoph Lameter wrote:

> > Will you be adding the extensive slub debugging to slab then?  It would be
> > a shame to lose it because one allocator is chosen over another for
> > performance reasons and then we need to recompile to debug issues as they
> > arise.
> 
> Well basically we would copy SLUB to SLAB apply unification patches to
> SLAB instead of SLUBB. We first have to make sure that the unified patches
> have the same performance as SLAB.
> 

I see, so all of the development will be done in Pekka's tree on mm/slub.c 
and then when we can see no performance regression compared to the slab 
baseline, merge it into Linus' tree as mm/slab.c.  I'm not exactly sure 
how that set of diffs being sent to Linus would look.

Are the changes to slub in the unification patchset so intrusive that it 
wouldn't be possible to isolate many of the features under #ifdef or 
boot-time options in a single, truly unified, allocator?  It seems like a 
shame that we'll have two allocators where the base is the same and much 
of the debugging code is the same.

> It maybe much better to isolate the debug features and general bootstrap
> from the particulars of the allocation strategy of either SLUB or SLAB.
> That way a common code base exists and it would be easier to add different
> allocation strategies.
> 
> Basically have slab.c with the basic functions and then slab_queueing.c
> and slab_noqueue.c for SLAB/SLUB with the particulars of the allocation
> strategy?
> 

I was going to mention that as an idea, but I thought storing the metadata 
for certain debugging features might differ from the two allocators so 
substantially that it would be even more convoluted and difficult to 
maintain?
