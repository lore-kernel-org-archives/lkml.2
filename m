Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594Ab0IHLXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 07:23:17 -0400
Received: from gir.skynet.ie ([193.1.99.77]:52055 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab0IHLXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 07:23:15 -0400
Date: Wed, 8 Sep 2010 12:23:01 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, fengguang.wu@intel.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        andi.kleen@intel.com, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] [BUGFIX] memory hotplug: fix next block
	calculation in is_removable
Message-ID: <20100908112301.GD29263@csn.ul.ie>
References: <20100906144019.946d3c49.kamezawa.hiroyu@jp.fujitsu.com> <20100907102813.d633b8ef.kamezawa.hiroyu@jp.fujitsu.com> <20100907103244.35eb6b71.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100907103244.35eb6b71.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 10:32:44AM +0900, KAMEZAWA Hiroyuki wrote:
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> next_active_pageblock() is for finding next _used_ freeblock. It skips
> several blocks when it finds there are a chunk of free pages lager than
> pageblock. But it has 2 bugs.
> 
>   1. We have no lock. page_order(page) - pageblock_order can be minus.
>   2. pageblocks_stride += is wrong. it should skip page_order(p) of pages.
> 
> Changelog: 2010/09/07
>  - fix range check of order returned by page_order().
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
