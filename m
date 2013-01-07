Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab3AGGSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 01:18:40 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49061 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab3AGGSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 01:18:37 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50EA689B.7060308@jp.fujitsu.com>
Date: Mon, 07 Jan 2013 15:18:03 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH v3 4/7] memcg: remove memcg from the reclaim iterators
References: <1357235661-29564-1-git-send-email-mhocko@suse.cz> <1357235661-29564-5-git-send-email-mhocko@suse.cz>
In-Reply-To: <1357235661-29564-5-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/01/04 2:54), Michal Hocko wrote:
> Now that per-node-zone-priority iterator caches memory cgroups rather
> than their css ids we have to be careful and remove them from the
> iterator when they are on the way out otherwise they might hang for
> unbounded amount of time (until the global/targeted reclaim triggers the
> zone under priority to find out the group is dead and let it to find the
> final rest).
> 
> This is solved by hooking into mem_cgroup_css_offline and checking all
> per-node-zone-priority iterators up the way to the root cgroup. If the
> current memcg is found in the respective iter->last_visited then it is
> replaced by the previous one in the same sub-hierarchy.
> 
> This guarantees that no group gets more reclaiming than necessary and
> the next iteration will continue without noticing that the removed group
> has disappeared.
> 
> Spotted-by: Ying Han <yinghan@google.com>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>


Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


