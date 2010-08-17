Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838Ab0HQSyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:54:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:2667 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab0HQSyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:54:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=pJzm+W+tJQUaTn7MjCsQK+w2WvO0yx9oE0M8ob0XvsV9RE1ie1DlUSJcBHivR+8km
	g72y9YVeTBts+aDRR1ChA==
Date: Tue, 17 Aug 2010 11:54:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [S+Q3 00/23] SLUB: The Unified slab allocator (V3)
In-Reply-To: <alpine.DEB.2.00.1008171346530.13665@router.home>
Message-ID: <alpine.DEB.2.00.1008171153490.21770@chino.kir.corp.google.com>
References: <20100804024514.139976032@linux.com> <alpine.DEB.2.00.1008032138160.20049@chino.kir.corp.google.com> <alpine.DEB.2.00.1008041115500.11084@router.home> <alpine.DEB.2.00.1008050136340.30889@chino.kir.corp.google.com> <alpine.DEB.2.00.1008051231400.6787@router.home>
 <alpine.DEB.2.00.1008151627450.27137@chino.kir.corp.google.com> <alpine.DEB.2.00.1008171217440.11915@router.home> <alpine.DEB.2.00.1008171052500.6486@chino.kir.corp.google.com> <alpine.DEB.2.00.1008171346530.13665@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010, Christoph Lameter wrote:

> > I didn't know if that was a debugging patch for me or if you wanted to
> > push that as part of your series, I'm not sure if you actually need to
> > move it to kmem_cache_init() now that slub_state is protected by
> > slub_lock.  I'm not sure if we want to allocate DMA objects between
> > kmem_cache_init() and kmem_cache_init_late().
> 
> Drivers may allocate dma buffers during initialization.
> 

Ok, I moved the DMA cache creation from kmem_cache_init_late() to 
kmem_cache_init().  Note: the kasprintf() will need to use GFP_NOWAIT and 
not GFP_KERNEL now.
