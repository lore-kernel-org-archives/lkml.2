Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab1D0Vhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 17:37:43 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:42020 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582Ab1D0Vhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 17:37:41 -0400
Subject: Re: [PATCH 2/3] make new alloc_pages_exact()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Timur Tabi <timur@freescale.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <4DB88AF0.1050501@freescale.com>
References: <20110414200139.ABD98551@kernel>
	 <20110414200140.CDE09A20@kernel>  <4DB88AF0.1050501@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 27 Apr 2011 14:37:29 -0700
Message-ID: <1303940249.9516.366.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 16:30 -0500, Timur Tabi wrote:
> Dave Hansen wrote:
> > What I really wanted in the end was a highmem-capable
> > alloc_pages_exact(), so here it is.  This function can be used to
> > allocate unmapped (like highmem) non-power-of-two-sized areas of
> > memory.  This is in constast to get_free_pages_exact() which can only
> > allocate from lowmem.
> 
> Is there an easy way to verify that alloc_pages_exact(5MB) really does allocate
> only 5MB and not 8MB?

I'm not sure why you're asking.  How do we know that the _normal_
allocator only gives us 4k when we ask for 4k?  Well, that's just how it
works.  If alloc_pages_exact() returns success, you know it's got the
amount of memory that you asked for, and only that plus a bit of masking
for page alignment.

Have you seen alloc_pages_exact() behaving in some other way?

> Is there some kind of function that returns the amount of
> unallocated memory, so I can do a diff?

Nope.  Even if there was, it would be worthless.  Calls to this might
also cause the system to swap or reclaim memory, so you might end up
with the same amount of free memory before and after the call.  

-- Dave

