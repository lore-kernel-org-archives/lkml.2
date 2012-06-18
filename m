Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab2FRMMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:12:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53626 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2FRMMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:12:44 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FDF1ABE.7070200@jp.fujitsu.com>
Date: Mon, 18 Jun 2012 21:10:38 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        Cristoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        cgroups@vger.kernel.org, devel@openvz.org,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v4 00/25] kmem limitation for memcg
References: <1340015298-14133-1-git-send-email-glommer@parallels.com>
In-Reply-To: <1340015298-14133-1-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/18 19:27), Glauber Costa wrote:
> Hello All,
> 
> This is my new take for the memcg kmem accounting. This should merge
> all of the previous comments from you guys, specially concerning the big churn
> inside the allocators themselves.
> 
> My focus in this new round was to keep the changes in the cache internals to
> a minimum. To do that, I relied upon two main pillars:
> 
>   * Cristoph's unification series, that allowed me to put must of the changes
>     in a common file. Even then, the changes are not too many, since the overal
>     level of invasiveness was decreased.
>   * Accounting is done directly from the page allocator. This means some pages
>     can fail to be accounted, but that can only happen when the task calling
>     kmem_cache_alloc or kmalloc is not the same task allocating a new page.
>     This never happens in steady state operation if the tasks are kept in the
>     same memcg. Naturally, if the page ends up being accounted to a memcg that
>     is not limited (such as root memcg), that particular page will simply not
>     be accounted.
> 
> The dispatcher code stays (mem_cgroup_get_kmem_cache), being the mechanism who
> guarantees that, during steady state operation, all objects allocated in a page
> will belong to the same memcg. I consider this a good compromise point between
> strict and loose accounting here.
> 

2 questions.

  - Do you have performance numbers ?

  - Do you think user-memory memcg should be switched to page-allocator level accounting ?
    (it will require some study for modifying current bached-freeing and per-cpu-stock
     logics...)

Thanks,
-Kame

