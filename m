Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab0IIOdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 10:33:00 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:37672 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753423Ab0IIOc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 10:32:59 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: NAhE4QQVM1lMwbHu1Hv9g22Z4F8Ff2T30RCL_Nk4mznKa4x
 BvCY3ArEVU1S9AZDVXhgq0Py0CfP.Dc19mCeCbEpuipapjC91pMnlDUp1a04
 W8wi3WP06KtzKZV1be91LSlDDNrPLDKBaEtRTl4d3QlqZ.PnwutbWEO..jP4
 ce5bueu5J8A860Mq8txIJROPnCOjs.yGCVykb63j6AliDeRvoA158vqoyZWY
 PsXfSb6hmi.WlCFbzvxFYi0Y27Dmn
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 9 Sep 2010 09:32:52 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 3/3] mm: page allocator: Drain per-cpu lists after direct
 reclaim allocation fails
In-Reply-To: <20100909135523.GA340@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1009090931360.18975@router.home>
References: <1283504926-2120-1-git-send-email-mel@csn.ul.ie> <1283504926-2120-4-git-send-email-mel@csn.ul.ie> <20100908163956.C930.A69D9226@jp.fujitsu.com> <20100909124138.GQ29263@csn.ul.ie> <alpine.DEB.2.00.1009090843480.18975@router.home>
 <20100909135523.GA340@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Sep 2010, Mel Gorman wrote:

> > This will have the effect of never sending IPIs for slab allocations since
> > they do not do allocations for orders > PAGE_ALLOC_COSTLY_ORDER.
> >
>
> The question is how severe is that? There is somewhat of an expectation
> that the lower orders free naturally so it the IPI justified? That said,
> our historical behaviour would have looked like
>
> if (!page && !drained && order) {
> 	drain_all_pages();
> 	draiained = true;
> 	goto retry;
> }
>
> Play it safe for now and go with that?

I am fine with no IPIs for order <= COSTLY. Just be aware that this is
a change that may have some side effects. Lets run some tests and see
how it affect the issues that we are seeing.
