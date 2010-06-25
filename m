Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab0FYOIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 10:08:34 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:50900 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab0FYOIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 10:08:32 -0400
Date: Fri, 25 Jun 2010 09:07:39 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/2] vmscan: shrink_slab() require number of lru_pages,
 not page order
In-Reply-To: <20100625201915.8067.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006250857040.18900@router.home>
References: <20100625201915.8067.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jun 2010, KOSAKI Motohiro wrote:

> Fix simple argument error. Usually 'order' is very small value than
> lru_pages. then it can makes unnecessary icache dropping.

This is going to reduce the delta that is added to shrinker->nr
significantly thereby increasing the number of times that shrink_slab() is
called.

What does the "lru_pages" parameter do in shrink_slab()? Looks
like its only role is as a divison factor in a complex calculation of
pages to be scanned.

do_try_to_free_pages passes 0 as "lru_pages" to shrink_slab() when trying
to do cgroup lru scans. Why is that?


