Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab2KNANq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 19:13:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56789 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab2KNANp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 19:13:45 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50A2E229.3050809@jp.fujitsu.com>
Date: Wed, 14 Nov 2012 09:13:29 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC] rework mem_cgroup iterator
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
In-Reply-To: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/14 0:30), Michal Hocko wrote:
> Hi all,
> this patch set tries to make mem_cgroup_iter saner in the way how it
> walks hierarchies. css->id based traversal is far from being ideal as it
> is not deterministic because it depends on the creation ordering.
> 
> Diffstat looks promising but it is fair the say that the biggest cleanup is
> just css_get_next removal. The memcg code has grown a bit but I think it is
> worth the resulting outcome (the sanity ;)).
> 
> The first patch fixes a potential misbehaving which I haven't seen but the
> fix is needed for the later patches anyway. We could take it alone as well
> but I do not have any bug report to base the fix on.
> 
> The second patch replaces css_get_next by cgroup iterators which are
> scheduled for 3.8 in Tejun's tree and I depend on the following two patches:
> fe1e904c cgroup: implement generic child / descendant walk macros
> 7e187c6c cgroup: use rculist ops for cgroup->children
> 
> The third patch is an attempt for simplification of the mem_cgroup_iter. It
> basically removes all css usages to make the code easier. The next patch
> removes the big while(!memcg) loop around the iterating logic. It could have
> been folded into #3 but I rather have the rework separate from the code
> moving noise.
> 
> The last patch just removes css_get_next as there is no user for it any
> longer.
> 
> I am also thinking that leaf-to-root iteration makes more sense but this
> patch is not included in the series yet because I have to think some
> more about the justification.
> 
> So far I didn't get to testing but I am posting this early if everybody is
> OK with this change.
> 
> Any thoughts?
> 

I'm O.K. Maybe I have some points I'm not understanding...I'll make a reply to patches.

Thanks,
-Kame

