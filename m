Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab0HaBSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 21:18:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53836 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab0HaBSj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 21:18:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] vmscan: prevent background aging of anon page in no swap system
Cc: kosaki.motohiro@jp.fujitsu.com, Ying Han <yinghan@google.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <AANLkTi=NsY9T19rXuBWmeZ3Z2ayA=tHZ1+e=cEXuKVAt@mail.gmail.com>
References: <20100831095542.87CA.A69D9226@jp.fujitsu.com> <AANLkTi=NsY9T19rXuBWmeZ3Z2ayA=tHZ1+e=cEXuKVAt@mail.gmail.com>
Message-Id: <20100831101456.87D0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 31 Aug 2010 10:18:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi, KOSAKI.
> 
> On Tue, Aug 31, 2010 at 9:56 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >> index 1b145e6..0b8a3ce 100644
> >> --- a/mm/vmscan.c
> >> +++ b/mm/vmscan.c
> >> @@ -1747,7 +1747,7 @@ static void shrink_zone(int priority, struct zone *zone,
> >>          * Even if we did not try to evict anon pages at all, we want to
> >>          * rebalance the anon lru active/inactive ratio.
> >>          */
> >> -       if (inactive_anon_is_low(zone, sc) && nr_swap_pages > 0)
> >> +       if (nr_swap_pges > 0 && inactive_anon_is_low(zone, sc))
> >
> > Sorry, I don't find any difference. What is your intention?
> >
> 
> My intention is that smart gcc can compile out inactive_anon_is_low
> call in case of non swap configurable system.

Do you really check it on your gcc? nr_swap_pages is not file scope variable, it's
global variable. afaik, current gcc's link time optimization is not so cool.

Do you have a disassemble list?



