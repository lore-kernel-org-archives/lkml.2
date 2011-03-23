Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab1CWKil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:38:41 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48347 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab1CWKik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:38:40 -0400
Date: Wed, 23 Mar 2011 10:38:36 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: page allocator: Silence build_all_zonelists()
 section mismatch.
Message-ID: <20110323103836.GC6802@csn.ul.ie>
References: <20110322133045.GA24498@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110322133045.GA24498@linux-sh.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 10:30:45PM +0900, Paul Mundt wrote:
> The memory hotplug case involves calling to build_all_zonelists() which
> in turns calls in to setup_zone_pageset(). The latter is marked
> __meminit while build_all_zonelists() itself has no particular
> annotation. build_all_zonelists() is only handed a non-NULL pointer in
> the case of memory hotplug through an existing __meminit path, so the
> setup_zone_pageset() reference is always safe.
> 
> The options as such are either to flag build_all_zonelists() as __ref (as
> per __build_all_zonelists()), or to simply discard the __meminit
> annotation from setup_zone_pageset().
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 
> ---
> 
> While discarding the __meminit annotation from setup_zone_pageset() is
> probably cleanest I expected some people would take issue with this so
> opted for the more visually offensive __ref route. I can resend for the
> other way if people prefer, or someone else can do it given that it's a
> trivial change.
> 
>  mm/page_alloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Discarding __meminit from setup_zone_pageset() would unnecessarily grow
the kernel image in the !HOTPLUG case and setting __meminit on
build_all_zonelists() looks like it would just cause other section
mistmatch warnings so;

Acked-by: Mel Gorman <mel@csn.ul.ie>
