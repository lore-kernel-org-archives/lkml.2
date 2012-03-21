Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab2CUCMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 22:12:41 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:61685 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2CUCMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 22:12:40 -0400
Date: Wed, 21 Mar 2012 10:12:29 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Michael J. Wang" <mjwang@broadcom.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: [PATCH 1/1] scheduler: minor improvement to
 pick_next_highest_task_rt in linux-3.3
Message-ID: <20120321021229.GB19766@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <2EF88150C0EF2C43A218742ED384C1BC0FC83D6B@IRVEXCHMB08.corp.ad.broadcom.com>
 <20120321014050.GA19766@zhy>
 <2EF88150C0EF2C43A218742ED384C1BC0FC84327@IRVEXCHMB08.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <2EF88150C0EF2C43A218742ED384C1BC0FC84327@IRVEXCHMB08.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 01:56:47AM +0000, Michael J. Wang wrote:
> Ah, I see.  Forgot about the length of my comment line.
> 
> Should I reformat my patch and send it again?

It'll be better, and I think Peter/Ingo will happy with it.

Thanks,
Yong

> 
> Thanks,
> Michael
> 
> 
> -----Original Message-----
> From: Yong Zhang [mailto:yong.zhang0@gmail.com] 
> Sent: Tuesday, March 20, 2012 6:41 PM
> To: Michael J. Wang
> Cc: mingo@elte.hu; peterz@infradead.org; linux-kernel@vger.kernel.org; rostedt@goodmis.org
> Subject: Re: [PATCH 1/1] scheduler: minor improvement to pick_next_highest_task_rt in linux-3.3
> 
> On Mon, Mar 19, 2012 at 10:26:19PM +0000, Michael J. Wang wrote:
> > From: Michael J Wang <mjwang@broadcom.com>
> > 
> > Avoid extra work by continuing on to the next rt_rq if the highest prio task in current rt_rq is the same priority as our candidate task.
> > 
> > Signed-off-by: Michael J Wang <mjwang@broadcom.com>
> > 
> > ---
> > 
> > More detailed explanation:  if next is not NULL, then we have found a candidate task, and its priority is next->prio.  Now we are looking for an even higher priority task in the other rt_rq's.  idx is the highest priority in the current candidate rt_rq.  In the current 3.3 code, if idx is equal to next->prio, we would start scanning the tasks in that rt_rq and replace the current candidate task with a task from that rt_rq.  But the new task would only have a priority that is equal to our previous candidate task, so we have not advanced our goal of finding a higher prio task.  So we should avoid the extra work by continuing on to the next rt_rq if idx is equal to next->prio.
> > 
> 
> You should limit characters of each line to 80 if possible.
> 
> And before sending you patch, linux-source/scripts/checkpatch.pl maybe
> give you some clues whether there is some warning/error. If there are,
> fix them.
> 
> Only for what your patch wants to show:
> Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
> 
> Thanks,
> Yong
> 
> > --- linux-3.3/kernel/sched/rt.c.orig	2012-03-18 16:15:34.000000000 -0700
> > +++ linux-3.3/kernel/sched/rt.c	2012-03-19 14:52:54.585391702 -0700
> > @@ -1403,7 +1403,7 @@ static struct task_struct *pick_next_hig
> >  next_idx:
> >  		if (idx >= MAX_RT_PRIO)
> >  			continue;
> > -		if (next && next->prio < idx)
> > +		if (next && next->prio <= idx)
> >  			continue;
> >  		list_for_each_entry(rt_se, array->queue + idx, run_list) {
> >  			struct task_struct *p;
> > 
> > 
> > 
> > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> Only stand for myself
> 
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{����zX����ܨ}���Ơz�&j:+v�������zZ+��+zf���h���~����i���z��w���?����&�)ߢf��^jǫy�m��@A�a���0��h��i

-- 
Only stand for myself
