Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242Ab1EROqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 10:46:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38657 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab1EROqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 10:46:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IbwEhCuhAtKkRMSGjoV8bt0iD04jZQESoP3PgpEE26+3s2OvHdQ7m+T6moOeJXQ2hc
         wmaRZXkHnFN8bG4p9DC0Nqc+nR9+70cDOW7JsDr6Sh1GZKNAvFKZfgYeT1HfbbxEDp7z
         mEQwXJ2Ml13OfOk5j/0t3KoyfZ5aT685iyZ3o=
MIME-Version: 1.0
In-Reply-To: <1305725044.26849.11.camel@gandalf.stny.rr.com>
References: <BANLkTikkeR_yf1HGhgq7WEO-kEvDGkV_tw@mail.gmail.com>
	<BANLkTim4n-WA_6nJpg4Nd99yuc3f+VWkcw@mail.gmail.com>
	<BANLkTikOecxhb8pZfAd19FLrPAPY4zacDQ@mail.gmail.com>
	<20110512120606.GA3639@zhy>
	<20110518013842.GD23940@home.goodmis.org>
	<BANLkTikOW9t6F8jvTJ0uPvyYDy+mpXh-DA@mail.gmail.com>
	<BANLkTikMdAG4HFmhiB9c3x97FH0N3PnpHA@mail.gmail.com>
	<1305725044.26849.11.camel@gandalf.stny.rr.com>
Date: Wed, 18 May 2011 22:46:19 +0800
Message-ID: <BANLkTinzsjTy6yA7N-ssy5beyJn5NQZX3w@mail.gmail.com>
Subject: Re: [PATCH] sched: correct how RT task is picked
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 9:24 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2011-05-18 at 21:19 +0800, Hillf Danton wrote:
>
>> Hi all
>>
>> The patch is prepared again, in which tests for both cpu and
>> nr_cpus_allowed are dropped.
>>
>> The reason to drop nr_cpus_allowed is to make sure that the
>> returned value is correct for both case that cpu == rq->cpu and
>> case that cpu != rq->cpu.
>
> -ENOPARSE
>
> Why would we pick a task that can't migrate?
>
Hi Steven

For migration, it is the case that cpu != rq->cpu, and
if cpu is allowed by task's affinity, it is bug that task
could not goto cpu because of nr_cpus_allowed since
the nr_cpus_allowed is computed based on the cpus_allowed mask.

Hillf
