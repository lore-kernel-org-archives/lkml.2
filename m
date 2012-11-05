Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab2KEFf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 00:35:58 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:11030 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab2KEFf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 00:35:56 -0500
Message-ID: <50974FE3.60102@huawei.com>
Date: Mon, 5 Nov 2012 13:34:27 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <bsingharora@gmail.com>,
        <kamezawa.hiroyu@jp.fujitsu.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] cgroup: kill cgroup_subsys->__DEPRECATED_clear_css_refs
References: <1351712650-23709-1-git-send-email-tj@kernel.org> <1351712650-23709-2-git-send-email-tj@kernel.org>
In-Reply-To: <1351712650-23709-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/11/1 3:44, Tejun Heo wrote:
> 2ef37d3fe4 ("memcg: Simplify mem_cgroup_force_empty_list error
> handling") removed the last user of __DEPRECATED_clear_css_refs.  This
> patch removes __DEPRECATED_clear_css_refs and mechanisms to support
> it.
> 
> * Conditionals dependent on __DEPRECATED_clear_css_refs removed.
> 
> * cgroup_clear_css_refs() can no longer fail.  All that needs to be
>   done are deactivating refcnts, setting CSS_REMOVED and putting the
>   base reference on each css.  Remove cgroup_clear_css_refs() and the
>   failure path, and open-code the loops into cgroup_rmdir().
> 
> This patch keeps the two for_each_subsys() loops separate while open
> coding them.  They can be merged now but there are scheduled changes
> which need them to be separate, so keep them separate to reduce the
> amount of churn.
> 
> local_irq_save/restore() from cgroup_clear_css_refs() are replaced
> with local_irq_disable/enable() for simplicity.  This is safe as
> cgroup_rmdir() is always called with IRQ enabled.  Note that this IRQ
> switching is necessary to make CSS deactivation and CSS_REMOVED
> assertion atomic against css_tryget() and will be removed by future
> changes.
> 
> v2: cgroup_call_pre_destroy() removal dropped per Michal.  Commit
>     message updated to explain local_irq_disable/enable() conversion.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

Acked-by: Li Zefan <lizefan@huawei.com>


