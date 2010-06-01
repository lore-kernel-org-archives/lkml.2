Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab0FAQ55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 12:57:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015Ab0FAQ54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 12:57:56 -0400
Message-ID: <4C053ACC.5020708@redhat.com>
Date: Tue, 01 Jun 2010 19:52:28 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hpa@zytor.com, mingo@elte.hu, npiggin@suse.de,
       tglx@linutronix.de, mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
References: <20100601093515.GH24302@redhat.com> <87sk56ycka.fsf@basil.nowhere.org> <20100601162414.GA6191@redhat.com> <20100601163807.GA11880@basil.fritz.box>
In-Reply-To: <20100601163807.GA11880@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2010 07:38 PM, Andi Kleen wrote:
>>> Your new code would starve again, right?
>>>
>>>        
>> Yes, of course it may starve with unfair spinlock. Since vcpus are not
>> always running there is much smaller chance then vcpu on remote memory
>> node will starve forever. Old kernels with unfair spinlocks are running
>> fine in VMs on NUMA machines with various loads.
>>      
> Try it on a NUMA system with unfair memory.
>    

We are running everything on NUMA (since all modern machines are now 
NUMA).  At what scale do the issues become observable?

>> I understand that reason and do not propose to get back to old spinlock
>> on physical HW! But with virtualization performance hit is unbearable.
>>      
> Extreme unfairness can be unbearable too.
>    

Well, the question is what happens first.  In our experience, vcpu 
overcommit is a lot more painful.  People will never see the NUMA 
unfairness issue if they can't use kvm due to the vcpu overcommit problem.

What I'd like to see eventually is a short-term-unfair, long-term-fair 
spinlock.  Might make sense for bare metal as well.  But it won't be 
easy to write.

-- 
error compiling committee.c: too many arguments to function

