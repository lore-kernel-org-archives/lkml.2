Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab1KYRDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 12:03:42 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:4165 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab1KYRDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 12:03:41 -0500
Message-ID: <4ECFCA5E.1020307@parallels.com>
Date: Fri, 25 Nov 2011 21:03:26 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Tejun Heo <tj@kernel.org>, Pedro Alves <pedro@codesourcery.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with	given
 pids
References: <201111221204.39235.pedro@codesourcery.com> <20111122153326.GD322@google.com> <201111231620.45440.pedro@codesourcery.com> <20111123162417.GE25780@google.com> <4ECD3946.1030503@parallels.com> <4ECD542C.7010705@parallels.com> <20111124173121.GA23260@redhat.com> <4ECF6AA0.80006@parallels.com> <20111125162220.GA17173@redhat.com> <4ECFC5E3.5090900@parallels.com> <20111125165409.GA19238@redhat.com>
In-Reply-To: <20111125165409.GA19238@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2011 08:54 PM, Oleg Nesterov wrote:
> On 11/25, Pavel Emelyanov wrote:
>>
>> On 11/25/2011 08:22 PM, Oleg Nesterov wrote:
>>> On 11/25, Pavel Emelyanov wrote:
>>>>
>>>> The proposal is to implement the PR_RESERVE_PID prctl which allocates and puts a
>>>> pid on the current. The subsequent fork() uses this pid,
>>>
>>> Oh. This is subjective, yes, but this doesn't clean to me.
>>>
>>> Amd why?? On the running system PR_RESERVE_PID can obviously fail anyway.
>>> It only helps to avoid the race with another fork.
>>
>> No. It can fail if you try to allocate a pid with given number. The API allows for
>> pid generation. AFAIU this can help with Pedro's requirements to resurrect task with
>> the same pid value it used to have before.
> 
> Yes gdb can do fork() in a row (until it unreserves the pid) and the
> pid will be the same.
> 
> OK, I misunderstood. I thought you insist that PR_RESERVE_PID itself
> is reliable.
> 
> But this can only work in the simplest case.

Yup!

> How you can restore the multithread tracee?

Don't know :) But if this approach sounds promising (I see, that now it's not, but...) I
can think more on it.

> You need to unreserve/reserve the previous pid, and we have the same problems again, no?

With the existing patch - yes, but as I said above - we need to decide which direction to
go and then I'll think further.

By now your opinion is to better stay where we are ;) but if moving is unavoidable, then
it's better to take the CLONE_CHILD_USEPIDS route. That's my position as well.

>>> Yes, and this task_struct->rsv_pid acts as implicit parameter for the
>>> next clone(). Doesn't look very nice to me. Plus the code complications.
>>
>> Well, the last_pid is also an implicit parameter for the next clone() with sysctl
>> approach :)
> 
> Yes. but it is already here ;)
> 
> Oleg.
