Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab0DDBuy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 21:50:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab0DDBur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 21:50:47 -0400
Message-ID: <4BB7F05A.6010102@redhat.com>
Date: Sat, 03 Apr 2010 21:50:18 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Darren Hart <dvhltc@us.ibm.com>, "lkml," <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Peter Morreale <pmorreale@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Chris Mason <chris.mason@oracle.com>,
       john cooper <john.cooper@third-harmonic.com>
Subject: Re: RFC: Ideal Adaptive Spinning Conditions
References: <4BB3D90C.3030108@us.ibm.com>	 <1270078689.19685.8040.camel@gandalf.stny.rr.com>	 <4BB40140.20109@us.ibm.com> <1270088753.19685.8218.camel@gandalf.stny.rr.com>
In-Reply-To: <1270088753.19685.8218.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 10:25 PM, Steven Rostedt wrote:
> On Wed, 2010-03-31 at 19:13 -0700, Darren Hart wrote:
>> Steven Rostedt wrote:
>>> On Wed, 2010-03-31 at 16:21 -0700, Darren Hart wrote:
>>>
>>>> o What type of lock hold times do we expect to benefit?
>>>
>>> 0 (that's a zero) :-p
>>>
>>> I haven't seen your patches but you are not doing a heuristic approach,
>>> are you? That is, do not "spin" hoping the lock will suddenly become
>>> free. I was against that for -rt and I would be against that for futex
>>> too.
>>
>> I'm not sure what you're getting at here. Adaptive spinning is indeed
>> hoping the lock will become free while you are spinning and checking
>> it's owner...
>
> I'm talking about the original idea people had of "lets spin for 50us
> and hope it is unlocked before then", which I thought was not a good
> idea.

Maybe not a good idea when running on bare metal, but it
could be a big help when running virtualized.

A lock with a short hold time can, occasionally, have a
very long hold time, when the VCPU holding the lock is
preempted by the host/hypervisor.

An adaptive lock would spin-and-acquire if the lock holder
is running, while turning into a sleep lock when the lock
holder has been preempted.

