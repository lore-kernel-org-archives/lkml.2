Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab1BJPKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 10:10:10 -0500
Received: from gir.skynet.ie ([193.1.99.77]:56023 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab1BJPKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 10:10:09 -0500
Date: Thu, 10 Feb 2011 15:09:42 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 5/5] have smaps show transparent huge pages
Message-ID: <20110210150942.GL17873@csn.ul.ie>
References: <20110209195406.B9F23C9F@kernel> <20110209195413.6D3CB37F@kernel> <20110210112032.GG17873@csn.ul.ie> <1297350115.6737.14208.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1297350115.6737.14208.camel@nimitz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 07:01:55AM -0800, Dave Hansen wrote:
> On Thu, 2011-02-10 at 11:20 +0000, Mel Gorman wrote:
> > > @@ -394,6 +395,7 @@ static int smaps_pte_range(pmd_t *pmd, u
> > >                       spin_lock(&walk->mm->page_table_lock);
> > >               } else {
> > >                       smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_SIZE, walk);
> > > +                     mss->anonymous_thp += HPAGE_SIZE;
> > 
> > I should have thought of this for the previous patch but should this be
> > HPAGE_PMD_SIZE instead of HPAGE_SIZE? Right now, they are the same value
> > but they are not the same thing.
> 
> Probably.  There's also a nice BUG() in HPAGE_PMD_SIZE if the THP config
> option is off, which is an added bonus.
> 

Unless Andrea has an objection, I'd prefer to see HPAGE_PMD_SIZE.
Assuming that's ok;

Acked-by: Mel Gorman <mel@csn.ul.ie>

for the whole series.

Thanks Dave.

-- 
Mel Gorman
SUSE Labs
