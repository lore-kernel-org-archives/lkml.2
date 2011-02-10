Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab1BJSkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:40:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab1BJSkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:40:12 -0500
Date: Thu, 10 Feb 2011 19:39:31 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 5/5] have smaps show transparent huge pages
Message-ID: <20110210183931.GC3347@random.random>
References: <20110209195406.B9F23C9F@kernel>
 <20110209195413.6D3CB37F@kernel>
 <20110210112032.GG17873@csn.ul.ie>
 <1297350115.6737.14208.camel@nimitz>
 <20110210150942.GL17873@csn.ul.ie>
 <20110210180924.GB3347@random.random>
 <1297362032.6737.14622.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297362032.6737.14622.camel@nimitz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 10:20:32AM -0800, Dave Hansen wrote:
> On Thu, 2011-02-10 at 19:09 +0100, Andrea Arcangeli wrote:
> > Maybe it'd be cleaner if we didn't need to cast the pmd to pte_t but I
> > guess this makes things simpler. 
> 
> Yeah, I'm not a huge fan of doing that, either.  But, I'm not sure what
> the alternatives are.  We could basically copy smaps_pte_entry() to
> smaps_pmd_entry(), and then try to make pmd variants of all of the pte
> functions and macros we call in there.

I thought at the smaps_pmd_entry possibility too, but I would expect
it to plain duplicate a bit of code just to avoid a single cast, which
is why I thought the cast was ok in this case.

> I know there's a least a bit of precedent in the hugetlbfs code for
> doing things like this, but it's not a _great_ excuse. :)

;)
