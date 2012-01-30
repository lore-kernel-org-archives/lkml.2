Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab2A3K0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 05:26:54 -0500
Received: from gir.skynet.ie ([193.1.99.77]:35994 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab2A3K0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 05:26:53 -0500
Date: Mon, 30 Jan 2012 10:26:42 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Rik van Riel <riel@redhat.com>
Cc: Hillf Danton <dhillf@gmail.com>, linux-mm@kvack.org,
        lkml <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH v3 -mm 1/3] mm: reclaim at order 0 when compaction is
 enabled
Message-ID: <20120130102642.GA25268@csn.ul.ie>
References: <20120126145450.2d3d2f4c@cuia.bos.redhat.com>
 <20120126145914.58619765@cuia.bos.redhat.com>
 <CAJd=RBB=MDiYLVSYJj8d8NfBZp+OU0Lf3-W5+xZUqj0J1JA4cQ@mail.gmail.com>
 <4F22D236.4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4F22D236.4@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 11:35:02AM -0500, Rik van Riel wrote:
> On 01/27/2012 04:13 AM, Hillf Danton wrote:
> 
> >>@@ -1195,7 +1195,7 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
> >>                        BUG();
> >>                }
> >>
> >>-               if (!order)
> >>+               if (!sc->order || !(sc->reclaim_mode&  RECLAIM_MODE_LUMPYRECLAIM))
> >>                        continue;
> >>
> >Just a tiny advice 8-)
> >
> >mind to move checking lumpy reclaim out of the loop,
> >something like
> 
> Hehe, I made the change the way it is on request
> of Mel Gorman :)
> 

Yes. I recognise that checking inside the loop like this results
in a tiny hit but it is hardly critical. By putting the check here,
it is absolutely clear that this is now a lumpy-reclaim only thing
where it used to be used by both lumpy reclaim and reclaim/compaction.
It'll make deleting lumpy reclaim a little bit easier in the future.

-- 
Mel Gorman
SUSE Labs
