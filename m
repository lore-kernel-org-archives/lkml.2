Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab2BUIWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 03:22:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39290 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab2BUIWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 03:22:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 21 Feb 2012 17:20:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/10] mm/memcg: apply add/del_page to lruvec
Message-Id: <20120221172042.20f407fe.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LSU.2.00.1202201530530.23274@eggly.anvils>
References: <alpine.LSU.2.00.1202201518560.23274@eggly.anvils>
	<alpine.LSU.2.00.1202201530530.23274@eggly.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Feb 2012 15:32:06 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> Go further: pass lruvec instead of zone to add_page_to_lru_list() and
> del_page_from_lru_list(); and pagevec_lru_move_fn() pass lruvec down
> to its target functions.
> 
> This cleanup eliminates a swathe of cruft in memcontrol.c,
> including mem_cgroup_lru_add_list(), mem_cgroup_lru_del_list() and
> mem_cgroup_lru_move_lists(), which never actually touched the lists.
> 
> In their place, mem_cgroup_page_lruvec() to decide the lruvec,
> previously a side-effect of add, and mem_cgroup_update_lru_size()
> to maintain the lru_size stats.
> 
> Whilst these are simplifications in their own right, the goal is to
> bring the evaluation of lruvec next to the spin_locking of the lrus,
> in preparation for the next patch.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>


Hmm.. a nitpick.

You do 
  lruvec = mem_cgroup_page_lruvec(page, zone);

What is the difference from

  lruvec = mem_cgroup_page_lruvec(page, page_zone(page)) 

?

If we have a function
  lruvec = mem_cgroup_page_lruvec(page)

Do we need 
  lruvec = mem_cgroup_page_lruvec_zone(page, zone) 

?

Thanks,
-Kame

