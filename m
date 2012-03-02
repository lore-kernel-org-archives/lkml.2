Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965483Ab2CBOga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:36:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965010Ab2CBOga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:36:30 -0500
Date: Fri, 2 Mar 2012 11:33:24 -0300
From: Rafael Aquini <aquini@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] mm: SLAB Out-of-memory diagnostics
Message-ID: <20120302143323.GB1868@t510.redhat.com>
References: <20120229032715.GA23758@t510.redhat.com>
 <alpine.DEB.2.00.1202291724100.17729@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202291724100.17729@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 05:26:07PM -0800, David Rientjes wrote:
> On Wed, 29 Feb 2012, Rafael Aquini wrote:
> 
> > Following the example at mm/slub.c, add out-of-memory diagnostics to the SLAB
> > allocator to help on debugging OOM conditions. This patch also adds a new
> > sysctl, 'oom_dump_slabs_forced', that overrides the effect of __GFP_NOWARN page
> > allocation flag and forces the kernel to report every slab allocation failure.
> > 
> > An example print out looks like this:
> > 
> >   <snip page allocator out-of-memory message>
> >   SLAB: Unable to allocate memory on node 0 (gfp=0x11200)
> >      cache: bio-0, object size: 192, order: 0
> >      node0: slabs: 3/3, objs: 60/60, free: 0
> > 
> > Signed-off-by: Rafael Aquini <aquini@redhat.com>
> 
> I like it, except for the addition of the sysctl.  __GFP_NOWARN is used 
> for a reason, usually because whatever is allocating memory can gracefully 
> handle a failure and should not be emitted to the kernel log under any 
> circumstances.

Ok, I'll drop the sysctl part then. Pekka?

David, once again, thanks for your feedback!

  Rafael
