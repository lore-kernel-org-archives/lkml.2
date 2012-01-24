Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab2AXLQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:16:57 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:55520 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634Ab2AXLQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:16:55 -0500
Date: Tue, 24 Jan 2012 12:16:44 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH v4] memcg: remove PCG_CACHE page_cgroup flag
Message-ID: <20120124111644.GE1660@cmpxchg.org>
References: <20120119181711.8d697a6b.kamezawa.hiroyu@jp.fujitsu.com>
 <20120120122658.1b14b512.kamezawa.hiroyu@jp.fujitsu.com>
 <20120120084545.GC9655@tiehlicka.suse.cz>
 <20120124121636.115f1cf0.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124121636.115f1cf0.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 12:16:36PM +0900, KAMEZAWA Hiroyuki wrote:
> 
> > Can we make this anon as well?
> 
> I'm sorry for long RTT. version 4 here.
> ==
> >From c40256561d6cdaee62be7ec34147e6079dc426f4 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Thu, 19 Jan 2012 17:09:41 +0900
> Subject: [PATCH] memcg: remove PCG_CACHE
> 
> We record 'the page is cache' by PCG_CACHE bit to page_cgroup.
> Here, "CACHE" means anonymous user pages (and SwapCache). This
> doesn't include shmem.

!CACHE means anonymous/swapcache

> Consdering callers, at charge/uncharge, the caller should know
> what  the page is and we don't need to record it by using 1bit
> per page.
> 
> This patch removes PCG_CACHE bit and make callers of
> mem_cgroup_charge_statistics() to specify what the page is.
> 
> Changelog since v3
>  - renamed a variable 'rss' to 'anon'
> 
> Changelog since v2
>  - removed 'not_rss', added 'anon'
>  - changed a meaning of arguments to mem_cgroup_charge_statisitcs()
>  - removed a patch to mem_cgroup_uncharge_cache
>  - simplified comment.
> 
> Changelog since RFC.
>  - rebased onto memcg-devel
>  - rename 'file' to 'not_rss'
>  - some cleanup and added comment.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
