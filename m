Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab1J0XTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 19:19:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57757 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab1J0XTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 19:19:37 -0400
Date: Fri, 28 Oct 2011 08:19:28 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, aarcange@redhat.com,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        mel <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 4/5]thp: correct order in lru list for split huge page
Message-ID: <20111027231928.GB29407@barrios-laptop.redhat.com>
References: <1319511577.22361.140.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319511577.22361.140.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 10:59:37AM +0800, Shaohua Li wrote:
> If a huge page is split, all the subpages should live in lru list adjacently
> because they should be taken as a whole.
> In page split, with current code:
> a. if huge page is in lru list, the order is: page, page+HPAGE_PMD_NR-1,
> page + HPAGE_PMD_NR-2, ..., page + 1(in lru page reclaim order)
> b. otherwise, the order is: page, ..other pages.., page + 1, page + 2, ...(in
> lru page reclaim order). page + 1 ... page + HPAGE_PMD_NR - 1 are in the lru
> reclaim tail.
> 
> In case a, the order is wrong. In case b, page is isolated (to be reclaimed),
> but other tail pages will not soon.
> 
> With below patch:
> in case a, the order is: page, page + 1, ... page + HPAGE_PMD_NR-1(in lru page
> reclaim order).
> in case b, the order is: page + 1, ... page + HPAGE_PMD_NR-1 (in lru page reclaim
> order). The tail pages are in the lru reclaim head.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

In case of a, it doesn't matter ordering of subpages.
As a huge page, age of sub pages are same.

In case of b, what a page is located in tail and other subpages are located in head
isn't critical problem.

Having said that, it's more consistent and simple patch.
So I like that. Nice catch, Shaohua!

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
-- 
Kind regards,
Minchan Kim
