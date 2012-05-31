Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab2EaKst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 06:48:49 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:51743 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab2EaKss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 06:48:48 -0400
X-ASG-Debug-ID: 1338461327-03d6a5031234270001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4FC74C59.2030100@fusionio.com>
Date: Thu, 31 May 2012 12:47:53 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] block: avoid infinite loop in get_task_io_context()
References: <4FC6189B.9080909@fusionio.com>  <1338402812.2760.413.camel@edumazet-glaptop>  <4FC66D3D.6080509@fusionio.com>  <1338404902.2760.451.camel@edumazet-glaptop>  <1338410107.2760.544.camel@edumazet-glaptop> <1338460706.2760.1330.camel@edumazet-glaptop>
X-ASG-Orig-Subj: Re: [PATCH] block: avoid infinite loop in get_task_io_context()
In-Reply-To: <1338460706.2760.1330.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1338461327
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.98524
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 12:38 PM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> On Wed, 2012-05-30 at 22:35 +0200, Eric Dumazet wrote:
>> On Wed, 2012-05-30 at 21:08 +0200, Eric Dumazet wrote:
>>> On Wed, 2012-05-30 at 20:55 +0200, Jens Axboe wrote:
>>>> On 05/30/2012 08:33 PM, Eric Dumazet wrote:
>>>>> On Wed, 2012-05-30 at 14:54 +0200, Jens Axboe wrote:
>>>>>> Hi Linus,
>>>>>>
>>>>>> On top of the for-3.5/core pull request, here are the driver related
>>>>>> changes for 3.5. It contains:
>>>>>
>>>>> Hi Jens
>>>>>
>>>>> Not sure if this is related, but latest Linus tree cannot boot anymore
>>>>> here...
>>>>>
>>>>> BUG: soft lockup - CPU#3 stuck for 22s ! [mountall.1603]
>>>>
>>>> Hrmpf, can you attach your .config?
>>>>
>>>
>>> I can do a bisection pretty fast I think
>>
>> Not sure if bisection was good, but result is :
> 
> Bisection gave nothing, because its an old bug ?
> 
> Following patch cures it.
> 
> [PATCH] block: avoid infinite loop in get_task_io_context()
> 
> Calling get_task_io_context() on a exiting task which isn't %current can
> loop forever. This triggers at boot time on my dev machine.
> 
> BUG: soft lockup - CPU#3 stuck for 22s ! [mountall.1603]

Eric, do you have a task trace to go with this lockup, where task !=
current?

In any case, it is a legit bug fix. I have applied it.

-- 
Jens Axboe

