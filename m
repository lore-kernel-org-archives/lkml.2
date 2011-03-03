Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab1CCHmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:42:20 -0500
Received: from smtp-out.google.com ([216.239.44.51]:22227 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697Ab1CCHmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:42:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TOTd9d4VrvFdk++U39QFDDGSkFy1ylGT2wEAtaVMcyzQzUzNJfcHOx6KM2Le7PPjEU
         /NrIWNNp6QBSjznZQXmQ==
MIME-Version: 1.0
In-Reply-To: <4D6F347E.2010806@cn.fujitsu.com>
References: <4D6F3461.6060406@cn.fujitsu.com>
	<4D6F347E.2010806@cn.fujitsu.com>
Date: Thu, 3 Mar 2011 08:42:15 +0100
Message-ID: <AANLkTiktGeR0LaNGAhXn7G5CJ3q3T=copn88Y-OgGBDb@mail.gmail.com>
Subject: Re: [PATCH 3/4] perf cgroup: Clean up perf_cgroup_create()
From: Stephane Eranian <eranian@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 7:26 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> - Use kzalloc() to replace kmalloc() + memset().
> - Remove redundant initialization, since alloc_percpu() returns
>  zero-filled percpu memory.
>
Acked-by: Stephane Eranian <eranian@google.com>

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/perf_event.c |   11 +----------
>  1 files changed, 1 insertions(+), 10 deletions(-)
>
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index dca92b2..d6b3d16 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -7341,26 +7341,17 @@ static struct cgroup_subsys_state *perf_cgroup_create(
>        struct cgroup_subsys *ss, struct cgroup *cont)
>  {
>        struct perf_cgroup *jc;
> -       struct perf_cgroup_info *t;
> -       int c;
>
> -       jc = kmalloc(sizeof(*jc), GFP_KERNEL);
> +       jc = kzalloc(sizeof(*jc), GFP_KERNEL);
>        if (!jc)
>                return ERR_PTR(-ENOMEM);
>
> -       memset(jc, 0, sizeof(*jc));
> -
>        jc->info = alloc_percpu(struct perf_cgroup_info);
>        if (!jc->info) {
>                kfree(jc);
>                return ERR_PTR(-ENOMEM);
>        }
>
> -       for_each_possible_cpu(c) {
> -               t = per_cpu_ptr(jc->info, c);
> -               t->time = 0;
> -               t->timestamp = 0;
> -       }
>        return &jc->css;
>  }
>
> --
> 1.6.3
>
