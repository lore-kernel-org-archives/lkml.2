Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab1DUNnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:43:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62321 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab1DUNnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:43:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dUpFKuODqhoJJHX+m1DeKo0A0q5nPoxFEcgZ09U42zuUX2SXoAmzadbEThglx4BKFc
         kV71os4k4UPalPYlcClXwmgiBR4YV7D/Thexkzlq15RN+6IRBViO2wLvY0bk+X727Z3X
         qrLNZIXr8pm0jon1JeBr4D5SAGYx28qGiVM4w=
Date: Thu, 21 Apr 2011 21:43:12 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: deduplicate mm checks in normalize_rt_tasks()
Message-ID: <20110421134312.GA3225@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <BANLkTi=41=2_QOMOabg1UrwQ2A06fJAY9w@mail.gmail.com>
 <20110421132904.GA2702@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110421132904.GA2702@zhy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 09:29:04PM +0800, Yong Zhang wrote:
> On Thu, Apr 21, 2011 at 09:15:56PM +0800, Hillf Danton wrote:
> > When normalizing realtime tasks, only user tasks are concerned by
> > checking their ->mm.
> > If the task is not realtime, the -mm is checked again, thus the
> > overwork could be removed.
> > 
> > Signed-off-by: Hillf Danton <dhillf@gmail.com>
> > ---
> > 
> > --- a/kernel/sched.c	2011-03-30 03:09:48.000000000 +0800
> > +++ b/kernel/sched.c	2011-04-21 20:59:28.000000000 +0800
> > @@ -8364,7 +8364,7 @@ void normalize_rt_tasks(void)
> >  			 * Renice negative nice level userspace
> >  			 * tasks back to 0:
> >  			 */
> > -			if (TASK_NICE(p) < 0 && p->mm)
> > +			if (TASK_NICE(p) < 0)
> 
> This looks good.
> 
> And we can also move TASK_NICE(p) < 0 to the upper if(),
> like:
> 		if (!rt_task(p) && TASK_NICE(p) < 0) {
> 			set_user_nice(p, 0);
> 			continue;
> 		}
> 
> to reduce one level if() to make code cleaner :)

Damm, I'm wrong here, just ignore it.

Yours is good.

Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>

> 
> Thanks,
> Yong
> 
> >  				set_user_nice(p, 0);
> >  			continue;
> >  		}
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
