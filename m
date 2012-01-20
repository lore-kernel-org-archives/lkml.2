Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab2ATKeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 05:34:21 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:42275 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab2ATKeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 05:34:17 -0500
Date: Fri, 20 Jan 2012 11:33:57 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH v3] memcg: remove PCG_CACHE page_cgroup flag
Message-ID: <20120120103356.GT24386@cmpxchg.org>
References: <20120119181711.8d697a6b.kamezawa.hiroyu@jp.fujitsu.com>
 <20120120122658.1b14b512.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120120122658.1b14b512.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 12:26:58PM +0900, KAMEZAWA Hiroyuki wrote:
> I think this version is much simplified.
> 
> ==
> >From 5700a4fe9c581e1ebaa021ba6119dc8d921b024f Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Thu, 19 Jan 2012 17:09:41 +0900
> Subject: [PATCH v3] memcg: remove PCG_CACHE
> 
> We record 'the page is cache' by PCG_CACHE bit to page_cgroup.
> Here, "CACHE" means anonymous user pages (and SwapCache). This
> doesn't include shmem.
> 
> Consdering callers, at charge/uncharge, the caller should know
> what  the page is and we don't need to record it by using 1bit
> per page.
> 
> This patch removes PCG_CACHE bit and make callers of
> mem_cgroup_charge_statistics() to specify what the page is.
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

Apart from Michal's rss -> anon renaming suggestion, which I agree
with:

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
