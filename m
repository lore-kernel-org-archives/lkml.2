Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab1EaN4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:56:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33112 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab1EaN4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:56:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=puCWWzkcInm/Iwcpwt8pCEYrN4hrBQnnS12eZ6NKj+6sNfRiRa5lOmjb125SMt4pDN
         ubHVoPU7jMbqQp/aPxPZ9KyEfOurWjuVVauSQdzNmro2ympfucGt+ovrr5hw3wkt7Wui
         /y0BPqUEWzkX4DNPWs5E6JKNZgqcBZWS0K+gA=
MIME-Version: 1.0
In-Reply-To: <1306827397.7536.10.camel@marge.simson.net>
References: <BANLkTimfOsJ91_PJdB5-H02EGS0S5eJ5cA@mail.gmail.com>
	<1306827397.7536.10.camel@marge.simson.net>
Date: Tue, 31 May 2011 21:56:39 +0800
Message-ID: <BANLkTi=YXK7pCJqei6oz4dzLzHgJC_m=2g@mail.gmail.com>
Subject: Re: [PATCH] sched: fix rt_nr_migratory corruption raised in push_rt_task()
From: Hillf Danton <dhillf@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 3:36 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Mon, 2011-05-30 at 21:39 +0800, Hillf Danton wrote:
>> When pushing, if a pushable task could not be pushed, it is dequeued with no
>> updating the rt_nr_migratory element of RT run-queue, then rt_nr_migratory is
>> corrupted, which is fixed by removing the dequeue operation.
>
> Hm.  I think you're right that this dequeue_pushable_task() call can be
> removed, at least I didn't see it's reason for existing.  I'd word it a
> bit differently though, and not return 1 unless we really did push.
>

Hi Mike

Your message shows what is called professional work, but something lost,

> From: Hillf Danton <dhillf@gmail.com>
>
> sched, rt: fix rq->rt.pushable_tasks bug in push_rt_task()
>
> Do not call dequeue_pushable_task() when failing to push an eligible
> task, as it remains pushable, merely not at this particular moment.
>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Signed-off-by: Mike Galbraith <efault@gmx.de>

right?

> ---
>  kernel/sched_rt.c |   15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> Index: linux-2.6.40.git/kernel/sched_rt.c
> ===================================================================

And how to drive git to print the above two lines?

thanks
            Hillf
