Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777Ab2EOAV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 20:21:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53502 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855Ab2EOAVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 20:21:25 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FB1A115.2080303@jp.fujitsu.com>
Date: Tue, 15 May 2012 09:19:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/6] mm: memcg: statistics implementation cleanups
References: <1337018451-27359-1-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1337018451-27359-1-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/15 3:00), Johannes Weiner wrote:

> Before piling more things (reclaim stats) on top of the current mess,
> I thought it'd be better to clean up a bit.
> 
> The biggest change is printing statistics directly from live counters,
> it has always been annoying to declare a new counter in two separate
> enums and corresponding name string arrays.  After this series we are
> down to one of each.
> 
>  mm/memcontrol.c |  223 +++++++++++++++++------------------------------
>  1 file changed, 82 insertions(+), 141 deletions(-)
> 


to all 1-6. Thank you.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

One excuse for my old implementation of mem_cgroup_get_total_stat(),
which is fixed in patch 6, is that I thought it's better to touch all counters
in a cachineline at once and avoiding long distance for-each loop.

What number of performance difference with some big hierarchy(100+children) tree ?
(But I agree your code is cleaner. I'm just curious.)

Thanks,
-Kame

