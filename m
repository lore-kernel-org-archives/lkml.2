Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab1K1AhV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 19:37:21 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50824 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487Ab1K1AhT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 19:37:19 -0500
MIME-Version: 1.0
In-Reply-To: <1322062951-1756-2-git-send-email-hannes@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
	<1322062951-1756-2-git-send-email-hannes@cmpxchg.org>
Date: Mon, 28 Nov 2011 06:07:17 +0530
Message-ID: <CAKTCnzmfk5O24R2Lh08e-WgA75TtTaO11vZjJOnPXxHhThX-XA@mail.gmail.com>
Subject: Re: [patch 1/8] mm: oom_kill: remove memcg argument from oom_kill_task()
From: Balbir Singh <bsingharora@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 9:12 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> From: Johannes Weiner <jweiner@redhat.com>
>
> The memcg argument of oom_kill_task() hasn't been used since 341aea2
> 'oom-kill: remove boost_dying_task_prio()'.  Kill it.
>
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> ---
>  mm/oom_kill.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 471dedb..fd9e303 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -423,7 +423,7 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
>  }
>
>  #define K(x) ((x) << (PAGE_SHIFT-10))
> -static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
> +static int oom_kill_task(struct task_struct *p)
>  {
>        struct task_struct *q;
>        struct mm_struct *mm;
> @@ -522,7 +522,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>                }
>        } while_each_thread(p, t);
>
> -       return oom_kill_task(victim, mem);
> +       return oom_kill_task(victim);
>  }
>

Looks good!

Balbir Singh
