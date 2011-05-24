Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab1EXOWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:22:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38346 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab1EXOWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:22:35 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=2hPWuqIl968A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=9Tl7oIRomrfnsO-OJ7UA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: remove starvation in check_preempt_equal_prio()
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <BANLkTim0RtCjefq5Z2qbJFbBhrCHFfeGxg@mail.gmail.com>
References: <BANLkTinrHfVT43Evto3GqN8venDrLXoMbg@mail.gmail.com>
	 <1306244745.1465.62.camel@gandalf.stny.rr.com>
	 <BANLkTim0RtCjefq5Z2qbJFbBhrCHFfeGxg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 24 May 2011 10:22:33 -0400
Message-ID: <1306246953.1465.64.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 22:11 +0800, Hillf Danton wrote:
> On Tue, May 24, 2011 at 9:45 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Tue, 2011-05-24 at 21:34 +0800, Hillf Danton wrote:
> >> If there are pushable tasks and they are high enough in priority, in which
> >> case task p is covered, the current could keep holding its CPU.
> >>
> >> Even if current task has to release its CPU, requeuing task p could result in
> >> starvation of tasks that are of same priority and have been waiting on RQ for
> >> a couple of hours:/
> >
> > Can you explain this better? Sounds like you are describing the
> > definition of FIFO. You are *not* suppose to preempt a FIFO task just
> 
> I dont want to redefine FIFO, but starvation needs attention, since
> the woken task is already off RQ, and its position on RQ is reshuffled.

Does this happen because your other patch doesn't do the work at wake up
anymore? That is, you require a schedule of the high prio task?

There should be no starvation if the currently woken RT task can
migrate, as it should simply go to another rq.

-- Steve


