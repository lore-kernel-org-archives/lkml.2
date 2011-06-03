Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab1FCOwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:52:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48311 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab1FCOwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:52:06 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=IEGT9Ul9ajIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ru1FFUzAhsLsvu-K_swA:9 a=KGyGdDiVDxQuZ_lhCzIA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: fix conflict of schedule domain balance in RT
 scheduling
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTim-tr+LAg1pA-wEFvVGiCvOYdfDoQ@mail.gmail.com>
References: <BANLkTikoVj42S1iBHU_xFEpuGxY+TqmweA@mail.gmail.com>
	 <1307110767.3667.51.camel@gandalf.stny.rr.com>
	 <BANLkTim-tr+LAg1pA-wEFvVGiCvOYdfDoQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 03 Jun 2011 10:52:04 -0400
Message-ID: <1307112724.3667.58.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 22:30 +0800, Hillf Danton wrote:

> I note the comment related to cache-hot, it is fine for woken task even though
> cache-hot is considered to be nop for RT task,

I would not say cache-hot is a nop for RT tasks. Although RT tasks
should not depend on cache being hot, we don't want to go out of our way
to hurt RT tasks.


>  but what dose it help pushing
> RT tasks waiting on RQ?

What the lowest_mask returns is a mask of all cpus with the lowest
priority. Due to the double_lock_balance() we could have unlocked the rq
lock, and things could have changed. Thus, the current CPU could have
lowered its priority. Unlikely to be the case, but can happen.

If the lowest_mask has the task's CPU set, why push this RT task
somewhere else? Most likely the current CPU will not be set, but lets
not punish the RT task if it is.

-- Steve



