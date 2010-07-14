Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab0GNUW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:22:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28051 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab0GNUWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:22:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=qdFW6VWTa2vCg+qx7LHfEz6xyB2IVznC6b7ZnpuvYt7iQWw/8WtceNiXQKdWLioZd
	DwsjJ6rc/aBbJv7WJ82wA==
Date: Wed, 14 Jul 2010 13:22:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Heinz Diehl <htd@fancy-poultry.org>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [S+Q2 00/19] SLUB with queueing (V2) beats SLAB netperf TCP_RR
In-Reply-To: <alpine.DEB.2.00.1007132055470.14067@router.home>
Message-ID: <alpine.DEB.2.00.1007141316530.26119@chino.kir.corp.google.com>
References: <20100709190706.938177313@quilx.com> <20100710195621.GA13720@fancy-poultry.org> <alpine.DEB.2.00.1007121010420.14328@router.home> <20100712163900.GA8513@fancy-poultry.org> <alpine.DEB.2.00.1007121156160.18621@router.home> <20100713135650.GA6444@fancy-poultry.org>
 <alpine.DEB.2.00.1007132055470.14067@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010, Christoph Lameter wrote:

> > > Can you get us the config file. What is the value of
> > > PERCPU_DYMAMIC_EARLY_SIZE?
> >
> > My .config file is attached. I don't know how to find out what value
> > PERCPU_DYNAMIC_EARLY_SIZE is actually on, how could I do that? There's
> > no such thing in my .config.
> 
> I dont see anything in there at first glance that would cause slub to
> increase its percpu usage. This is straight upstream?
> 

The problem is that he has CONFIG_NODES_SHIFT=10 and struct kmem_cache has 
an array of struct kmem_cache_node pointers with MAX_NUMNODES entries 
which blows its size up to over 8K.  That's probably overkill for his 
quad-core 8GB AMD, so I'd recommend lowering CONFIG_NODES_SHIFT to 6.
