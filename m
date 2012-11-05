Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab2KEFki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 00:40:38 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:38559 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab2KEFkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 00:40:36 -0500
Message-ID: <50975135.5070600@huawei.com>
Date: Mon, 5 Nov 2012 13:40:05 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <bsingharora@gmail.com>,
        <kamezawa.hiroyu@jp.fujitsu.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] cgroup: remove CGRP_WAIT_ON_RMDIR, cgroup_exclude_rmdir()
 and cgroup_release_and_wakeup_rmdir()
References: <1351712650-23709-1-git-send-email-tj@kernel.org> <1351712650-23709-6-git-send-email-tj@kernel.org>
In-Reply-To: <1351712650-23709-6-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/11/1 3:44, Tejun Heo wrote:
> CGRP_WAIT_ON_RMDIR is another kludge which was added to make cgroup
> destruction rollback somewhat working.  cgroup_rmdir() used to drain
> CSS references and CGRP_WAIT_ON_RMDIR and the associated waitqueue and
> helpers were used to allow the task performing rmdir to wait for the
> next relevant event.
> 
> Unfortunately, the wait is visible to controllers too and the
> mechanism got exposed to memcg by 887032670d ("cgroup avoid permanent
> sleep at rmdir").
> 
> Now that the draining and retries are gone, CGRP_WAIT_ON_RMDIR is
> unnecessary.  Remove it and all the mechanisms supporting it.  Note
> that memcontrol.c changes are essentially revert of 887032670d
> ("cgroup avoid permanent sleep at rmdir").
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/cgroup.h | 21 ---------------------
>  kernel/cgroup.c        | 51 --------------------------------------------------
>  mm/memcontrol.c        | 24 +-----------------------
>  3 files changed, 1 insertion(+), 95 deletions(-)

Acked-by: Li Zefan <lizefan@huawei.com>

