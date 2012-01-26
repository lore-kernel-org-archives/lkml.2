Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab2AZBaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 20:30:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2AZBah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 20:30:37 -0500
Date: Wed, 25 Jan 2012 17:30:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Adrian Drzewieki <z@drze.net>
Subject: Re: [PATCH v4 -mm] make swapin readahead skip over holes
Message-Id: <20120125173036.ec0d3bac.akpm@linux-foundation.org>
In-Reply-To: <4F20ABDF.8020604@redhat.com>
References: <20120124131351.05309a2a@annuminas.surriel.com>
	<20120124141400.6d33b7c4@annuminas.surriel.com>
	<20120125172319.edbbde73.akpm@linux-foundation.org>
	<4F20ABDF.8020604@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jan 2012 20:26:55 -0500
Rik van Riel <riel@redhat.com> wrote:

> On 01/25/2012 08:23 PM, Andrew Morton wrote:
> 
> > Just to show that I'm paying attention...
> >
> >> --- a/mm/swap_state.c
> >> +++ b/mm/swap_state.c
> >> @@ -382,25 +382,23 @@ struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
> >>   struct page *swapin_readahead(swp_entry_t entry, gfp_t gfp_mask,
> >>   			struct vm_area_struct *vma, unsigned long addr)
> >>   {
> >> -	int nr_pages;
> >>   	struct page *page;
> >> -	unsigned long offset;
> >> -	unsigned long end_offset;
> >> +	unsigned long offset = swp_offset(entry);
> >> +	unsigned long start_offset, end_offset;
> >> +	unsigned long mask = (1<<  page_cluster) - 1;
> >
> > This is broken for page_cluster>  31.  Fix:
> 
> I don't know who would want to do their swapins in chunks
> of 8GB or large at a time,

Linux MM developers ;)

> but still a good catch.
> 
> Want me to send in a v5, or do you prefer to merge a -fix
> patch in your tree?

I already queued the fix, thanks.
