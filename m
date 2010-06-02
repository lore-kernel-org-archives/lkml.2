Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab0FBCvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 22:51:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757314Ab0FBCvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 22:51:39 -0400
Message-ID: <4C05C722.1010804@redhat.com>
Date: Wed, 02 Jun 2010 05:51:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hpa@zytor.com, mingo@elte.hu, npiggin@suse.de,
       tglx@linutronix.de, mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
References: <20100601093515.GH24302@redhat.com> <87sk56ycka.fsf@basil.nowhere.org> <20100601162414.GA6191@redhat.com> <20100601163807.GA11880@basil.fritz.box> <4C053ACC.5020708@redhat.com> <20100601172730.GB11880@basil.fritz.box>
In-Reply-To: <20100601172730.GB11880@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2010 08:27 PM, Andi Kleen wrote:
> On Tue, Jun 01, 2010 at 07:52:28PM +0300, Avi Kivity wrote:
>    
>> We are running everything on NUMA (since all modern machines are now NUMA).
>>   At what scale do the issues become observable?
>>      
> On Intel platforms it's visible starting with 4 sockets.
>    

Can you recommend a benchmark that shows bad behaviour?  I'll run it 
with ticket spinlocks and Gleb's patch.  I have a 4-way Nehalem-EX, 
presumably the huge number of threads will magnify the problem even more 
there.

>>>> I understand that reason and do not propose to get back to old spinlock
>>>> on physical HW! But with virtualization performance hit is unbearable.
>>>>
>>>>          
>>> Extreme unfairness can be unbearable too.
>>>
>>>        
>> Well, the question is what happens first.  In our experience, vcpu
>> overcommit is a lot more painful.  People will never see the NUMA
>> unfairness issue if they can't use kvm due to the vcpu overcommit problem.
>>      
> You really have to address both, if you don't fix them both
> users will eventually into one of them and be unhappy.
>    

That's definitely the long term plan.  I consider Gleb's patch the first 
step.

Do  you have any idea how we can tackle both problems?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

