Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab1EXOBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:01:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34603 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab1EXOBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:01:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ioh3zxSScFj9jRNKJVEce//Cf4p7GIgXL3zPb0d3lu9SMWZCQP03HiwBoTEQdLZAqn
         /ERTEmzClyJcxPlbEmbyPY29s8uZmhs1g2wusMOs+8EREsHNRcZ2tk6yTkLKtPY1RYVo
         2bzFCyfVA6iSgaukfZYtMRk1ltSA9XaDySehQ=
MIME-Version: 1.0
In-Reply-To: <1306244836.2497.60.camel@laptop>
References: <BANLkTinrHfVT43Evto3GqN8venDrLXoMbg@mail.gmail.com>
	<1306244836.2497.60.camel@laptop>
Date: Tue, 24 May 2011 22:01:09 +0800
Message-ID: <BANLkTik6cc+jA3Ft4wOTWPwKhOheUM-VbQ@mail.gmail.com>
Subject: Re: [PATCH] sched: remove starvation in check_preempt_equal_prio()
From: Hillf Danton <dhillf@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 9:47 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2011-05-24 at 21:34 +0800, Hillf Danton wrote:
>> If there are pushable tasks and they are high enough in priority, in which
>> case task p is covered, the current could keep holding its CPU.
>
> -ENOPARSE..
>

Here the priority is same, then pushing task p off has little difference from
pushing any other pushable.

>> Even if current task has to release its CPU, requeuing task p could result in
>> starvation of tasks that are of same priority and have been waiting on RQ for
>> a couple of hours:/
>
> Starvation of the same priority tasks is a perfectly valid situation for
> SCHED_FIFO, also, your changelog fails to mention what you propose to do
> about it.
>
I did get curr requeued, and task_woken_rt() could do what I want.

If you change ENOPARSE to PARSE, I will change task_woken_rt accordingly.

thanks
          Hillf
