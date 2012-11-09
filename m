Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab2KIJNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 04:13:23 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:16366 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2KIJNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 04:13:07 -0500
Message-ID: <509CC91D.4050207@huawei.com>
Date: Fri, 9 Nov 2012 17:13:01 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <mhocko@suse.cz>, <rjw@sisk.pl>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <fweisbec@gmail.com>
Subject: Re: [PATCH 3/9 v2] cgroup: implement generic child / descendant walk
 macros
References: <1351931915-1701-1-git-send-email-tj@kernel.org> <1351931915-1701-4-git-send-email-tj@kernel.org> <20121108175946.GA9672@htj.dyndns.org>
In-Reply-To: <20121108175946.GA9672@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/11/9 1:59, Tejun Heo wrote:
> Currently, cgroup doesn't provide any generic helper for walking a
> given cgroup's children or descendants.  This patch adds the following
> three macros.
> 
> * cgroup_for_each_child() - walk immediate children of a cgroup.
> 
> * cgroup_for_each_descendant_pre() - visit all descendants of a cgroup
>   in pre-order tree traversal.
> 
> * cgroup_for_each_descendant_post() - visit all descendants of a
>   cgroup in post-order tree traversal.
> 
> All three only require the user to hold RCU read lock during
> traversal.  Verifying that each iterated cgroup is online is the
> responsibility of the user.  When used with proper synchronization,
> cgroup_for_each_descendant_pre() can be used to propagate state
> updates to descendants in reliable way.  See comments for details.
> 
> v2: s/config/state/ in commit message and comments per Michal.  More
>     documentation on synchronization rules.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujisu.com>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

I don't see anything wrong with the comment on cgroup_next_descendant_pre().

Acked-by: Li Zefan <lizefan@huawei.com>

