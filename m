Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310Ab1ERPUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:20:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39240 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933164Ab1ERPUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:20:39 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=9MPN8-DmjYcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=07d9gI8wAAAA:8 a=Qg6-wrgoqUaQF5U1cKEA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: change pull_rt_task() to decrease time waiting
 on runqueue
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <BANLkTingJ7s5SR+QWuE=_P5tcbuaB_bEwQ@mail.gmail.com>
References: <BANLkTintLhxVQvbmt6oJQ9Zbcmen7yL3ug@mail.gmail.com>
	 <1305725244.26849.13.camel@gandalf.stny.rr.com>
	 <BANLkTingJ7s5SR+QWuE=_P5tcbuaB_bEwQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 18 May 2011 11:20:37 -0400
Message-ID: <1305732037.11267.7.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 22:54 +0800, Hillf Danton wrote:

> In short, if there are pushable tasks and if there are RQs,
> NOT LIMITED TO our RQ, in lower priority, tasks should be pushed to
> RQs as many as we could.

I understand what you are trying to do. But this change modifies a lot
of assumptions. Please supply test cases that shows how this helps.

Have a look at:

http://lwn.net/Articles/425583/

Where I did a bit of work just to make sure my change to sched_rt.c was
appropriate. Just coming up with scenarios may not be good enough.
Seeing it in practice is worth much more.

For example, you may be making the fast path slower. This may do what
you expect, with a hit in performance. I'm not sure I like that idea.

-- Steve


