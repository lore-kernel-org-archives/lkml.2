Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051Ab1LPC2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 21:28:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59915 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759998Ab1LPC2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 21:28:38 -0500
Message-ID: <4EEAAD45.5030407@cn.fujitsu.com>
Date: Fri, 16 Dec 2011 10:30:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mandeep Singh Baines <msb@chromium.org>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH] cgroups: remove redundant get/put of css_set from css_set_check_fetched()
References: <1323987686-17968-1-git-send-email-msb@chromium.org>
In-Reply-To: <1323987686-17968-1-git-send-email-msb@chromium.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-16 10:27:43,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-16 10:27:50,
	Serialize complete at 2011-12-16 10:27:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mandeep Singh Baines wrote:
> We already have a reference to all elements in newcg_list.
> 

Indeed. The patch looks good to me.

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: containers@lists.linux-foundation.org
> Cc: cgroups@vger.kernel.org
> Cc: Paul Menage <paul@paulmenage.org>
> ---
>  kernel/cgroup.c |   10 ++--------
>  1 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index d9d5648..a7e00b9 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1935,23 +1935,17 @@ static bool css_set_check_fetched(struct cgroup *cgrp,
>  
>  	read_lock(&css_set_lock);
>  	newcg = find_existing_css_set(cg, cgrp, template);
> -	if (newcg)
> -		get_css_set(newcg);
>  	read_unlock(&css_set_lock);
>  
>  	/* doesn't exist at all? */
>  	if (!newcg)
>  		return false;
>  	/* see if it's already in the list */
> -	list_for_each_entry(cg_entry, newcg_list, links) {
> -		if (cg_entry->cg == newcg) {
> -			put_css_set(newcg);
> +	list_for_each_entry(cg_entry, newcg_list, links)
> +		if (cg_entry->cg == newcg)
>  			return true;
> -		}
> -	}
>  
>  	/* not found */
> -	put_css_set(newcg);
>  	return false;
>  }
>  
