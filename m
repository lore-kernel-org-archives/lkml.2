Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836Ab1CBDdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 22:33:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757639Ab1CBDdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 22:33:39 -0500
Message-ID: <4D6DBA7F.7010203@redhat.com>
Date: Tue, 01 Mar 2011 22:33:19 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Venkatesh Pallipadi <venki@google.com>
CC: Mike Galbraith <efault@gmx.de>, a.p.zijlstra@chello.nl, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [PATCH] sched: resched proper CPU on yield_to
References: <1298885189.9501.2.camel@marge.simson.net> <1299025701-22168-1-git-send-email-venki@google.com>
In-Reply-To: <1299025701-22168-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 07:28 PM, Venkatesh Pallipadi wrote:
> yield_to_task_fair() has code to resched the CPU of yielding task when the
> intention is to resched the CPU of the task that is being yielded to.
>
> Change here fixes the problem and also makes the resched conditional on
> rq != p_rq.

That would result in not rescheduling when current and p are
on the same runqueue, in effect making yield_to a noop for the
easiest case...

When rq != p_rq, we need to ensure both get rescheduled.

We want to have current not run right now (because it is waiting
on a resource that's not available), and we do want p to run.

I'm about to fall over, so I'll go to sleep now.

I can send a patch tomorrow morning, unless you beat me to it :)

-- 
All rights reversed
