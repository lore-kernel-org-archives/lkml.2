Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab1AGDKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 22:10:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755152Ab1AGDKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 22:10:19 -0500
Message-ID: <4D268415.5030808@redhat.com>
Date: Thu, 06 Jan 2011 17:10:13 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [KVM TSC trapping / migration 1/2] Add TSC trapping for SVM and
 VMX
References: <1294308645-31113-1-git-send-email-zamsden@redhat.com> <1294308645-31113-2-git-send-email-zamsden@redhat.com> <9EEA19E7-668A-4CD0-B006-6B494D9FD242@suse.de> <4D25A7E3.4090101@redhat.com> <BE843088-8070-40F5-A030-2FD051332838@suse.de> <4D2624FF.1010801@redhat.com> <5E3AD4FB-2D25-4586-88C8-05330E1AACD3@suse.de>
In-Reply-To: <5E3AD4FB-2D25-4586-88C8-05330E1AACD3@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2011 12:38 PM, Alexander Graf wrote:

<snip>
>
> Sure, I'm not saying your patch is bad or goes in the wrong direction. I'd just think it'd be awesome to have an easy way for the guest OS to know that something as crucial as TSC reading speed got changed, hopefully even TSC frequency. Having any form of notification leaves open doors for someone to implement something (think proprietary OSs or out-of-service OSs here). Having no notification leaves us with no choice but taking the penalty and keeping the guest less informed than it has to be.
>    

We do - register kvmclock and check to make sure the version before and 
after time computations to be sure the frequency hasn't changed.

This doesn't even require an interrupt.

>    
>>      
>>>
>>>        
>>>>> Would it make sense to add a kvmclock interrupt to notify the guest of such a change?
>>>>>
>>>>>            
>>>> kvmclock is immune to frequency changes, so it needs no interrupt, it just has a version controlled shared area, which is reset.
>>>>
>>>>          
>>>
>>>        
>>>>>> We indicate to pvclock users that the TSC is being trapped, to allow
>>>>>> avoiding overhead and directly using RDTSCP (only for SVM).  This
>>>>>> optimization is not yet implemented.
>>>>>>
>>>>>>              
>>>>>
>>>>>            
>>> That doesn't sound to me like they're unaffected?
>>>
>>>        
>> On Intel RDTSCP traps along with RDTSC.  This means that you can't have a trapping, constant rate TSC for userspace without also paying the overhead for reading the TSC for kvmclock.  This is not true on SVM, where RDTSCP is a separate trap, allowing optimization.
>>      
> So how does the guest know that something changed when it's migrated from an AMD machine to an Intel machine?
>    

That can and never should happen.  Simply too much state in the guest 
depends on CPU type, different workarounds are enabled for things, and 
even different instruction sets are activated.

There is no reward for the kind of complexity involved.

Zach
