Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab2KOJ2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:28:25 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41798 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab2KOJ2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:28:23 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50A4B5A0.8040102@jp.fujitsu.com>
Date: Thu, 15 Nov 2012 18:28:00 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 3/7] memcg: remove test for current->mm in memcg_stop/resume_kmem_account
References: <1352948093-2315-1-git-send-email-glommer@parallels.com> <1352948093-2315-4-git-send-email-glommer@parallels.com>
In-Reply-To: <1352948093-2315-4-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/15 11:54), Glauber Costa wrote:
> The original reason for the existence of this test, was that
> memcg_kmem_cache_create could be called from either softirq context
> (where memcg_stop/resume_account is not needed), or process context,
> (where memcg_stop/resume_account is needed). Just skipping it
> in-function was the cleanest way to merge both behaviors. The reason for
> that is that we would try to create caches right away through
> memcg_kmem_cache_create if the context would allow us to.
> 
> However, the final version of the code that merged did not have this
> behavior and we always queue up new cache creation. Thus, instead of a
> comment explaining why current->mm test is needed, my proposal in this
> patch is to remove memcg_stop/resume_account from the worker thread and
> make sure all callers have a valid mm context.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Michal Hocko <mhocko@suse.cz>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> CC: Andrew Morton <akpm@linux-foundation.org>

seems ok to me. But do we need VM_BUG_ON() ?
It seems functions called under memcg_stop_kmem_account() doesn't access
current->mm...

Anyway.
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



