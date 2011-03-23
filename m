Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab1CWHzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 03:55:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45769 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab1CWHzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 03:55:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/5] vmscan: remove all_unreclaimable check from direct reclaim path completely
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>, Nick Piggin <npiggin@kernel.dk>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <20110323164122.ea25bdf0.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110322200523.B061.A69D9226@jp.fujitsu.com> <20110323164122.ea25bdf0.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20110323165552.1AD6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 23 Mar 2011 16:55:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Reported-by: Andrey Vagin <avagin@openvz.org>
> > Cc: Nick Piggin <npiggin@kernel.dk>
> > Cc: Minchan Kim <minchan.kim@gmail.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Rik van Riel <riel@redhat.com>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> IIUC, I saw the pehnomenon which you pointed out, as
>  - all zone->all_unreclaimable = yes
>  - zone_reclaimable() returns true
>  - no pgscan proceeds.
> 
> on a swapless system. So, I'd like to vote for this patch.
> 
> But hmm...what happens all of pages are isolated or locked and now under freeing ?
> I think we should have alternative safe-guard logic for avoiding to call
> oom-killer. Hmm.

Yes, this patch has small risk. but 1) this logic didn't work about two
years (see changelog) 2) memcg haven't use this logic and I haven't get
any bug report from memcg developers. therefore I decided to take most
simple way.

Of cource, I'll make another protection if I'll get any regression report.



