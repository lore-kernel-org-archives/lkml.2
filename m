Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab0F2PPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:15:34 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:46475 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120Ab0F2PPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:15:33 -0400
Date: Tue, 29 Jun 2010 10:14:35 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/2] vmscan: don't subtraction of unsined 
In-Reply-To: <20100628101802.386A.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006280521190.8725@router.home>
References: <20100625202126.806A.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006250912380.18900@router.home> <20100628101802.386A.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010, KOSAKI Motohiro wrote:

> It's unsigned. negative mean very big value. so
>
> "zone_page_state(zone, NR_SLAB_RECLAIMABLE) > slab_reclaimable - nr_pages)" will
> be evaluated false.

There were some suggestions on how to address this later in the patch.

> ok, your mysterious 'order' parameter (as pointed [1/2]) almostly prevent this case.
> because passing 'order' makes very heavy slab pressure and it avoid negative occur.
>
> but unnaturall coding style can make confusing to reviewers. ya, it's not
> big issue. but I also don't find no fixing reason.

This is not a coding issue but one of logic. The order parameter is
mysterious to me too. So is the lru_pages logic.

> > The comparison could be a problem here. So
> >
> > 			zone_page_state(zone, NR_SLAB_RECLAIMABLE) + nr_pages >
> > 				slab_reclaimable
> >
> > ?
>
> My patch take the same thing. but It avoided two line comparision.
> Do you mean you like this style? (personally, I don't). If so, I'll
> repost this patch.

Yes. I also do not like long cryptic names for local variables.
