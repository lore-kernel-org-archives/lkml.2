Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193Ab2KBJXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:23:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51970 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555Ab2KBJXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:23:33 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <509390FE.1010304@jp.fujitsu.com>
Date: Fri, 02 Nov 2012 18:23:10 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] cgroup: kill cgroup_subsys->__DEPRECATED_clear_css_refs
References: <1351657365-25055-1-git-send-email-tj@kernel.org> <1351657365-25055-2-git-send-email-tj@kernel.org>
In-Reply-To: <1351657365-25055-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/31 13:22), Tejun Heo wrote:
> 2ef37d3fe4 ("memcg: Simplify mem_cgroup_force_empty_list error
> handling") removed the last user of __DEPRECATED_clear_css_refs.  This
> patch removes __DEPRECATED_clear_css_refs and mechanisms to support
> it.
> 
> * Conditionals dependent on __DEPRECATED_clear_css_refs removed.
> 
> * ->pre_destroy() now can only fail if a new task is attached or child
>    cgroup is created while ->pre_destroy()s are being called.  As the
>    condition is checked again after re-acquiring cgroup_mutex
>    afterwards, we don't need to take any immediate action on
>    ->pre_destroy() failures.  This reduces cgroup_call_pre_destroy() to
>    a simple loop surrounding ->pre_destory().  Remove
>    cgroup_call_pre_destroy() and open-code the loop into
>    cgroup_rmdir().
> 
> * cgroup_clear_css_refs() can no longer fail.  All that needs to be
>    done are deactivating refcnts, setting CSS_REMOVED and putting the
>    base reference on each css.  Remove cgroup_clear_css_refs() and the
>    failure path, and open-code the loops into cgroup_rmdir().
> 
> Note that cgroup_rmdir() will see more cleanup soon.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

I thank you and Michal for this work.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujisu.com>




