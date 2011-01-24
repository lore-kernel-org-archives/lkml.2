Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab1AXGh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 01:37:28 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:49828 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab1AXGh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 01:37:27 -0500
Date: Mon, 24 Jan 2011 12:07:10 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [REPOST] [PATCH 3/3] Provide control over unmapped pages (v3)
Message-ID: <20110124063710.GM2897@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110120123039.30481.81151.stgit@localhost6.localdomain6>
 <20110120123649.30481.93286.stgit@localhost6.localdomain6>
 <alpine.DEB.2.00.1101200856310.10695@router.home>
 <20110121072315.GL2897@balbir.in.ibm.com>
 <alpine.DEB.2.00.1101210947270.13881@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101210947270.13881@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter <cl@linux.com> [2011-01-21 09:55:17]:

> On Fri, 21 Jan 2011, Balbir Singh wrote:
> 
> > * Christoph Lameter <cl@linux.com> [2011-01-20 09:00:09]:
> >
> > > On Thu, 20 Jan 2011, Balbir Singh wrote:
> > >
> > > > +	unmapped_page_control
> > > > +			[KNL] Available if CONFIG_UNMAPPED_PAGECACHE_CONTROL
> > > > +			is enabled. It controls the amount of unmapped memory
> > > > +			that is present in the system. This boot option plus
> > > > +			vm.min_unmapped_ratio (sysctl) provide granular control
> > >
> > > min_unmapped_ratio is there to guarantee that zone reclaim does not
> > > reclaim all unmapped pages.
> > >
> > > What you want here is a max_unmapped_ratio.
> > >
> >
> > I thought about that, the logic for reusing min_unmapped_ratio was to
> > keep a limit beyond which unmapped page cache shrinking should stop.
> 
> Right. That is the role of it. Its a minimum to leave. You want a maximum
> size of the pagte cache.

In this case we want the maximum to be as small as the minimum, but
from a general design perspective maximum does make sense.

> 
> > I think you are suggesting max_unmapped_ratio as the point at which
> > shrinking should begin, right?
> 
> The role of min_unmapped_ratio is to never reclaim more pagecache if we
> reach that ratio even if we have to go off node for an allocation.
> 
> AFAICT What you propose is a maximum size of the page cache. If the number
> of page cache pages goes beyond that then you trim the page cache in
> background reclaim.
> 
> > > > +			reclaim_unmapped_pages(priority, zone, &sc);
> > > > +
> > > >  			if (!zone_watermark_ok_safe(zone, order,
> > >
> > > Hmmmm. Okay that means background reclaim does it. If so then we also want
> > > zone reclaim to be able to work in the background I think.
> >
> > Anything specific you had in mind, works for me in testing, but is
> > there anything specific that stands out in your mind that needs to be
> > done?
> 
> Hmmm. So this would also work in a NUMA configuration, right. Limiting the
> sizes of the page cache would avoid zone reclaim through these limit. Page
> cache size would be limited by the max_unmapped_ratio.
> 
> zone_reclaim only would come into play if other allocations make the
> memory on the node so tight that we would have to evict more page
> cache pages in direct reclaim.
> Then zone_reclaim could go down to shrink the page cache size to
> min_unmapped_ratio.
>

I'll repost with max_unmapped_ration changes

Thanks for the review! 

-- 
	Three Cheers,
	Balbir
