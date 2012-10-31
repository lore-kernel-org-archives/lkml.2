Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352Ab2JaUMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 16:12:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759725Ab2JaUMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 16:12:33 -0400
Date: Wed, 31 Oct 2012 21:12:27 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] cgroup: kill
 cgroup_subsys->__DEPRECATED_clear_css_refs
Message-ID: <20121031201227.GF1271@dhcp22.suse.cz>
References: <1351712650-23709-1-git-send-email-tj@kernel.org>
 <1351712650-23709-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351712650-23709-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 31-10-12 12:44:03, Tejun Heo wrote:
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 7981850..8c605e2 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -865,11 +865,8 @@ static int cgroup_call_pre_destroy(struct cgroup *cgrp)
>  			continue;
>  
>  		ret = ss->pre_destroy(cgrp);
> -		if (ret) {
> -			/* ->pre_destroy() failure is being deprecated */
> -			WARN_ON_ONCE(!ss->__DEPRECATED_clear_css_refs);
> +		if (WARN_ON_ONCE(ret))
>  			break;
> -		}
>  	}
>  
>  	return ret;

And sorry for being to annoying about this WARN_ON_ONCE but I really
don't see any reason for it. pre_destroy can still happen and now it is
even reduced to a reasonable condition (somebody shown up). So I would
put it out of way as it doesn't give us anything and as I've already
mentioned one can trigger it really easily.

-- 
Michal Hocko
SUSE Labs
