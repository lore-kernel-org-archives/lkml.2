Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030597Ab2CUB5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 21:57:30 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3023 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603Ab2CUB5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 21:57:01 -0400
X-Server-Uuid: B730DE51-FC43-4C83-941F-F1F78A914BDD
From: "Michael J. Wang" <mjwang@broadcom.com>
To: "Yong Zhang" <yong.zhang0@gmail.com>
cc: "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Michael J. Wang" <mjwang@broadcom.com>
Subject: RE: [PATCH 1/1] scheduler: minor improvement to
 pick_next_highest_task_rt in linux-3.3
Thread-Topic: [PATCH 1/1] scheduler: minor improvement to
 pick_next_highest_task_rt in linux-3.3
Thread-Index: Ac0GHwijHkYM9zt3RLiiFsMKptWd3QBH0jYAAA4wyTA=
Date: Wed, 21 Mar 2012 01:56:47 +0000
Message-ID: <2EF88150C0EF2C43A218742ED384C1BC0FC84327@IRVEXCHMB08.corp.ad.broadcom.com>
References: <2EF88150C0EF2C43A218742ED384C1BC0FC83D6B@IRVEXCHMB08.corp.ad.broadcom.com>
 <20120321014050.GA19766@zhy>
In-Reply-To: <20120321014050.GA19766@zhy>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.161.125]
MIME-Version: 1.0
X-WSS-ID: 6377E8053E07168078-01-01
Content-Type: text/plain;
 charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2L1vhxd006970

Ah, I see.  Forgot about the length of my comment line.

Should I reformat my patch and send it again?

Thanks,
Michael


-----Original Message-----
From: Yong Zhang [mailto:yong.zhang0@gmail.com] 
Sent: Tuesday, March 20, 2012 6:41 PM
To: Michael J. Wang
Cc: mingo@elte.hu; peterz@infradead.org; linux-kernel@vger.kernel.org; rostedt@goodmis.org
Subject: Re: [PATCH 1/1] scheduler: minor improvement to pick_next_highest_task_rt in linux-3.3

On Mon, Mar 19, 2012 at 10:26:19PM +0000, Michael J. Wang wrote:
> From: Michael J Wang <mjwang@broadcom.com>
> 
> Avoid extra work by continuing on to the next rt_rq if the highest prio task in current rt_rq is the same priority as our candidate task.
> 
> Signed-off-by: Michael J Wang <mjwang@broadcom.com>
> 
> ---
> 
> More detailed explanation:  if next is not NULL, then we have found a candidate task, and its priority is next->prio.  Now we are looking for an even higher priority task in the other rt_rq's.  idx is the highest priority in the current candidate rt_rq.  In the current 3.3 code, if idx is equal to next->prio, we would start scanning the tasks in that rt_rq and replace the current candidate task with a task from that rt_rq.  But the new task would only have a priority that is equal to our previous candidate task, so we have not advanced our goal of finding a higher prio task.  So we should avoid the extra work by continuing on to the next rt_rq if idx is equal to next->prio.
> 

You should limit characters of each line to 80 if possible.

And before sending you patch, linux-source/scripts/checkpatch.pl maybe
give you some clues whether there is some warning/error. If there are,
fix them.

Only for what your patch wants to show:
Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>

Thanks,
Yong

> --- linux-3.3/kernel/sched/rt.c.orig	2012-03-18 16:15:34.000000000 -0700
> +++ linux-3.3/kernel/sched/rt.c	2012-03-19 14:52:54.585391702 -0700
> @@ -1403,7 +1403,7 @@ static struct task_struct *pick_next_hig
>  next_idx:
>  		if (idx >= MAX_RT_PRIO)
>  			continue;
> -		if (next && next->prio < idx)
> +		if (next && next->prio <= idx)
>  			continue;
>  		list_for_each_entry(rt_se, array->queue + idx, run_list) {
>  			struct task_struct *p;
> 
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
