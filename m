Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab2G0InC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 04:43:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab2G0InA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 04:43:00 -0400
Date: Fri, 27 Jul 2012 09:42:54 +0100
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        Linux-MM <linux-mm@kvack.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Ken Chen <kenchen@google.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH -alternative] mm: hugetlbfs: Close race during teardown
 of hugetlbfs shared page tables V2 (resend)
Message-ID: <20120727084254.GA612@suse.de>
References: <20120720134937.GG9222@suse.de>
 <20120720141108.GH9222@suse.de>
 <20120720143635.GE12434@tiehlicka.suse.cz>
 <20120720145121.GJ9222@suse.de>
 <alpine.LSU.2.00.1207222033030.6810@eggly.anvils>
 <50118182.8030308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <50118182.8030308@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 01:42:26PM -0400, Rik van Riel wrote:
> On 07/23/2012 12:04 AM, Hugh Dickins wrote:
> 
> >Please don't be upset if I say that I don't like either of your patches.
> >Mainly for obvious reasons - I don't like Mel's because anything with
> >trylock retries and nested spinlocks worries me before I can even start
> >to think about it; and I don't like Michal's for the same reason as Mel,
> >that it spreads more change around in common paths than we would like.
> 
> I have a naive question.
> 
> In huge_pmd_share, we protect ourselves by taking
> the mapping->i_mmap_mutex.
> 
> Is there any reason we could not take the i_mmap_mutex
> in the huge_pmd_unshare path?
> 

We do, in 3.4 at least - callers of __unmap_hugepage_range hold the
i_mmap_mutex. Locking changes in mmotm and there is a patch there that
needs to be reverted. What tree are you looking at?

-- 
Mel Gorman
SUSE Labs
