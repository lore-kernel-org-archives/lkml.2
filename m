Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab1ADQol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:44:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab1ADQoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:44:39 -0500
Message-ID: <4D234E60.3010804@redhat.com>
Date: Tue, 04 Jan 2011 11:44:16 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
References: <20110103162637.29f23c40@annuminas.surriel.com>	<20110103162918.577a9620@annuminas.surriel.com> <AANLkTim1UFzHjBv52p7tyVyXerCVUVOBSAa3ajwQveuN@mail.gmail.com>
In-Reply-To: <AANLkTim1UFzHjBv52p7tyVyXerCVUVOBSAa3ajwQveuN@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 11:41 AM, Hillf Danton wrote:

> /*                       !curr->sched_class->yield_to_task ||        */
>
>> +                       curr->sched_class != p->sched_class) {
>> +               goto out;
>> +       }
>> +
> 	/*
>           * ask scheduler to compute the next for successfully kicking
> @p onto its CPU
>           * what if p_rq is rt_class to do?
>           */
> 	next = pick_next_task(p_rq);
> 	if (next != p)
> 		p->se.vruntime = next->se.vruntime -1;
> 	deactivate_task(p_rq, p, 0);
> 	activate_task(p_rq, p, 0);
> 	if (rq == p_rq)
> 		schedule();
> 	else
> 		resched_task(p_rq->curr);
> 	yield = 0;

Wouldn't that break for FIFO and RR tasks?

There's a reason all the scheduler folks wanted a
per-class yield_to_task function :)

-- 
All rights reversed
