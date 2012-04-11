Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177Ab2DKQJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:09:16 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61649 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759964Ab2DKQJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:09:14 -0400
Message-ID: <4F85ACA5.1050902@gmail.com>
Date: Wed, 11 Apr 2012 18:09:09 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Hillf Danton <dhillf@gmail.com>, peterz@infradead.org, tglx@linutronix.de,
        mingo@redhat.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, Fabio Checconi <fchecconi@gmail.com>,
        Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>,
        Dhaval Giani <dhaval.giani@gmail.com>, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, Dario Faggioli <raistlin@linux.it>,
        Insop Song <insop.song@ericsson.com>, liming.wang@windriver.com
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>  <1333696481-3433-7-git-send-email-juri.lelli@gmail.com>  <CAJd=RBBm8yDBrZFj48tP_5WsG=z0Rsv_=j=kArV1Mj6yJvQjVA@mail.gmail.com>  <4F7F285A.1010703@gmail.com>  <CAJd=RBC13JUuX0gtQidpNc=T+pnPgtKVQwRsP-mPQeiyfd9fPA@mail.gmail.com>  <4F81F2F1.8010105@gmail.com> <1334160026.23924.255.camel@gandalf.stny.rr.com>
In-Reply-To: <1334160026.23924.255.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 06:00 PM, Steven Rostedt wrote:
> On Sun, 2012-04-08 at 22:20 +0200, Juri Lelli wrote:
>>>
>>>>>> +#ifdef CONFIG_SMP
>>>>>> +       /*
>>>>>> +        * In the unlikely case current and p have the same deadline
>>>>>> +        * let us try to decide what's the best thing to do...
>>>>>> +        */
>>>>>> +       if ((s64)(p->dl.deadline - rq->curr->dl.deadline) == 0&&
>>>>>> +           !need_resched())
>>>>>
>>>>> please recheck !need_resched(), say rq->curr need reschedule?
>>>>
>>>> Sorry, I don't get this..
>>>>
>>> Perhaps smp_processor_id() != rq->cpu
>>>
>>
>> need_resched is actually checked...
>>
>
> I guess what Hillf is trying to say is,
>
> s/!need_resched()/!test_tsk_need_resched(rq->curr)/
>

Yep, I finally got (and changed) it ;-).

Thanks,

- Juri
