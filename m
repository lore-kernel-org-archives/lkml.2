Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab1FIMe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 08:34:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55736 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab1FIMeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:34:25 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=cWu3orRm09UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=rQQHXOjxP4oWyp9PBsUA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: remove resetting exec_start in
 put_prev_task_rt()
From: Steven Rostedt <rostedt@goodmis.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTikoO5F5H4sEUoDPKX3qiahuehp=Mg@mail.gmail.com>
References: <BANLkTimqWD=q6YnSDi-v9y=LMWecgEzEWg@mail.gmail.com>
	 <BANLkTikoO5F5H4sEUoDPKX3qiahuehp=Mg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 09 Jun 2011 08:34:23 -0400
Message-ID: <1307622863.9218.40.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-02 at 16:04 +0800, Yong Zhang wrote:
> On Wed, Jun 1, 2011 at 10:03 PM, Hillf Danton <dhillf@gmail.com> wrote:
> > Resetting exec_start, after updated in update_curr_rt(), could open window for
> > messing up the subsequent computations of delta_exec of the given task.
> 
> I can't see how could this happen. what kind of 'subsequent computations'
> do you mean?

I still don't see a race.

Hilf, if you still believe there's a race here, can you explain it in
detail. Do something like:

	CPU0			CPU1
	----			----
   do_something;
				does_something_not_expected;
   continue_something;

Obviously changing what those "somethings" are. That way we can visually
see what you are trying to say.

> 
> But because exec_start will be reset by _pick_next_task_rt()/set_curr_task_rt(),
> you patch is ok. IMHO it is not critical, it's just cleanup instead.

I disagree. Yes the exec_start is reset there, but I like the fact that
it's 0 when not running.

-- Steve


