Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab0GFGCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 02:02:40 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46982 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab0GFGCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 02:02:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 12/14] vmscan: Do not writeback pages in direct reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <AANLkTimk6SwmljTWpIgp_OI_eLP6w8BCWKf-VRUFQ65H@mail.gmail.com>
References: <20100706093529.CCD1.A69D9226@jp.fujitsu.com> <AANLkTimk6SwmljTWpIgp_OI_eLP6w8BCWKf-VRUFQ65H@mail.gmail.com>
Message-Id: <20100706150030.CCFA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  6 Jul 2010 15:02:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Jul 6, 2010 at 9:36 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > Hello,
> >
> >> Ok, that's reasonable as I'm still working on that patch. For example, the
> >> patch disabled anonymous page writeback which is unnecessary as the stack
> >> usage for anon writeback is less than file writeback.
> >
> > How do we examine swap-on-file?
> 
> bool is_swap_on_file(struct page *page)
> {
>     struct swap_info_struct *p;
>     swp_entry_entry entry;
>     entry.val = page_private(page);
>     p = swap_info_get(entry);
>     return !(p->flags & SWP_BLKDEV)
> }

Well, do you suggested we traverse all pages in lru _before_
starting vmscan?



