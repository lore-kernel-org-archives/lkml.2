Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab2DRStM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:49:12 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:35929 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab2DRStJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:49:09 -0400
Date: Wed, 18 Apr 2012 18:50:07 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Beiderman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 21/43] userns: Convert sched_set_affinity and
 sched_set_scheduler's permission checks
Message-ID: <20120418185006.GF4984@mail.hallyn.com>
References: <m11unyn70b.fsf@fess.ebiederm.org>
 <1333862139-31737-21-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333862139-31737-21-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Beiderman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> - Compare kuids with uid_eq
> - kuid are uniuqe across all user namespaces so there is no longer the
>   need for a user_namespace comparison.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  kernel/sched/core.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 96bff85..b189fec 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4042,11 +4042,8 @@ static bool check_same_owner(struct task_struct *p)
>  
>  	rcu_read_lock();
>  	pcred = __task_cred(p);
> -	if (cred->user_ns == pcred->user_ns)
> -		match = (cred->euid == pcred->euid ||
> -			 cred->euid == pcred->uid);
> -	else
> -		match = false;
> +	match = (uid_eq(cred->euid, pcred->euid) ||
> +		 uid_eq(cred->euid, pcred->uid));
>  	rcu_read_unlock();
>  	return match;
>  }
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
