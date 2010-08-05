Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979Ab0HEIih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 04:38:37 -0400
Received: from smtp-out.google.com ([74.125.121.35]:47635 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759845Ab0HEIie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 04:38:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=FtDn6JkKuDhJQhO6QepJdgWxUZyvEZ7+hZkmoNTMTrZvBBnc1S2BEqwfx79B4C0PC
	rz4qQnAstE3esVP/iM0ww==
Date: Thu, 5 Aug 2010 01:38:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q3 00/23] SLUB: The Unified slab allocator (V3)
In-Reply-To: <alpine.DEB.2.00.1008041115500.11084@router.home>
Message-ID: <alpine.DEB.2.00.1008050136340.30889@chino.kir.corp.google.com>
References: <20100804024514.139976032@linux.com> <alpine.DEB.2.00.1008032138160.20049@chino.kir.corp.google.com> <alpine.DEB.2.00.1008041115500.11084@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010, Christoph Lameter wrote:

> > This insta-reboots on my netperf benchmarking servers (but works with
> > numa=off), so I'll have to wait until I can hook up a serial before
> > benchmarking this series.
> 
> There are potential issues with
> 
> 1. The size of per cpu reservation on bootup and the new percpu code that
> allows allocations for per cpu areas during bootup. Sometime I wonder if I
> should just go back to static allocs for that.
> 
> 2. The topology information provided by the machine for the cache setup.
> 
> 3. My code of course.
> 

I bisected this to patch 8 but still don't have a bootlog.  I'm assuming 
in the meantime that something is kmallocing DMA memory on this machine 
prior to kmem_cache_init_late() and get_slab() is returning a NULL 
pointer.
