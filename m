Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab1KPH2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 02:28:53 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34548 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab1KPH2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 02:28:52 -0500
Message-ID: <4EC36631.8030805@google.com>
Date: Tue, 15 Nov 2011 23:28:49 -0800
From: Paul Turner <pjt@google.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Il Han <corone.il.han@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: add the inline keyword to the prototype.
References: <1321380994-5768-1-git-send-email-corone.il.han@gmail.com>
In-Reply-To: <1321380994-5768-1-git-send-email-corone.il.han@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2011 10:16 AM, Il Han wrote:
> The prototype has to agree with the definition.
> Add the inline keyword to the prototype also
>

Hmm... this would then cause the prototypes to disagree in the 
!CONFIG_CFS_BANDWIDTH case.

Can you update?

> Signed-off-by: Il Han<corone.il.han@gmail.com>
> ---
>   kernel/sched_fair.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 5c9e679..c7c93d2 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -306,7 +306,7 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
>
>   #endif	/* CONFIG_FAIR_GROUP_SCHED */
>
> -static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
> +static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
>   				   unsigned long delta_exec);
>
>   /**************************************************************
> @@ -1052,7 +1052,7 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
>   		__clear_buddies_skip(se);
>   }
>
> -static void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
> +static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
>
>   static void
>   dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)

