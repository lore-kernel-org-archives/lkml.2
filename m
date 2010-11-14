Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab0KNFV1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 00:21:27 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44976 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab0KNFV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 00:21:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH v3]mm/oom-kill: direct hardware access processes should get bonus
Cc: kosaki.motohiro@jp.fujitsu.com, lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        "rientjes@google.com" <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Figo.zhang" <zhangtianfei@leadcoretech.com>
In-Reply-To: <1289402666.10699.28.camel@localhost.localdomain>
References: <1289402093.10699.25.camel@localhost.localdomain> <1289402666.10699.28.camel@localhost.localdomain>
Message-Id: <20101114141913.E019.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 14 Nov 2010 14:21:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> the victim should not directly access hardware devices like Xorg server,
> because the hardware could be left in an unpredictable state, although 
> user-application can set /proc/pid/oom_score_adj to protect it. so i think
> those processes should get bonus for protection.
> 
> in v2, fix the incorrect comment.
> in v3, change the divided the badness score by 4, like old heuristic for protection. we just
> want the oom_killer don't select Root/RESOURCE/RAWIO process as possible.
> 
> suppose that if a user process A such as email cleint "evolution" and a process B with
> ditecly hareware access such as "Xorg", they have eat the equal memory (the badness score is 
> the same),so which process are you want to kill? so in new heuristic, it will kill the process B.
> but in reality, we want to kill process A.
> 
> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Sorry for the delay. I've sent completely revert patch to linus. It will
disappear your headache, I believe. I'm sorry that our development
caused your harm. We really don't want it.

Thanks.


> ---
> mm/oom_kill.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 4029583..f43d759 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -202,6 +202,15 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
>  		points -= 30;
>  
>  	/*
> +	 * Root and direct hareware access processes are usually more 
> +	 * important, so they should get bonus for protection. 
> +	 */
> +	if (has_capability_noaudit(p, CAP_SYS_ADMIN) ||
> +	    has_capability_noaudit(p, CAP_SYS_RESOURCE) ||
> +	    has_capability_noaudit(p, CAP_SYS_RAWIO))
> +		points /= 4;
> +
> +	/*
>  	 * /proc/pid/oom_score_adj ranges from -1000 to +1000 such that it may
>  	 * either completely disable oom killing or always prefer a certain
>  	 * task.
> 
> 



