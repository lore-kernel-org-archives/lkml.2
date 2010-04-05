Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab0DEOLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 10:11:07 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56711 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab0DEOK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 10:10:58 -0400
Message-ID: <4BB9EF3D.8040905@us.ibm.com>
Date: Mon, 05 Apr 2010 07:10:05 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: rostedt@goodmis.org, "lkml," <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Peter Morreale <pmorreale@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Chris Mason <chris.mason@oracle.com>,
       john cooper <john.cooper@third-harmonic.com>
Subject: Re: RFC: Ideal Adaptive Spinning Conditions
References: <4BB3D90C.3030108@us.ibm.com> <1270078689.19685.8040.camel@gandalf.stny.rr.com> <4BB40140.20109@us.ibm.com> <1270088753.19685.8218.camel@gandalf.stny.rr.com> <4BB7F05A.6010102@redhat.com>
In-Reply-To: <4BB7F05A.6010102@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On 03/31/2010 10:25 PM, Steven Rostedt wrote:
>> On Wed, 2010-03-31 at 19:13 -0700, Darren Hart wrote:
>>> Steven Rostedt wrote:
>>>> On Wed, 2010-03-31 at 16:21 -0700, Darren Hart wrote:
>>>>
>>>>> o What type of lock hold times do we expect to benefit?
>>>>
>>>> 0 (that's a zero) :-p
>>>>
>>>> I haven't seen your patches but you are not doing a heuristic approach,
>>>> are you? That is, do not "spin" hoping the lock will suddenly become
>>>> free. I was against that for -rt and I would be against that for futex
>>>> too.
>>>
>>> I'm not sure what you're getting at here. Adaptive spinning is indeed
>>> hoping the lock will become free while you are spinning and checking
>>> it's owner...
>>
>> I'm talking about the original idea people had of "lets spin for 50us
>> and hope it is unlocked before then", which I thought was not a good
>> idea.
> 
> Maybe not a good idea when running on bare metal, but it
> could be a big help when running virtualized.
> 
> A lock with a short hold time can, occasionally, have a
> very long hold time, when the VCPU holding the lock is
> preempted by the host/hypervisor.
> 
> An adaptive lock would spin-and-acquire if the lock holder
> is running, while turning into a sleep lock when the lock
> holder has been preempted.

Right, Steven was referring to a braindead 50us spin, regardless of the 
state of the owner. This is the kind of spinning userspace spinlocks 
currently implement because they have no information regarding the state 
of the owner. By adding adaptive spinning to the kernel, these userspace 
locks can make more intelligent spinning decisions.


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
