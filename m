Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab2EaGRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 02:17:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55236 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2EaGRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 02:17:15 -0400
Date: Thu, 31 May 2012 06:17:07 +0800
From: baozich <baozich@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm/memcg: apply add/del_page to lruvec
Message-ID: <20120530221707.GA25095@centos-guest>
References: <alpine.LSU.2.00.1205132152530.6148@eggly.anvils>
 <alpine.LSU.2.00.1205132201210.6148@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1205132201210.6148@eggly.anvils>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,
On Sun, May 13, 2012 at 10:02:28PM -0700, Hugh Dickins wrote:
> Take lruvec further: pass it instead of zone to add_page_to_lru_list()
> and del_page_from_lru_list(); and pagevec_lru_move_fn() pass lruvec
> down to its target functions.
> 
> This cleanup eliminates a swathe of cruft in memcontrol.c,
> including mem_cgroup_lru_add_list(), mem_cgroup_lru_del_list() and
> mem_cgroup_lru_move_lists() - which never actually touched the lists.
> 
> In their place, mem_cgroup_page_lruvec() to decide the lruvec,
> previously a side-effect of add, and mem_cgroup_update_lru_size()
> to maintain the lru_size stats.
I have a stupid question. I'm not sure whether there is reduplication
to put both "page" and "zone" parameter in mem_cgroup_page_lruvec(),
for I noticed that the "struct zone *zone" parameter are usually from 
page_zone(page) in most cases. I think that the semantics of this function
is to grab the lruvec the page belongs to. So will it be ok if we pass
only "page" as the parameter, which I think would be cleaner? Please
fix me if I missed something.

Thanks

Baozi
> 
> Whilst these are simplifications in their own right, the goal is to
> bring the evaluation of lruvec next to the spin_locking of the lrus,
> in preparation for a future patch.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
