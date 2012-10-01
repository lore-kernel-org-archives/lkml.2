Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab2JAJMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 05:12:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45485 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab2JAJMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 05:12:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokdhtB0bx2xyoMXXTW2O499X_y4Yg_wmqKM82rxK2-u=Q@mail.gmail.com>
References: <cover.1348736069.git.viresh.kumar@linaro.org>
	<7d5c2cac08134446583624cc124d46d9726bdb2d.1348736069.git.viresh.kumar@linaro.org>
	<20120930085455.GJ10383@mtj.dyndns.org>
	<CAKohpon2xQxSqeOCTb=noki=QUH=Cf9Aggsd_uAv34TNfyC0FA@mail.gmail.com>
	<20121001003233.GL10383@mtj.dyndns.org>
	<CAKohpokdhtB0bx2xyoMXXTW2O499X_y4Yg_wmqKM82rxK2-u=Q@mail.gmail.com>
Date: Mon, 1 Oct 2012 11:12:17 +0200
Message-ID: <CAKfTPtAfGsbsH9WmjvcXSUjHPaF=Pyx+wnx6_XegW0k1bB9HtQ@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] workqueue: Schedule work on non-idle cpu instead
 of current one
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, pjt@google.com,
        paul.mckenney@linaro.org, tglx@linutronix.de,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Arvind.Chauhan@arm.com, amit.kucheria@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 October 2012 05:47, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 1 October 2012 06:02, Tejun Heo <tj@kernel.org> wrote:
>> It isn't about the CPU being actually idle?
>
> No. Being idle only from scheduler's perspective. :)
>
>> Also, if it's only about timers, shouldn't it be enough to implement
>> it for timer and delayed_work?
>
> What if we need a timer, which must re-arm itself + schedule a work?
> delayed_work will not be sufficient in that case, and we would need
> to use normal work.
>
> If i am not wrong, there can be other future users of this routine too.
> @Vincent: Can you please comment on this?

The goal is to consolidate the place, where the selection of a target
CPU for running something is done. The scheduler should select the CPU
in order to have coherent behaviour of all framework.

A delayed work can be delayed for a long period and the target CPU
that have been selected for the timer could not be the best place to
queue a work any more.

The goal is to be able to migrate a work if the scheduler thinks that'
is necessary.

Vincent

>
>> It would be great if you explain what you're trying to achieve how.  I
>> can't tell what you're aiming for and why that would be beneficial
>> from these submissions.
>
> Following slides are implemented by Vincent and presented during LPC.
> Please have a look at them, they explain the problem statement well:
>
> http://www.linuxplumbersconf.org/2012/wp-content/uploads/2012/08/lpc2012-sched-timer-workqueue.pdf
>
> Specifically slides: 12 & 19.
>
> There aren't too many users with this behavior, but even a single user
> will be sufficient not to let the cpu get idle at all. And that will result in
> less power saving.
>
> --
> viresh
