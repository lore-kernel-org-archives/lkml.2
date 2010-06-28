Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab0F1BcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 21:32:15 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47239 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab0F1BcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 21:32:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 1/2] vmscan: shrink_slab() require number of lru_pages, not page order
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <alpine.DEB.2.00.1006250857040.18900@router.home>
References: <20100625201915.8067.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006250857040.18900@router.home>
Message-Id: <20100628102342.386D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 28 Jun 2010 10:32:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 25 Jun 2010, KOSAKI Motohiro wrote:
> 
> > Fix simple argument error. Usually 'order' is very small value than
> > lru_pages. then it can makes unnecessary icache dropping.
> 
> This is going to reduce the delta that is added to shrinker->nr
> significantly thereby increasing the number of times that shrink_slab() is
> called.

Yup. But,

Smaller shrink -> only makes retry
Bigger shrink  -> makes unnecessary icache/dcache drop. it can bring
                  mysterious low performance.


> What does the "lru_pages" parameter do in shrink_slab()? Looks
> like its only role is as a divison factor in a complex calculation of
> pages to be scanned.

Yes.
scanned/lru_pages ratio define basic shrink_slab puressure strength.

So, If you intentionally need bigger slab pressure, bigger scanned parameter
passing is better rather than mysterious 'order' parameter.

> 
> do_try_to_free_pages passes 0 as "lru_pages" to shrink_slab() when trying
> to do cgroup lru scans. Why is that?

?
When cgroup lru scans, do_try_to_free_pages() don't call shrink_slab().


