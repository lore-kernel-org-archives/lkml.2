Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab1EANTu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:19:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34180 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab1EANTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:19:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [RFC 5/8] compaction: remove active list counting
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <BANLkTi=bMm+iyO23+16FxK__V1-aM50zWQ@mail.gmail.com>
References: <20110428105027.GT4658@suse.de> <BANLkTi=bMm+iyO23+16FxK__V1-aM50zWQ@mail.gmail.com>
Message-Id: <20110501222117.75E8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Sun,  1 May 2011 22:19:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Apr 28, 2011 at 7:50 PM, Mel Gorman <mgorman@suse.de> wrote:
> > On Wed, Apr 27, 2011 at 01:25:22AM +0900, Minchan Kim wrote:
> >> acct_isolated of compaction uses page_lru_base_type which returns only
> >> base type of LRU list so it never returns LRU_ACTIVE_ANON or LRU_ACTIVE_FILE.
> >> So it's pointless to add lru[LRU_ACTIVE_[ANON|FILE]] to get sum.
> >>
> >> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> >> Cc: Mel Gorman <mgorman@suse.de>
> >> Cc: Rik van Riel <riel@redhat.com>
> >> Cc: Andrea Arcangeli <aarcange@redhat.com>
> >> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> >
> > hmm, isolate_migratepages() is doing a linear scan of PFNs and is
> > calling __isolate_lru_page(..ISOLATE_BOTH..). Using page_lru_base_type
> > happens to work because we're only interested in the number of isolated
> > pages and your patch still covers that. Using page_lru might be more
> > accurate in terms of accountancy but does not seem necessary.
> 
> True.
> 
> >
> > Adding a comment explaining why we account for it as inactive and why
> > that's ok would be nice although I admit this is something I should have
> > done when acct_isolated() was introduced.
> 
> When Kame pointed out comment, I wanted to avoid unnecessary comment
> so decided changing it with page_lru although it adds overhead a
> little bit. But Hannes, you and maybe Kame don't want it. I don't mind
> adding comment.
> Okay. fix it in next version.

Or

	unsigned int count[2];

        list_for_each_entry(page, &cc->migratepages, lru) {
                count[page_is_file_cache(page)]++;
        }

is also clear to me.


