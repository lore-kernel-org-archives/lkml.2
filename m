Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab1I1XmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:42:00 -0400
Received: from mx2.parallels.com ([64.131.90.16]:51627 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754263Ab1I1Xl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 19:41:58 -0400
Message-ID: <4E83B071.5010703@parallels.com>
Date: Wed, 28 Sep 2011 20:40:33 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <a.p.zijlstra@chello.nl>, <jbottomley@parallels.com>
Subject: Re: [PATCH] trivial: initialize root cgroup's sibling list
References: <1316816389-9135-1-git-send-email-glommer@parallels.com>
In-Reply-To: <1316816389-9135-1-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.135.174]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2011 07:19 PM, Glauber Costa wrote:
> Even though there are no siblings, the list should be
> initialized not to contain bogus values.
>
> Signed-off-by: Glauber Costa<glommer@parallels.com>
> ---
>   kernel/sched.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index ccacdbd..3ed4107 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8082,6 +8082,7 @@ void __init sched_init(void)
>   #ifdef CONFIG_CGROUP_SCHED
>   	list_add(&root_task_group.list,&task_groups);
>   	INIT_LIST_HEAD(&root_task_group.children);
> +	INIT_LIST_HEAD(&root_task_group.siblings);
>   	autogroup_init(&init_task);
>   #endif /* CONFIG_CGROUP_SCHED */
>
Peter, how about this one ?
