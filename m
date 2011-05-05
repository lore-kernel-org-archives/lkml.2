Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364Ab1EEGjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 02:39:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:35822 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab1EEGjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 02:39:06 -0400
Date: Thu, 5 May 2011 08:38:54 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, rientjes@google.com,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH] Allocate memory cgroup structures in local nodes v2
Message-ID: <20110505063854.GB11529@tiehlicka.suse.cz>
References: <1304540783-8247-1-git-send-email-andi@firstfloor.org>
 <20110504213850.GA16685@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504213850.GA16685@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 04-05-11 23:38:50, Johannes Weiner wrote:
> On Wed, May 04, 2011 at 01:26:23PM -0700, Andi Kleen wrote:
> > diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> > index 9905501..a362215 100644
> > --- a/mm/page_cgroup.c
> > +++ b/mm/page_cgroup.c
> > @@ -134,7 +134,7 @@ static void *__init_refok alloc_page_cgroup(size_t size, int nid)
> >  {
> >  	void *addr = NULL;
> >  
> > -	addr = alloc_pages_exact(size, GFP_KERNEL | __GFP_NOWARN);
> > +	addr = alloc_pages_exact_node(nid, GFP_KERNEL | __GFP_NOWARN, size);
> 
> alloc_pages_exact_node is not the 'specify node as well'-version of
> alloc_pages_exact, it refers to 'exact node'.  Thus the
> free_pages_exact call is no longer the right counter-part.
> 
> alloc_pages_exact_node takes an order, not a size argument.
> 
> alloc_pages_exact_node returns a pointer to the struct page, not to
> the allocated memory, like all other alloc_pages* functions with the
> exception of alloc_pages_exact.
> 
> I don't think any of those mistakes even triggers a compiler warning.
> Wow.  This API is so thoroughly fscked beyond belief that I think the
> only way to top this is to have one of the functions invert the bits
> of its return value depending on the parity of the uptime counter.

I think Dave Hansen is doing a cleanup in that area
(https://lkml.org/lkml/2011/4/11/337).

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
