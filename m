Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab0KICxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 21:53:15 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52207 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab0KICxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 21:53:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH] RFC: vmscan: add min_filelist_kbytes sysctl for protecting the working set
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, wad@chromium.org, olofj@chromium.org,
        hughd@chromium.org
In-Reply-To: <20101104015249.GD19646@google.com>
References: <AANLkTimCjUgy9sN5QzxwW960v9eNWAjMBdq3H6P20NUa@mail.gmail.com> <20101104015249.GD19646@google.com>
Message-Id: <20101109115118.BC3C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Nov 2010 11:53:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't think current VM behavior has a problem.
> > Current problem is that you use up many memory than real memory.
> > As system memory without swap is low, VM doesn't have a many choice.
> > It ends up evict your working set to meet for user request. It's very
> > natural result for greedy user.
> > 
> > Rather than OOM notifier, what we need is memory notifier.
> > AFAIR, before some years ago, KOSAKI tried similar thing .
> > http://lwn.net/Articles/268732/
> 
> Thanks! This is perfect. I wonder why its not merged. Was a different
> solution eventually implemented? Is there another way of doing the
> same thing?

Now memcg has memory threshold notification feature and almost people
are using it. If you think notification fit your case, can you please
try this feature at first?
And if it doesn't fit your case and we will get a feedback from you, 
we probably can extend such one.

Thanks.


