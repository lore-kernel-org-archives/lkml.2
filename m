Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab1DGWRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:17:51 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54987 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab1DGWRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:17:50 -0400
Subject: Re: [PATCH 2/2] make new alloc_pages_exact()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Timur Tabi <timur@freescale.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1104071452070.14967@chino.kir.corp.google.com>
References: <20110407172104.1F8B7329@kernel>
	 <20110407172105.831B9A0A@kernel>
	 <alpine.DEB.2.00.1104071452070.14967@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 07 Apr 2011 15:17:43 -0700
Message-ID: <1302214663.8184.4164.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 15:03 -0700, David Rientjes wrote:
> On Thu, 7 Apr 2011, Dave Hansen wrote:
> > What I really wanted in the end was a highmem-capable alloc_pages_exact(),
> > so here it is.
> 
> Perhaps expand upon how the new alloc_pages_exact() works and what it will 
> be used for instead of only talking about how it's named?

Will do.

> > +/* 'struct page' version */
> > +struct page *__alloc_pages_exact(gfp_t, size_t);
> > +void __free_pages_exact(struct page *, size_t);
> 
> They're not required, but these should have the names of the arguments 
> like the other prototypes in this file.

Fair enough.

> > -	addr = __get_free_pages(gfp_mask, order);
> > -	if (addr) {
> > -		unsigned long alloc_end = addr + (PAGE_SIZE << order);
> > -		unsigned long used = addr + PAGE_ALIGN(size);
> > +	page = alloc_pages(gfp_mask, order);
> > +	if (page) {
> > +		struct page *alloc_end = page + (1 << order);
> > +		struct page *used = page + PAGE_ALIGN(size)/PAGE_SIZE;
> 
> Wouldn't it better to call this "unused" rather than "used" since it 
> represents a cursor over pages that we want to free?

Yeah, agreed.  I think I screwed this up once when coding this because I
misread it.  I'll change it.

-- Dave

