Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab1DNV4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 17:56:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48051 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab1DNVz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 17:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=e1M7MkgdEZ5fTrCO6ZYVKZTU1KyU0C71WfZ5c4A+m+i+7EN0vBzMmRGM0mfb6KS/wB
         tC4g8owiHHxphuLDPO/g==
Date: Thu, 14 Apr 2011 14:55:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Timur Tabi <timur@freescale.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH 2/3] make new alloc_pages_exact()
In-Reply-To: <20110414200140.CDE09A20@kernel>
Message-ID: <alpine.DEB.2.00.1104141455390.13286@chino.kir.corp.google.com>
References: <20110414200139.ABD98551@kernel> <20110414200140.CDE09A20@kernel>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011, Dave Hansen wrote:

> 
> What I really wanted in the end was a highmem-capable
> alloc_pages_exact(), so here it is.  This function can be used to
> allocate unmapped (like highmem) non-power-of-two-sized areas of
> memory.  This is in constast to get_free_pages_exact() which can only
> allocate from lowmem.
> 
> My plan is to use this in the virtio_balloon driver to allocate large,
> oddly-sized contiguous areas.
> 
> The new __alloc_pages_exact() now takes a size in numbers of pages,
> and returns a 'struct page', which means it can now address
> highmem.  The (new) argument order mirrors alloc_pages() itself.
> 
> It's a bit unfortunate that this introduces __free_pages_exact()
> alongside free_pages_exact().  But that mess already exists with
> __free_pages() vs. free_pages_exact().  So, at worst, this mirrors the
> mess that we already have.
> 
> I'm also a bit worried that I've not put in something named
> alloc_pages_exact(), but that behaves differently than it did before
> this set.  I got all of the in-tree cases, but I'm a bit worried about
> stragglers elsewhere.  So, I'm calling this __alloc_pages_exact() for
> the moment.  We can take out the __ some day if it bothers people.
> 
> Note that the __get_free_pages() has a !GFP_HIGHMEM check.  Now that
> we are using alloc_pages_exact() instead of __get_free_pages() for
> get_free_pages_exact(), we had to add a new check in
> get_free_pages_exact().
> 
> This has been compile and boot tested, and I checked that
> 
> 	echo 2 > /sys/kernel/profiling
> 
> still works, since it uses get_free_pages_exact().
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

Acked-by: David Rientjes <rientjes@google.com>
