Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab0L1WfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 17:35:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046Ab0L1WfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 17:35:03 -0500
Message-ID: <4D1A6608.6040503@redhat.com>
Date: Tue, 28 Dec 2010 17:34:48 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Mike Galbraith <mgalbraith@suse.de>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
References: <20101213224434.7495edb2@annuminas.surriel.com>	 <20101213224657.7e141746@annuminas.surriel.com>	 <1292306896.7448.157.camel@marge.simson.net> <4D0A6D34.6070806@redhat.com>	 <1292569018.7772.75.camel@marge.simson.net>	 <1292570143.7772.84.camel@marge.simson.net>  <4D0F78DF.9010908@redhat.com>	 <1292861059.15207.7.camel@marge.simson.net> <1293515683.6930.16.camel@marge.simson.net>
In-Reply-To: <1293515683.6930.16.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2010 12:54 AM, Mike Galbraith wrote:
> On Mon, 2010-12-20 at 17:04 +0100, Mike Galbraith wrote:
>> On Mon, 2010-12-20 at 10:40 -0500, Rik van Riel wrote:
>>> On 12/17/2010 02:15 AM, Mike Galbraith wrote:
>>>
>>>> BTW, with this vruntime donation thingy, what prevents a task from
>>>> forking off accomplices who do nothing but wait for a wakeup and
>>>> yield_to(exploit)?
>>>>
>>>> Even swapping vruntimes in the same cfs_rq is dangerous as hell, because
>>>> one party is going backward.
>>>
>>> I just realized the answer to this question.
>>>
>>> We only give cpu time to tasks that are runnable, but not
>>> currently running.  That ensures one task cannot block others
>>> from running by having time yielded to it constantly.
>>
>> Hm.  Don't think that will 100% sure prevent clock stoppage, because the
>> running task doesn't necessarily advance min_vruntime.
>>
>> What about something like the below instead?  It compiles, but may eat
>> your first born child.
>
> (either it's christmas, or nobody cares to try it.  ho ho hum:)

It's christmas.

I've replaced my original patch with your patch in my
series, just haven't gotten around to running Avi's
latest test on it yet :)

-- 
All rights reversed
