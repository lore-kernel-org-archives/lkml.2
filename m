Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab1EXOqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:46:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37822 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab1EXOqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:46:43 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=2hPWuqIl968A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=JfrnYn6hAAAA:8 a=Iv8w7zWnywEHlNDQWyEA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=3Rfx1nUSh_UA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: remove starvation in check_preempt_equal_prio()
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <BANLkTimynA+wdsEwayzdDZRTPeZHRoDtgg@mail.gmail.com>
References: <BANLkTinrHfVT43Evto3GqN8venDrLXoMbg@mail.gmail.com>
	 <1306244836.2497.60.camel@laptop>
	 <BANLkTik6cc+jA3Ft4wOTWPwKhOheUM-VbQ@mail.gmail.com>
	 <1306247058.1465.66.camel@gandalf.stny.rr.com>
	 <BANLkTimynA+wdsEwayzdDZRTPeZHRoDtgg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 24 May 2011 10:46:41 -0400
Message-ID: <1306248401.1465.69.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 22:33 +0800, Hillf Danton wrote:
> On Tue, May 24, 2011 at 10:24 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Tue, 2011-05-24 at 22:01 +0800, Hillf Danton wrote:
> >> On Tue, May 24, 2011 at 9:47 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> > On Tue, 2011-05-24 at 21:34 +0800, Hillf Danton wrote:
> >> >> If there are pushable tasks and they are high enough in priority, in which
> >> >> case task p is covered, the current could keep holding its CPU.
> >> >
> >> > -ENOPARSE..
> >> >
> >>
> >> Here the priority is same, then pushing task p off has little difference from
> >> pushing any other pushable.
> >
> > If task p is currently running and is a FIFO task, you do not push it
> > off for another task of same prio.
> >
> If it is one of the current principles in RT schedule, the patch has
> to be dropped.
> 

Yes, that is the definition of FIFO (First In First Out). The tasks that
get to the CPU first run till they voluntarily schedule away, or are
preempted by an even high priority task. Tasks of the same priority must
wait till the previous task has finished.

-- Steve


