Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab2EUK2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 06:28:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34364 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233Ab2EUK2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 06:28:07 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FBA1841.40506@jp.fujitsu.com>
Date: Mon, 21 May 2012 19:26:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg,thp: fix res_counter:96 regression
References: <alpine.LSU.2.00.1205181116160.2082@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1205181116160.2082@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/19 3:28), Hugh Dickins wrote:

> Occasionally, testing memcg's move_charge_at_immigrate on rc7 shows
> a flurry of hundreds of warnings at kernel/res_counter.c:96, where
> res_counter_uncharge_locked() does WARN_ON(counter->usage < val).
> 
> The first trace of each flurry implicates __mem_cgroup_cancel_charge()
> of mc.precharge, and an audit of mc.precharge handling points to
> mem_cgroup_move_charge_pte_range()'s THP handling in 12724850e806
> "memcg: avoid THP split in task migration".
> 
> Checking !mc.precharge is good everywhere else, when a single page is
> to be charged; but here the "mc.precharge -= HPAGE_PMD_NR" likely to
> follow, is liable to result in underflow (a lot can change since the
> precharge was estimated).
> 
> Simply check against HPAGE_PMD_NR: there's probably a better alternative,
> trying precharge for more, splitting if unsuccessful; but this one-liner
> is safer for now - no kernel/res_counter.c:96 warnings seen in 26 hours.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>


Thank you.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



