Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab1LNBH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 20:07:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64105 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754014Ab1LNBHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 20:07:21 -0500
Message-ID: <4EE7F745.3040508@cn.fujitsu.com>
Date: Wed, 14 Dec 2011 09:09:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        cgroups@vger.kernel.org, bsingharora@gmail.com, devel@openvz.org,
        kamezawa.hiroyu@jp.fujitsu.com, tj@kernel.org
Subject: Re: [PATCH 1/3] nitpick: make simple functions inline
References: <1323614738-7405-1-git-send-email-glommer@parallels.com> <1323614738-7405-3-git-send-email-glommer@parallels.com>
In-Reply-To: <1323614738-7405-3-git-send-email-glommer@parallels.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-14 09:06:43,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-14 09:06:44,
	Serialize complete at 2011-12-14 09:06:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

22:45, Glauber Costa wrote:
> Those are quite simple bit-testing functions that are
> only used within this file. Not reason for them not to
> be inline.
> 

It's better to leave the optimization decision to gcc.

And I've confirmed they are inlined by gcc in my box.

(btw, please add "cgroup" prefix to the patch subject line)

> Signed-off-by: Glauber Costa <glommer@parallels.com>
> ---
>  kernel/cgroup.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index d9d5648..e4b9d3c 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -241,12 +241,12 @@ static int cgroup_is_releasable(const struct cgroup *cgrp)
>  	return (cgrp->flags & bits) == bits;
>  }
>  
> -static int notify_on_release(const struct cgroup *cgrp)
> +static inline int notify_on_release(const struct cgroup *cgrp)
>  {
>  	return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
>  }
>  
> -static int clone_children(const struct cgroup *cgrp)
> +static inline int clone_children(const struct cgroup *cgrp)
>  {
>  	return test_bit(CGRP_CLONE_CHILDREN, &cgrp->flags);
>  }
