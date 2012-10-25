Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935988Ab2JYRUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:20:23 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60709 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935930Ab2JYRUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:20:21 -0400
Date: Thu, 25 Oct 2012 10:20:16 -0700
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] freezer: exec should clear PF_NOFREEZE along with
 PF_KTHREAD
Message-ID: <20121025172016.GF11442@htj.dyndns.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <1350426526-14254-5-git-send-email-tj@kernel.org>
 <20121022183453.GA24687@redhat.com>
 <20121022211822.GF5951@atj.dyndns.org>
 <20121023155533.GC16201@redhat.com>
 <20121024190651.GC12182@atj.dyndns.org>
 <20121025171236.GA6776@redhat.com>
 <20121025171256.GB6776@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025171256.GB6776@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 07:12:56PM +0200, Oleg Nesterov wrote:
> flush_old_exec() clears PF_KTHREAD but forgets about PF_NOFREEZE.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Probably needs Cc: stable.

  Acked-by: Tejun Heo <tj@kernel.org>

How should this be routed?  -mm?  Andrew, can you please pick this up?

Thanks.

> ---
>  fs/exec.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 8b9011b..0039055 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1083,7 +1083,8 @@ int flush_old_exec(struct linux_binprm * bprm)
>  	bprm->mm = NULL;		/* We're using it now */
>  
>  	set_fs(USER_DS);
> -	current->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD);
> +	current->flags &=
> +		~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD | PF_NOFREEZE);
>  	flush_thread();
>  	current->personality &= ~bprm->per_clear;
>  
> -- 
> 1.5.5.1
> 
> 

-- 
tejun
