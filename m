Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab2BUW0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 17:26:19 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34800 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab2BUW0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 17:26:18 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.189.39 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Tue, 21 Feb 2012 14:25:54 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/10] mm/memcg: apply add/del_page to lruvec
In-Reply-To: <20120221172042.20f407fe.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.LSU.2.00.1202211421170.2012@eggly.anvils>
References: <alpine.LSU.2.00.1202201518560.23274@eggly.anvils> <alpine.LSU.2.00.1202201530530.23274@eggly.anvils> <20120221172042.20f407fe.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many thanks for inspecting these, and so soon.

On Tue, 21 Feb 2012, KAMEZAWA Hiroyuki wrote:
> 
> Hmm.. a nitpick.
> 
> You do 
>   lruvec = mem_cgroup_page_lruvec(page, zone);
> 
> What is the difference from
> 
>   lruvec = mem_cgroup_page_lruvec(page, page_zone(page)) 
> 
> ?

I hope they were equivalent: I just did it that way because in all cases
the zone had already been computed, so that saved recomputing it - as I
understand it, in some layouts (such as mine) it's pretty cheap to work
out the page's zone, but in others an expense to be avoided.

But then you discovered that it soon got removed again anyway.

Hugh

> 
> If we have a function
>   lruvec = mem_cgroup_page_lruvec(page)
> 
> Do we need 
>   lruvec = mem_cgroup_page_lruvec_zone(page, zone) 
> 
> ?
