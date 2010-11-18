Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab0KRTuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:50:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754498Ab0KRTux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:50:53 -0500
Date: Thu, 18 Nov 2010 11:49:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Use memory compaction instead of lumpy reclaim
 during high-order allocations
Message-Id: <20101118114928.ecb2d6b0.akpm@linux-foundation.org>
In-Reply-To: <20101118092044.GE8135@csn.ul.ie>
References: <1290010969-26721-1-git-send-email-mel@csn.ul.ie>
	<20101117154641.51fd7ce5.akpm@linux-foundation.org>
	<20101118081254.GB8135@csn.ul.ie>
	<20101118172627.cf25b83a.kamezawa.hiroyu@jp.fujitsu.com>
	<20101118083828.GA24635@cmpxchg.org>
	<20101118092044.GE8135@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 09:20:44 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> > It's because migration depends on MMU.  But we should be able to make
> > a NOMMU version of migration that just does page cache, which is all
> > that is reclaimable on NOMMU anyway.
> > 
> 
> Conceivably, but I see little problem leaving them with lumpy reclaim.

I see a really big problem: we'll need to maintain lumpy reclaim for
ever!

We keep on piling in more and more stuff, we're getting less sure that
the old stuff is still effective.  It's becoming more and more
important to move some of our attention over to simplification, and
to rejustification of earlier decisions.

