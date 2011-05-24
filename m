Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab1EXPEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:04:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38367 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab1EXPEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:04:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gW1gH5yjcz1uXHO3ykbjd7N6yRytLrc9f/tITrFhjmB3S5HLoM8K7+EeZbrVGSrdJw
         Ja1XpE96ePFv4gWdKOuV1mzD12+OzOdI+Fz+j7ngnM4x17ksFrjsHy3O+QrEbmygYCZ9
         rQn4XQWug39BxBUtWbwD0KExO8yHD9KlRXrvY=
MIME-Version: 1.0
In-Reply-To: <1306248401.1465.69.camel@gandalf.stny.rr.com>
References: <BANLkTinrHfVT43Evto3GqN8venDrLXoMbg@mail.gmail.com>
	<1306244836.2497.60.camel@laptop>
	<BANLkTik6cc+jA3Ft4wOTWPwKhOheUM-VbQ@mail.gmail.com>
	<1306247058.1465.66.camel@gandalf.stny.rr.com>
	<BANLkTimynA+wdsEwayzdDZRTPeZHRoDtgg@mail.gmail.com>
	<1306248401.1465.69.camel@gandalf.stny.rr.com>
Date: Tue, 24 May 2011 23:04:44 +0800
Message-ID: <BANLkTimFv59s1B4dPsrWQGdH+FO-omcXyA@mail.gmail.com>
Subject: Re: [PATCH] sched: remove starvation in check_preempt_equal_prio()
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 10:46 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-05-24 at 22:33 +0800, Hillf Danton wrote:
>> On Tue, May 24, 2011 at 10:24 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > On Tue, 2011-05-24 at 22:01 +0800, Hillf Danton wrote:
>> >> On Tue, May 24, 2011 at 9:47 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> >> > On Tue, 2011-05-24 at 21:34 +0800, Hillf Danton wrote:
>> >> >> If there are pushable tasks and they are high enough in priority, in which
>> >> >> case task p is covered, the current could keep holding its CPU.
>> >> >
>> >> > -ENOPARSE..
>> >> >
>> >>
>> >> Here the priority is same, then pushing task p off has little difference from
>> >> pushing any other pushable.
>> >
>> > If task p is currently running and is a FIFO task, you do not push it
>> > off for another task of same prio.
>> >
>> If it is one of the current principles in RT schedule, the patch has
>> to be dropped.
>>
>
> Yes, that is the definition of FIFO (First In First Out). The tasks that
> get to the CPU first run till they voluntarily schedule away, or are
> preempted by an even high priority task. Tasks of the same priority must
> wait till the previous task has finished.
>

Though I dont know who is the author of pusher, I like it, and the comments
related to it. The patch is a try to take advantage of pusher to
relive starvation
a bit, but failed.

thanks all comments.

Hillf
