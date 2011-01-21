Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab1AUHXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 02:23:23 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:37971 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab1AUHXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 02:23:22 -0500
Date: Fri, 21 Jan 2011 12:53:15 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [REPOST] [PATCH 3/3] Provide control over unmapped pages (v3)
Message-ID: <20110121072315.GL2897@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110120123039.30481.81151.stgit@localhost6.localdomain6>
 <20110120123649.30481.93286.stgit@localhost6.localdomain6>
 <alpine.DEB.2.00.1101200856310.10695@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101200856310.10695@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter <cl@linux.com> [2011-01-20 09:00:09]:

> On Thu, 20 Jan 2011, Balbir Singh wrote:
> 
> > +	unmapped_page_control
> > +			[KNL] Available if CONFIG_UNMAPPED_PAGECACHE_CONTROL
> > +			is enabled. It controls the amount of unmapped memory
> > +			that is present in the system. This boot option plus
> > +			vm.min_unmapped_ratio (sysctl) provide granular control
> 
> min_unmapped_ratio is there to guarantee that zone reclaim does not
> reclaim all unmapped pages.
> 
> What you want here is a max_unmapped_ratio.
>

I thought about that, the logic for reusing min_unmapped_ratio was to
keep a limit beyond which unmapped page cache shrinking should stop.
I think you are suggesting max_unmapped_ratio as the point at which
shrinking should begin, right?
 
> 
> >  {
> > @@ -2297,6 +2320,12 @@ loop_again:
> >  				shrink_active_list(SWAP_CLUSTER_MAX, zone,
> >  							&sc, priority, 0);
> >
> > +			/*
> > +			 * We do unmapped page reclaim once here and once
> > +			 * below, so that we don't lose out
> > +			 */
> > +			reclaim_unmapped_pages(priority, zone, &sc);
> > +
> >  			if (!zone_watermark_ok_safe(zone, order,
> 
> Hmmmm. Okay that means background reclaim does it. If so then we also want
> zone reclaim to be able to work in the background I think.

Anything specific you had in mind, works for me in testing, but is
there anything specific that stands out in your mind that needs to be
done?

Thanks for the review!
 

-- 
	Three Cheers,
	Balbir
