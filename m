Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab2JaOgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:36:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422984Ab2JaOgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:36:00 -0400
Date: Wed, 31 Oct 2012 15:37:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: + fork-unshare-remove-dead-code.patch added to -mm tree
Message-ID: <20121031143700.GA4094@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/kernel/fork.c~fork-unshare-remove-dead-code
> +++ a/kernel/fork.c
> @@ -1792,10 +1792,8 @@ SYSCALL_DEFINE1(unshare, unsigned long,
>  			exit_sem(current);
>  		}
>
> -		if (new_nsproxy) {
> +		if (new_nsproxy)
>  			switch_task_namespaces(current, new_nsproxy);
> -			new_nsproxy = NULL;
> -		}
>
>  		task_lock(current);
>
> @@ -1819,9 +1817,6 @@ SYSCALL_DEFINE1(unshare, unsigned long,
>  		task_unlock(current);
>  	}
>
> -	if (new_nsproxy)
> -		put_nsproxy(new_nsproxy);
> -

Agreed.

Perhaps it also makes sense to kill
"if (new_fs || new_fd || do_sysvsem || new_nsproxy)" ? This check
buys nothing. And without this check it is obvious why we do not
need put_nsproxy() after this block.

Oleg.

