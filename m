Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab2JPIVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 04:21:24 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37196 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab2JPIVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 04:21:21 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <507D18D2.5020707@jp.fujitsu.com>
Date: Tue, 16 Oct 2012 17:20:34 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Suleiman Souhlal <suleiman@google.com>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Greg Thelen <gthelen@google.com>, devel@openvz.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v4 08/14] res_counter: return amount of charges after
 res_counter_uncharge
References: <1349690780-15988-1-git-send-email-glommer@parallels.com> <1349690780-15988-9-git-send-email-glommer@parallels.com>
In-Reply-To: <1349690780-15988-9-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/08 19:06), Glauber Costa wrote:
> It is useful to know how many charges are still left after a call to
> res_counter_uncharge. While it is possible to issue a res_counter_read
> after uncharge, this can be racy.
> 
> If we need, for instance, to take some action when the counters drop
> down to 0, only one of the callers should see it. This is the same
> semantics as the atomic variables in the kernel.
> 
> Since the current return value is void, we don't need to worry about
> anything breaking due to this change: nobody relied on that, and only
> users appearing from now on will be checking this value.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Michal Hocko <mhocko@suse.cz>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> CC: Suleiman Souhlal <suleiman@google.com>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>   Documentation/cgroups/resource_counter.txt |  7 ++++---
>   include/linux/res_counter.h                | 12 +++++++-----
>   kernel/res_counter.c                       | 20 +++++++++++++-------
>   3 files changed, 24 insertions(+), 15 deletions(-)

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



