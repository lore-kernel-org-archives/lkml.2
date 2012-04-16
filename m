Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab2DPPvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:51:24 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58713 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab2DPPvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:51:23 -0400
MIME-Version: 1.0
In-Reply-To: <1334178222.23924.304.camel@gandalf.stny.rr.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	<1333696481-3433-12-git-send-email-juri.lelli@gmail.com>
	<1334178222.23924.304.camel@gandalf.stny.rr.com>
Date: Mon, 16 Apr 2012 17:51:22 +0200
Message-ID: <CAA7rmPGcnXhPUWLWCUS7spy3Grv=aE1Mng=DfD=XM7-GNDyX_w@mail.gmail.com>
Subject: Re: [PATCH 11/16] sched: add latency tracing for -deadline tasks.
From: Daniel Vacek <neelx.g@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, cfriesen@nortel.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        raistlin@linux.it
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 11, 2012 at 23:03, Steven Rostedt <rostedt@goodmis.org> wrote:
>> +     /*
>> +      * Semantic is like this:
>> +      *  - wakeup tracer handles all tasks in the system, independently
>> +      *    from their scheduling class;
>> +      *  - wakeup_rt tracer handles tasks belonging to sched_dl and
>> +      *    sched_rt class;
>> +      *  - wakeup_dl handles tasks belonging to sched_dl class only.
>> +      */
>> +     if ((wakeup_dl && !dl_task(p)) ||
>> +         (wakeup_rt && !dl_task(p) && !rt_task(p)) ||
>> +         (p->prio >= wakeup_prio || p->prio >= current->prio))
>>               return;
>
> Anyway, perhaps this should be broken up, as we don't want the double
> test, that is, wakeup_rt and wakeup_dl are both checked. Perhaps do:
>
>        if (wakeup_dl && !dl_task(p))
>                return;
>        else if (wakeup_rt && !dl_task(p) && !rt_task(p))
>                return;
>
>        if (p->prio >= wakeup_prio || p->prio >= current->prio)
>                return;
>
>
> -- Steve

sorry for the question, I'm obviously missing something here but what
is the logic behind this rewrite? In both cases my gcc generates the
same code for me.

nX
