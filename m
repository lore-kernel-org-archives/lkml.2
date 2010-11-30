Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab0K3Dyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 22:54:37 -0500
Received: from smtp-out.google.com ([216.239.44.51]:20753 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab0K3Dyg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 22:54:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=OIDLPTOZnkgA4gDb50ef5uQIqhjQE5LrP9EMXlYJLxmlzcVqa3FnG0XtZc12ZLdcTJ
         aHVsfoQNIPfHPKvUhWyg==
MIME-Version: 1.0
In-Reply-To: <1291089097.2405.152.camel@minggr.sh.intel.com>
References: <1291089097.2405.152.camel@minggr.sh.intel.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 29 Nov 2010 19:54:02 -0800
Message-ID: <AANLkTi=3=ffR3wRAfXsZ6+xABt3+sKJemJ_w-qfa0kf8@mail.gmail.com>
Subject: Re: [PATCH -tip] sched: fix uninitialized variable usage
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 7:51 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> linux-2.6/kernel/sched.c: In function ‘sched_destroy_group’:
> linux-2.6/kernel/sched.c:8101: warning: ‘i’ is used uninitialized in this function
>
> This is caused by commit 3d4b47b(Implement on-demand (active) cfs_rq list)
>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  kernel/sched.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>

Thanks for the catch!

http://lkml.org/lkml/2010/11/29/566 -- should already address this

- Paul


> diff --git a/kernel/sched.c b/kernel/sched.c
> index 717bf7d..c3af198 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8088,7 +8088,6 @@ static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
>  {
>        struct rq *rq = cpu_rq(cpu);
>        unsigned long flags;
> -       int i;
>
>        /*
>        * Only empty task groups can be destroyed; so we can speculatively
> @@ -8098,7 +8097,7 @@ static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
>                return;
>
>        raw_spin_lock_irqsave(&rq->lock, flags);
> -       list_del_leaf_cfs_rq(tg->cfs_rq[i]);
> +       list_del_leaf_cfs_rq(tg->cfs_rq[cpu]);
>        raw_spin_unlock_irqrestore(&rq->lock, flags);
>  }
>  #else /* !CONFG_FAIR_GROUP_SCHED */
>
>
>
