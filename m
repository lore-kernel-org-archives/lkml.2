Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab2EXMZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 08:25:38 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:45254 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607Ab2EXMZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 08:25:37 -0400
Message-ID: <4FBE288F.8060802@linux.vnet.ibm.com>
Date: Thu, 24 May 2012 17:54:47 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@kernel.org, pjt@google.com, paul@paulmenage.org,
        akpm@linux-foundation.org, rjw@sisk.pl, nacc@us.ibm.com,
        rientjes@google.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v5 4/5] cpusets: Update tasks' cpus_allowed mask upon
 updates to root cpuset
References: <20120517165839.3011.98723.stgit@srivatsabhat.in.ibm.com> <20120517170055.3011.18690.stgit@srivatsabhat.in.ibm.com> <1337850827.9783.77.camel@laptop>  <4FBE02F3.3030809@linux.vnet.ibm.com> <1337860736.9783.123.camel@laptop>
In-Reply-To: <1337860736.9783.123.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052402-1618-0000-0000-000001AB62D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 05:28 PM, Peter Zijlstra wrote:

> On Thu, 2012-05-24 at 15:14 +0530, Srivatsa S. Bhat wrote:
> 
>> Sorry, my bad, I hadn't considered that. Thanks for pointing it out!
>>
>> So, I am wondering how we ought to deal with CPU hotplug for tasks attached
>> to the root cpuset..
> 
> By not doing anything at all. If a task is in the root set it is
> supposed to behave as it cpusets don't exist.
> 
>> Considering tasks attached to the root cpuset, if a cpu present in a task's
>> cpus_allowed mask goes offline, it should be removed from that mask right?
> 
> Nope, that shouldn't happen. We only reset the mask if all cpus in the
> affinity mask go away. This is where task affinity and cpusets differ.
> 
>> And if that cpu comes back online, it should not be put back to the task's
>> cpus_allowed mask (just like we don't put back cpus in non-root cpusets).
> 
> Online shouldn't ever change anything.
> 
>> Is the above understanding correct?
> 
> Nope.
> 
>> In the current kernel, during cpu hotplug, we don't touch cpus_allowed mask
>> of the tasks attached to the root cpuset at all.. Whereas we update the
>> cpus_allowed mask of tasks belonging to non-root cpusets, during cpu offline.
>>
>> So, is this differentiation intended?
> 
> Yes, although arguably the cpuset case is 'weird' in that it came later
> and didn't mirror the cpu affinity semantics.
> 
> Tasks aren't attached to the root cpuset, they live there because
> there's no other place to be when you don't use cpusets. This very much
> means that tasks in the root set should behave as if cpusets didn't
> exist.
> 


Ok, got it.. that logic makes sense. Thanks a lot for the explanation!
I will resubmit this patchset without patch 4/5 then, if you don't have any
other objections.

 

Regards,
Srivatsa S. Bhat

