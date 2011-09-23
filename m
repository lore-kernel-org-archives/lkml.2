Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246Ab1IWG7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 02:59:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56934 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab1IWG7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 02:59:38 -0400
Message-ID: <4E7C2E7F.40307@cn.fujitsu.com>
Date: Fri, 23 Sep 2011 15:00:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mike Galbraith <mgalbraith@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [patch] cpusets: allow PF_THREAD_BOUND kworkers to escape from
 a cpuset
References: <1316758874.7393.2.camel@marge.simson.net>
In-Reply-To: <1316758874.7393.2.camel@marge.simson.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-23 14:58:08,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-23 14:58:10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc David, who added this restriction

于 2011年09月23日 14:21, Mike Galbraith wrote:
> 
> kworkers can be born in a cpuset, leaving them adrift on an unsinkable ship.
> Allow them to be moved to the root cpuset so the cpuset can be destroyed.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> 

I've noticed this long ago, so..

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 10131fd..b26f4c4 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -1384,7 +1384,7 @@ static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
>  	 * set_cpus_allowed_ptr() on all attached tasks before cpus_allowed may
>  	 * be changed.
>  	 */
> -	if (tsk->flags & PF_THREAD_BOUND)
> +	if (tsk->flags & PF_THREAD_BOUND && cont->parent)

To make the code more self-explanatory, I think this is a bit better:

	if (... && cont != cont->top_cgroup)

>  		return -EINVAL;
>  
>  	return 0;
> 
