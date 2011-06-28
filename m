Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab1F1CnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 22:43:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45545 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab1F1Ckz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 22:40:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KrrXilXsgmNRS1D69/KNnmXGipxY7HUqcAL4biY0s7/bbypUSdN9SI/AhHcpKgHasN
         1wT0PdOpscadq/smQlYi0Wad/PwmfvXf2q/mUia4PHsJQGRp2Dz9/NRrUJouh1WlSy9C
         AM/YmoQB4u8M5NdrL7xvwU5np5GMQ+547XoBs=
MIME-Version: 1.0
In-Reply-To: <4E0321AD.2080308@linux.vnet.ibm.com>
References: <BANLkTikKRnQb_T5x1BA=WopbBA_weLNFoQ@mail.gmail.com>
	<4E0321AD.2080308@linux.vnet.ibm.com>
Date: Tue, 28 Jun 2011 10:40:54 +0800
Message-ID: <BANLkTinacDgzZenwmG4==1gYfEaQg-YQ-g@mail.gmail.com>
Subject: Re: [PATCH] sched: skip autogroup when looking for all rt sched groups
From: Yong Zhang <yong.zhang0@gmail.com>
To: Cheng Xu <chengxu@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for my late response and comments below.

On Thu, Jun 23, 2011 at 7:21 PM, Cheng Xu <chengxu@linux.vnet.ibm.com> wrote:
>
> This looks like it works, but seems we might be able to do that with less code...
>
> static inline struct task_group *next_task_group(struct task_group *tg)
> {
>        do {
>                tg = list_entry_rcu(tg->list.next,
>                                    typeof(struct task_group), list);
>        } while ((&tg->list != &task_groups) && (task_group_is_autogroup(tg)));
>        if (&tg->list == &task_groups)
>                tg = NULL;
>        return tg;
> }
>
> #define for_each_rt_rq(rt_rq, iter, rq) \
>        for (iter = container_of(&task_groups, typeof(*iter), list); \
>             (iter = next_task_group(iter)) && \
>             (rt_rq = iter->rt_rq[cpu_of(rq)]);)

Yeah, this works too, and it save some code.

Will update the patch based on it.

Thanks,
Yong



-- 
Only stand for myself
