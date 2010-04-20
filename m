Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0DTJ3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 05:29:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab0DTJ3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 05:29:09 -0400
Message-ID: <4BCD73E1.3000207@redhat.com>
Date: Tue, 20 Apr 2010 12:29:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] export new cpuid KVM_CAP
References: <1271356648-5108-1-git-send-email-glommer@redhat.com> <1271356648-5108-2-git-send-email-glommer@redhat.com> <1271356648-5108-3-git-send-email-glommer@redhat.com> <1271356648-5108-4-git-send-email-glommer@redhat.com> <1271356648-5108-5-git-send-email-glommer@redhat.com> <4BCA04D2.1040300@redhat.com> <20100419145037.GG14158@mothafucka.localdomain>
In-Reply-To: <20100419145037.GG14158@mothafucka.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 05:50 PM, Glauber Costa wrote:
> On Sat, Apr 17, 2010 at 09:58:26PM +0300, Avi Kivity wrote:
>    
>> On 04/15/2010 09:37 PM, Glauber Costa wrote:
>>      
>>> Since we're changing the msrs kvmclock uses, we have to communicate
>>> that to the guest, through cpuid. We can add a new KVM_CAP to the
>>> hypervisor, and then patch userspace to recognize it.
>>>
>>> And if we ever add a new cpuid bit in the future, we have to do that again,
>>> which create some complexity and delay in feature adoption.
>>>
>>> Instead, what I'm proposing in this patch is a new capability, called
>>> KVM_CAP_X86_CPUID_FEATURE_LIST, that returns the current feature list
>>> currently supported by the hypervisor. If we ever want to add or remove
>>> some feature, we only need to tweak into the HV, leaving userspace untouched.
>>>
>>>        
>> Hm.  We need to update userspace anyway, since we don't like turning
>> features on unconditionally (it breaks live migration into an older
>> kernel).
>>      
> Right now, we don't have any mechanism to disable, say, kvmclock cpuid bit
> at userspace.

(that's a serious bug wrt migration, btw)

> But let's suppose we have: What's the difference between disabling
> it in the way it is now, and disabling it with the method I am proposing?
>    

No difference.

> All this ioctl say is: "Those are the current supported stuff in this HV".
> It does not mandate userspace to expose all of this to the guest. It just saves
> us from the job of creating yet another CAP for every bit we plan on including.
>    

Right.  Well, creating a new CAP and creating a new FEATURE flag aren't 
very different, and I'd like to avoid API churn.  We have enough new 
APIs due to missing or badly implemented features; I'd like to avoid new 
ones whenever possible.

It's not like it saves userspace anything, it has to accommodate older 
kernels anyhow.  We are able to ignore pre 2.6.27 kernels, but now with 
kvm shipped in long term support distributions, deprecating APIs will be 
much harder.

> If we want to be conservative, we can keep everything but the things we know
> already disabled, in userspace.
>    

We definitely need to do that.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

