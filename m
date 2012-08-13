Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab2HMNtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:49:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59069 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab2HMNtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:49:02 -0400
Date: Mon, 13 Aug 2012 15:49:00 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] hugetlb: do not use vma_hugecache_offset for
 vma_prio_tree_foreach
Message-ID: <20120813134900.GE24248@dhcp22.suse.cz>
References: <20120813130906.GA24248@dhcp22.suse.cz>
 <CAJd=RBCJL+oPRZMNNmtwSWH6CM1fiUNh=X+Leuk25Lyd3uKB5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBCJL+oPRZMNNmtwSWH6CM1fiUNh=X+Leuk25Lyd3uKB5Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 13-08-12 21:24:36, Hillf Danton wrote:
> On Mon, Aug 13, 2012 at 9:09 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > On Mon 13-08-12 20:10:41, Hillf Danton wrote:
> >> On Sun, Aug 12, 2012 at 5:31 PM, Michal Hocko <mhocko@suse.cz> wrote:
> >> > From d07b88a70ee1dbcc96502c48cde878931e7deb38 Mon Sep 17 00:00:00 2001
> >> > From: Michal Hocko <mhocko@suse.cz>
> >> > Date: Fri, 10 Aug 2012 15:03:07 +0200
> >> > Subject: [PATCH] hugetlb: do not use vma_hugecache_offset for
> >> >  vma_prio_tree_foreach
> >> >
> >> > 0c176d5 (mm: hugetlb: fix pgoff computation when unmapping page
> >> > from vma) fixed pgoff calculation but it has replaced it by
> >> > vma_hugecache_offset which is not approapriate for offsets used for
> >> > vma_prio_tree_foreach because that one expects index in page units
> >> > rather than in huge_page_shift.
> >>
> >>
> >> What if another case of vma_prio_tree_foreach in try_to_unmap_file
> >> is correct?
> >
> > That one is surely correct (linear_page_index converts the page offset).
> 
> But linear_page_index is not used in this patch, why?

I will leave it as an excersise for the careful reader...
-- 
Michal Hocko
SUSE Labs
