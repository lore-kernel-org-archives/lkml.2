Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab0GFLNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 07:13:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59609 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab0GFLNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 07:13:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 12/14] vmscan: Do not writeback pages in direct reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <20100706101235.GE13780@csn.ul.ie>
References: <20100706093529.CCD1.A69D9226@jp.fujitsu.com> <20100706101235.GE13780@csn.ul.ie>
Message-Id: <20100706200310.CD06.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  6 Jul 2010 20:13:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Jul 06, 2010 at 09:36:41AM +0900, KOSAKI Motohiro wrote:
> > Hello,
> > 
> > > Ok, that's reasonable as I'm still working on that patch. For example, the
> > > patch disabled anonymous page writeback which is unnecessary as the stack
> > > usage for anon writeback is less than file writeback. 
> > 
> > How do we examine swap-on-file?
> > 
> 
> Anything in particular wrong with the following?
> 
> /*
>  * For now, only kswapd can writeback filesystem pages as otherwise
>  * there is a stack overflow risk
>  */
> static inline bool reclaim_can_writeback(struct scan_control *sc,
>                                         struct page *page)
> {
>         return !page_is_file_cache(page) || current_is_kswapd();
> }
> 
> Even if it is a swapfile, I didn't spot a case where the filesystems
> writepage would be called. Did I miss something?

Hmm...

Now, I doubt I don't understand your mention. Do you mean you intend to swtich task
stack when every writepage? It seems a bit costly. but otherwise write-page for anon
makes filesystem IO and stack-overflow.

Can you please elaborate your plan?



