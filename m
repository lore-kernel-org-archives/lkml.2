Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab0F2PUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:20:33 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:60027 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab0F2PUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:20:32 -0400
Date: Tue, 29 Jun 2010 10:19:37 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Minchan Kim <minchan.kim@gmail.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/2] vmscan: shrink_slab() require number of lru_pages,
  not page order
In-Reply-To: <AANLkTimAF9O3kupOWHv2lLuZefDU7HLgq5ApnD-FE_Ng@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1006291017480.16135@router.home>
References: <20100625201915.8067.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006250857040.18900@router.home> <AANLkTimAF9O3kupOWHv2lLuZefDU7HLgq5ApnD-FE_Ng@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jun 2010, Minchan Kim wrote:

> > What does the "lru_pages" parameter do in shrink_slab()? Looks
> > like its only role is as a divison factor in a complex calculation of
> > pages to be scanned.
>
> Yes. But I think it can make others confuse like this.

Right.

> Except zone_reclaim, lru_pages had been used for balancing slab
> reclaim VS page reclaim.
> So lru_page naming is a good.

It is also good to make zone reclaim more deterministic by using the new
counters. So I am not all opposed to the initial patch. Just clear things
up a bit and make sure that this does not cause regressions because of too
frequent calls to shrink_slab

> So you intentionally passed order instead of the number of lru pages
> for shrinking many slabs as possible as.

Dont remember doing that. I suspect the parameter was renamed at some
point.
