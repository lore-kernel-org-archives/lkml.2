Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab0ITRlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 13:41:08 -0400
Received: from smtp-out.google.com ([74.125.121.35]:51509 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0ITRlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 13:41:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iAWAidohkPdPBsgl7p+frFZTQ1MqB9D4b8XuMFIrw3v/fFARLRm3RhZgrtJrnIgQgs
         MXESy2ZDXeYStqeUfQ6Q==
MIME-Version: 1.0
In-Reply-To: <1285004306.2275.764.camel@laptop>
References: <1284688596-6731-1-git-send-email-venki@google.com>
	<1284688596-6731-5-git-send-email-venki@google.com>
	<1284895730.2275.625.camel@laptop>
	<AANLkTimgQf=SO0rRotuzNsvN9xYrc2jJ5eDVZb2FxJRK@mail.gmail.com>
	<1285004306.2275.764.camel@laptop>
Date: Mon, 20 Sep 2010 10:40:52 -0700
Message-ID: <AANLkTinOJyo16O7MWKCFae0FDTB5s0d+HrodtzQiOUE2@mail.gmail.com>
Subject: Re: [PATCH 4/6] sched: Do not account irq time to current task
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 10:38 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-09-20 at 10:33 -0700, Venkatesh Pallipadi wrote:
>> Yes. I like your idea of having separate rq->clock and rq->clock_task.
>> That will clean up this code a bit.
>> We will still need to keep track of "last accounted irq time" at the
>> task or rq level to account sched_rt_avg_update correctly. But, I dont
>> have to play with cfs_rq and rt_rq as in this patch though.
>
> Ah, indeed. Ok so have rq->clock, rq->clock_task and have a
> irq_time_stamp to fold stuff into sched_rt_avg_update(), then I think
> you can isolate all the clock bits to update_rq_clock() and then use
> ->clock_task in update_curr{,_rt}().
>
>

OK. Thanks for all the feedback. Will have a newer cleaner version of
this soon...

Thanks,
Venki
