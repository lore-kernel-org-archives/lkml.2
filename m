Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423223Ab2KNSlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:41:17 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40837 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423178Ab2KNSlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:41:15 -0500
Date: Wed, 14 Nov 2012 10:41:10 -0800
From: Tejun Heo <htejun@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>
Subject: Re: [RFC] rework mem_cgroup iterator
Message-ID: <20121114184110.GD21185@mtj.dyndns.org>
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
 <50A3C42F.9020901@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A3C42F.9020901@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Wed, Nov 14, 2012 at 05:17:51PM +0100, Glauber Costa wrote:
> Why can't we reuse the scheduler iterator and move it to kernel/cgroup.c
> ? It already exists, provide sane ordering, and only relies on parent
> information - which cgroup core already have - to do the walk.

Hmmm... we can but I personally much prefer for_each_*() iterators
over callback based ones.  It's just much easier to share states
across an iteration and follow the logic.  walk_tg_tree_from() does
have the benefit of being able to combine pre and post visits in the
same walk, which doesn't seem to have any user at the moment.

Thanks.

-- 
tejun
