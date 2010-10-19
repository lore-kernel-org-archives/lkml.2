Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab0JSCyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 22:54:13 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56671 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab0JSCyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 22:54:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: Deadlock possibly caused by too_many_isolated.
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Neil Brown <neilb@suse.de>, Wu Fengguang <fengguang.wu@intel.com>,
        Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
In-Reply-To: <AANLkTi=1j5ejRyki+2wmKvOitorteW6uL53wfAWiPeAs@mail.gmail.com>
References: <20101019105257.A1C6.A69D9226@jp.fujitsu.com> <AANLkTi=1j5ejRyki+2wmKvOitorteW6uL53wfAWiPeAs@mail.gmail.com>
Message-Id: <20101019113316.A1CF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 19 Oct 2010 11:54:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> > Can you please elaborate your intention? Do you think Wu's approach is wrong?
> >>
> >> No. I think Wu's patch may work well. But I agree Andrew.
> >> Couldn't we remove the too_many_isolated logic? If it is, we can solve
> >> the problem simply.
> >> But If we remove the logic, we will meet long time ago problem, again.
> >> So my patch's intention is to prevent OOM and deadlock problem with
> >> simple patch without adding new heuristic in too_many_isolated.
> >
> > But your patch is much false positive/negative chance because isolated pages timing
> > and too_many_isolated_zone() call site are in far distance place.
> 
> Yes.
> How about the returning *did_some_progress can imply too_many_isolated
> fail by using MSB or new variable?
> Then, page_allocator can check it whether it causes read reclaim fail
> or parallel reclaim.
> The point is let's throttle without holding FS/IO lock.

Wu's version sleep in shrink_inactive_list(). your version sleep in __alloc_pages_slowpath()
by wait_iff_congested(). both don't release lock, I think.
But, if alloc_pages() return fail if GFP_NOIO, we introduce another issue.



