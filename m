Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab2KZTYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:24:12 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58785 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab2KZTYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:24:10 -0500
MIME-Version: 1.0
In-Reply-To: <1353956163.6276.46.camel@gandalf.local.home>
References: <1353680484-7302-1-git-send-email-fweisbec@gmail.com>
	<1353680484-7302-3-git-send-email-fweisbec@gmail.com>
	<1353956163.6276.46.camel@gandalf.local.home>
Date: Mon, 26 Nov 2012 20:24:09 +0100
Message-ID: <CAFTL4hxxE8Ggw4Ae-VfgBZ8rtoOMpUQnmSGUado1gxeruwQ9rg@mail.gmail.com>
Subject: Re: [PATCH 2/3] cputime: Rename thread_group_times to thread_group_cputime_adjusted
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/26 Steven Rostedt <rostedt@goodmis.org>:
> On Fri, 2012-11-23 at 15:21 +0100, Frederic Weisbecker wrote:
>> We have thread_group_cputime() and thread_group_times(). The naming
>> doesn't provide enough information about the difference between
>> these two APIs.
>>
>> To lower the confusion, rename thread_group_times() to
>> thread_group_cputime_adjusted(). This name better suggests that
>> it's a version of thread_group_cputime() that does some stabilization
>> on the raw cputime values. ie here: scale on top of CFS runtime
>> stats and bound lower value for monotonicity.
>
> But, thread_group_times() does not do any type of adjustment. It only
> retrieves the cpu times:
>
> void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
> {
>         struct task_cputime cputime;
>
>         thread_group_cputime(p, &cputime);
>
>         *ut = cputime.utime;
>         *st = cputime.stime;
> }

This is the CONFIG_VIRT_CPU_ACCOUNTING only version. It also needs
some monotonicity guard IMO but that's another issue.
But please look at the other version.

> It retrieves the current times, it doesn't adjust them.
>
> I'm thinking the current name is more accurate.
