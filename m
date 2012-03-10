Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410Ab2CJDT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 22:19:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab2CJDTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 22:19:52 -0500
Date: Sat, 10 Mar 2012 00:16:48 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Josef Bacik <josef@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v3] mm: SLAB Out-of-memory diagnostics
Message-ID: <20120310031647.GA2988@t510.redhat.com>
References: <20120309202722.GA10323@x61.redhat.com>
 <1331339019.4063.365.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331339019.4063.365.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howdy Eric,

On Fri, Mar 09, 2012 at 04:23:39PM -0800, Eric Dumazet wrote:
> On Fri, 2012-03-09 at 17:27 -0300, Rafael Aquini wrote:
> > Following the example at mm/slub.c, add out-of-memory diagnostics to the
> > SLAB allocator to help on debugging certain OOM conditions.
> > 
> > An example print out looks like this:
> > 
> >   <snip page allocator out-of-memory message>
> >   SLAB: Unable to allocate memory on node 0 (gfp=0x11200)
> >     cache: bio-0, object size: 192, order: 0
> >     node 0: slabs: 3/3, objs: 60/60, free: 0
> 
> Should probably be :
> 
>    node: 0 slabs: 3/3, objs: 60/60, free: 0
>
 
No it shouldn't. Please refer to https://lkml.org/lkml/2012/3/7/242

The intent here was just to match slub's printout for its slab_out_of_memory 
node list slab components, as one can check on mm/slub.c:

2096                 printk(KERN_WARNING
2097                         "  node %d: slabs: %ld, objs: %ld, free: %ld\n",
2098                         node, nr_slabs, nr_objs, nr_free);


> > +		printk(KERN_WARNING
> > +			"  node %d: slabs: %ld/%ld, objs: %ld/%ld, free: %ld\n",
> 
> Probably should be :
> 		"  node: %d slabs: %ld/%ld, objs: %ld/%ld, free: %ld\n",
>

ditto.


Thanks for your feedback!

	Rafael
