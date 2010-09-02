Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab0IBX5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 19:57:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40074 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab0IBX5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 19:57:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH v3] vmscan: prevent background aging of anon page in no swap system
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <1283441862-15855-1-git-send-email-minchan.kim@gmail.com>
References: <1283441862-15855-1-git-send-email-minchan.kim@gmail.com>
Message-Id: <20100903085612.B654.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  3 Sep 2010 08:57:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ying Han reported that backing aging of anon pages in no swap system
> causes unnecessary TLB flush.
> 
> When I sent a patch(69c8548175), I wanted this patch but Rik pointed out
> and allowed aging of anon pages to give a chance to promote from inactive
> to active LRU.
> 
> It has a two problem.
> 
> 1) non-swap system
> 
> Never make sense to age anon pages.
> 
> 2) swap configured but still doesn't swapon
> 
> It doesn't make sense to age anon pages until swap-on time.
> But it's arguable. If we have aged anon pages by swapon, VM have moved
> anon pages from active to inactive. And in the time swapon by admin,
> the VM can't reclaim hot pages so we can protect hot pages swapout.
> 
> But let's think about it. When does swap-on happen? It depends on admin.
> we can't expect it. Nonetheless, we have done aging of anon pages to
> protect hot pages swapout. It means we lost run time overhead when
> below high watermark but gain hot page swap-[in/out] overhead when VM
> decide swapout. Is it true? Let's think more detail.
> We don't promote anon pages in case of non-swap system. So even though
> VM does aging of anon pages, the pages would be in inactive LRU for a long
> time. It means many of pages in there would mark access bit again. So access
> bit hot/code separation would be pointless.
> 
> This patch prevents unnecessary anon pages demotion in not-yet-swapon and
> non-configured swap system. Even, in non-configuared swap system
> inactive_anon_is_low can be compiled out.
> 
> It could make side effect that hot anon pages could swap out
> when admin does swap on. But I think sooner or later it would be
> steady state. So it's not a big problem.
> 
> We could lose someting but gain more thing(TLB flush and unnecessary
> function call to demote anon pages).
> 
> Cc: Rik van Riel <riel@redhat.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Ying Han <yinghan@google.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>





