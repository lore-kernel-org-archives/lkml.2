Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab2LWM3y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 07:29:54 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:41969 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab2LWM3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 07:29:51 -0500
MIME-Version: 1.0
In-Reply-To: <871uekf20w.fsf@sejong.aot.lge.com>
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
	<1355127754-8444-9-git-send-email-alex.shi@intel.com>
	<50C80ADF.8050504@linux.vnet.ibm.com>
	<50C823A4.109@intel.com>
	<871uekf20w.fsf@sejong.aot.lge.com>
Date: Sun, 23 Dec 2012 20:29:50 +0800
Message-ID: <CAGjg+kG+0zu25LbvtiraBnn8ks27t8MXeFvgO-NQk18YN30S=A@mail.gmail.com>
Subject: Re: [PATCH 08/18] sched: consider runnable load average in move_tasks
From: Alex Shi <lkml.alex@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Alex Shi <alex.shi@intel.com>, Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 12:43 PM, Namhyung Kim <namhyung@kernel.org> wrote:
> On Wed, 12 Dec 2012 14:26:44 +0800, Alex Shi wrote:
>> On 12/12/2012 12:41 PM, Preeti U Murthy wrote:
>>> Also why can't p->se.load_avg_contrib be used directly? as a return
>>> value for task_h_load_avg? since this is already updated in
>>> update_task_entity_contrib and update_group_entity_contrib.
>>
>> No, only non task entity goes to  update_group_entity_contrib. not task
>> entity.
>
> ???
>
> But task entity goes to __update_task_entity_contrib()?

yes, but if the task is in a task_group, its load weight need to
reweight with its task_group's fraction.
can not use direct load weight in balancing calculation, so in
move_tasks, it uses task_h_load.
>
>
> /* Compute the current contribution to load_avg by se, return any delta */
> static long __update_entity_load_avg_contrib(struct sched_entity *se)
> {
>         long old_contrib = se->avg.load_avg_contrib;
>
>         if (entity_is_task(se)) {
>                 __update_task_entity_contrib(se);
>         } else {
>                 __update_tg_runnable_avg(&se->avg, group_cfs_rq(se));
>                 __update_group_entity_contrib(se);
>         }
>
>         return se->avg.load_avg_contrib - old_contrib;
> }
>
>
> Thanks,
> Namhyung
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks
    Alex
