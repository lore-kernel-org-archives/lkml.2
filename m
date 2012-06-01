Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965773Ab2FATEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 15:04:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965742Ab2FATEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 15:04:10 -0400
Date: Fri, 1 Jun 2012 21:02:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Filipe Brandenburger <filbranden@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] prctl: pdeath_signal sent when parent thread
	(instead of parent process) dies
Message-ID: <20120601190230.GA405@redhat.com>
References: <1338332348-3469-1-git-send-email-filbranden@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338332348-3469-1-git-send-email-filbranden@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29, Filipe Brandenburger wrote:
>
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -806,7 +806,8 @@ static void forget_original_parent(struct task_struct *father)
>  				BUG_ON(t->ptrace);
>  				t->parent = t->real_parent;
>  			}
> -			if (t->pdeath_signal)
> +			if (t->pdeath_signal &&
> +			    !same_thread_group(father, reaper))
>  				group_send_sig_info(t->pdeath_signal,
>  						    SEND_SIG_NOINFO, t);
>  		} while_each_thread(p, t);

Filipe, you can't even imagine how much do I like this change
personally ;) Although I think that pdeath_signal code should
be moved into reparent_leader(). I suggested this many times.

But I was told there are users which depend on current behaviour,
they really want to know when the parent _thread_ exits.

Why? I have no idea. And I agree this is ugly, but we can't
break user-space.

Oleg.

