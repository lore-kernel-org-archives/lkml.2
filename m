Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422942Ab2JaN5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:57:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422901Ab2JaN5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:57:37 -0400
Date: Wed, 31 Oct 2012 09:57:22 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] cgroup: make ->pre_destroy() return void
Message-ID: <20121031135722.GB1865@redhat.com>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <1351657365-25055-9-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351657365-25055-9-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 09:22:45PM -0700, Tejun Heo wrote:
> All ->pre_destory() implementations return 0 now, which is the only
> allowed return value.  Make it return void.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/blk-cgroup.c     | 3 +--
>  include/linux/cgroup.h | 2 +-
>  kernel/cgroup.c        | 2 +-
>  mm/hugetlb_cgroup.c    | 4 +---
>  mm/memcontrol.c        | 3 +--
>  5 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index f3b44a6..a7816f3 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -600,7 +600,7 @@ struct cftype blkcg_files[] = {
>   *
>   * This is the blkcg counterpart of ioc_release_fn().
>   */
> -static int blkcg_pre_destroy(struct cgroup *cgroup)
> +static void blkcg_pre_destroy(struct cgroup *cgroup)
>  {
>  	struct blkcg *blkcg = cgroup_to_blkcg(cgroup);
>  
> @@ -622,7 +622,6 @@ static int blkcg_pre_destroy(struct cgroup *cgroup)
>  	}
>  
>  	spin_unlock_irq(&blkcg->lock);
> -	return 0;

Looks good from blk-cgroup perspective. ACK for these bits.

Thanks
Vivek
