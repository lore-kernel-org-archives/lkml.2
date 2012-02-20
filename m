Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab2BTIz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 03:55:29 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:41254 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab2BTIz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 03:55:28 -0500
Date: Mon, 20 Feb 2012 09:55:21 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 2/6] memcg: simplify move_account() check.
Message-ID: <20120220085521.GB1677@cmpxchg.org>
References: <20120217182426.86aebfde.kamezawa.hiroyu@jp.fujitsu.com>
 <20120217182612.810f6784.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217182612.810f6784.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 06:26:12PM +0900, KAMEZAWA Hiroyuki wrote:
> >From 3b6620772d7fd7b2126d5253eafb6afaf4ed6e34 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Thu, 2 Feb 2012 10:02:39 +0900
> Subject: [PATCH 2/6] memcg: simplify move_account() check.
> 
> In memcg, for avoiding take-lock-irq-off at accessing page_cgroup,
> a logic, flag + rcu_read_lock(), is used. This works as following
> 
>      CPU-A                     CPU-B
>                              rcu_read_lock()
>     set flag
>                              if(flag is set)
>                                    take heavy lock
>                              do job.
>     synchronize_rcu()        rcu_read_unlock()
>     take heavy lock.
> 
> In recent discussion, it's argued that using per-cpu value for this
> flag just complicates the code because 'set flag' is very rare.
> 
> This patch changes 'flag' implementation from percpu to atomic_t.
> This will be much simpler.
> 
> Changelog v5.
>  - removed redundant ().
>  - updated patch description.
> 
> Changelog: v4
>  - fixed many typos.
>  - fixed return value to be bool
>  - add comments.
> Changelog: v3
>  - this is a new patch since v3.
> 
> Acked-by: Greg Thelen <gthelen@google.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Much better!

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
