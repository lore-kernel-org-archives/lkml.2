Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab2JADr3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 23:47:29 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37906 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab2JADr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 23:47:28 -0400
MIME-Version: 1.0
In-Reply-To: <20121001003233.GL10383@mtj.dyndns.org>
References: <cover.1348736069.git.viresh.kumar@linaro.org>
	<7d5c2cac08134446583624cc124d46d9726bdb2d.1348736069.git.viresh.kumar@linaro.org>
	<20120930085455.GJ10383@mtj.dyndns.org>
	<CAKohpon2xQxSqeOCTb=noki=QUH=Cf9Aggsd_uAv34TNfyC0FA@mail.gmail.com>
	<20121001003233.GL10383@mtj.dyndns.org>
Date: Mon, 1 Oct 2012 09:17:28 +0530
Message-ID: <CAKohpokdhtB0bx2xyoMXXTW2O499X_y4Yg_wmqKM82rxK2-u=Q@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] workqueue: Schedule work on non-idle cpu instead
 of current one
From: Viresh Kumar <viresh.kumar@linaro.org>
To: vincent.guittot@linaro.org, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, pjt@google.com, paul.mckenney@linaro.org,
        tglx@linutronix.de, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, linaro-dev@lists.linaro.org,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 October 2012 06:02, Tejun Heo <tj@kernel.org> wrote:
> It isn't about the CPU being actually idle?

No. Being idle only from scheduler's perspective. :)

> Also, if it's only about timers, shouldn't it be enough to implement
> it for timer and delayed_work?

What if we need a timer, which must re-arm itself + schedule a work?
delayed_work will not be sufficient in that case, and we would need
to use normal work.

If i am not wrong, there can be other future users of this routine too.
@Vincent: Can you please comment on this?

> It would be great if you explain what you're trying to achieve how.  I
> can't tell what you're aiming for and why that would be beneficial
> from these submissions.

Following slides are implemented by Vincent and presented during LPC.
Please have a look at them, they explain the problem statement well:

http://www.linuxplumbersconf.org/2012/wp-content/uploads/2012/08/lpc2012-sched-timer-workqueue.pdf

Specifically slides: 12 & 19.

There aren't too many users with this behavior, but even a single user
will be sufficient not to let the cpu get idle at all. And that will result in
less power saving.

--
viresh
