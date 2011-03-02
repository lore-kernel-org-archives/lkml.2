Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab1CBDhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 22:37:16 -0500
Received: from smtp-out.google.com ([74.125.121.67]:27411 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab1CBDhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 22:37:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ZrZ75XXtYsi0yVvWi65Ytqhs+CYFi3+nekOTxflCFpxdkVyXT5UCVlZ3NUSDadsB6/
         rTwTr8zMHqXtnLkTgtFA==
MIME-Version: 1.0
In-Reply-To: <4D6DBA7F.7010203@redhat.com>
References: <1298885189.9501.2.camel@marge.simson.net>
	<1299025701-22168-1-git-send-email-venki@google.com>
	<4D6DBA7F.7010203@redhat.com>
Date: Tue, 1 Mar 2011 19:37:07 -0800
Message-ID: <AANLkTikL28vknFkp1NBkqQq3wpZK8A-C5WABKiYsqR2o@mail.gmail.com>
Subject: Re: [PATCH] sched: resched proper CPU on yield_to
From: Venkatesh Pallipadi <venki@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>, a.p.zijlstra@chello.nl, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 1, 2011 at 7:33 PM, Rik van Riel <riel@redhat.com> wrote:
> On 03/01/2011 07:28 PM, Venkatesh Pallipadi wrote:
>>
>> yield_to_task_fair() has code to resched the CPU of yielding task when the
>> intention is to resched the CPU of the task that is being yielded to.
>>
>> Change here fixes the problem and also makes the resched conditional on
>> rq != p_rq.
>
> That would result in not rescheduling when current and p are
> on the same runqueue, in effect making yield_to a noop for the
> easiest case...
>
> When rq != p_rq, we need to ensure both get rescheduled.
>

Yes. There is a schedule() right after this change which should take
care or resched on current CPU. Thats the reason I thought of skipping
resched on current CPU. No?

Thanks,
Venki

> We want to have current not run right now (because it is waiting
> on a resource that's not available), and we do want p to run.
>
> I'm about to fall over, so I'll go to sleep now.
>
> I can send a patch tomorrow morning, unless you beat me to it :)
>
> --
> All rights reversed
>
