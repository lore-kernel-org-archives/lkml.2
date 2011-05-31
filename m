Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab1EaPID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:08:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61865 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab1EaPIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:08:02 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=tSUSzJW1ggAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=zU6T3fl3KpLVwlLNtQgA:9 a=PUjeQqilurYA:10 a=_RhRFcbxBZMA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: fix rt_nr_migratory corruption raised in
 push_rt_task()
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTi=YXK7pCJqei6oz4dzLzHgJC_m=2g@mail.gmail.com>
References: <BANLkTimfOsJ91_PJdB5-H02EGS0S5eJ5cA@mail.gmail.com>
	 <1306827397.7536.10.camel@marge.simson.net>
	 <BANLkTi=YXK7pCJqei6oz4dzLzHgJC_m=2g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 31 May 2011 11:08:00 -0400
Message-ID: <1306854480.11899.29.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 21:56 +0800, Hillf Danton wrote:
> On Tue, May 31, 2011 at 3:36 PM, Mike Galbraith <efault@gmx.de> wrote:
> > On Mon, 2011-05-30 at 21:39 +0800, Hillf Danton wrote:
> >> When pushing, if a pushable task could not be pushed, it is dequeued with no
> >> updating the rt_nr_migratory element of RT run-queue, then rt_nr_migratory is
> >> corrupted, which is fixed by removing the dequeue operation.
> >
> > Hm.  I think you're right that this dequeue_pushable_task() call can be
> > removed, at least I didn't see it's reason for existing.  I'd word it a
> > bit differently though, and not return 1 unless we really did push.
> >
> 
> Hi Mike
> 
> Your message shows what is called professional work, but something lost,
> 
> > From: Hillf Danton <dhillf@gmail.com>
> >
> > sched, rt: fix rq->rt.pushable_tasks bug in push_rt_task()
> >
> > Do not call dequeue_pushable_task() when failing to push an eligible
> > task, as it remains pushable, merely not at this particular moment.
> >
> > Signed-off-by: Hillf Danton <dhillf@gmail.com>
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> 

Yeah, Mike, can you remail this adding your SOB too. You can keep
Hillf's SOB as well, since both of you made changes.

Thanks!

-- Steve


