Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab1LHVGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 16:06:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64076 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab1LHVGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 16:06:07 -0500
Date: Thu, 8 Dec 2011 13:06:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH v3 3/3] slub: min order when debug_guardpage_minorder >
 0
In-Reply-To: <20111208073316.GA2402@redhat.com>
Message-ID: <alpine.DEB.2.00.1112081303100.8127@chino.kir.corp.google.com>
References: <1321633507-13614-1-git-send-email-sgruszka@redhat.com> <1321633507-13614-3-git-send-email-sgruszka@redhat.com> <alpine.DEB.2.00.1112071407090.27360@chino.kir.corp.google.com> <20111208073316.GA2402@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Dec 2011, Stanislaw Gruszka wrote:

> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index 7d2a996..a66be56 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -3645,6 +3645,9 @@ void __init kmem_cache_init(void)
> > >  	struct kmem_cache *temp_kmem_cache_node;
> > >  	unsigned long kmalloc_size;
> > >  
> > > +	if (debug_guardpage_minorder())
> > > +		slub_max_order = 0;
> > > +
> > >  	kmem_size = offsetof(struct kmem_cache, node) +
> > >  				nr_node_ids * sizeof(struct kmem_cache_node *);
> > > 
> > 
> > I'd recommend at least printing a warning about why slub_max_order was 
> > reduced because users may be concerned why they can't now change any 
> > cache's order with /sys/kernel/slab/cache/order.
> 
> It's only happen with debug_guardpage_minorder=N parameter, so
> perhaps I'll just document that in kernel-parameters.txt
> 

SLUB will output a line in the dmesg that specifies the possible orders so 
it would be helpful to also note that those can change because of 
debug_guardpage_minorder in both Documentation/vm/slub.txt and the "order" 
file entry in Documentation/ABI/testing/sysfs-kernel-slab.

Thanks!
