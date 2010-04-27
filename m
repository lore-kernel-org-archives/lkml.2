Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0D0TU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 15:20:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292Ab0D0TUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 15:20:55 -0400
Message-ID: <4BD73914.8040209@redhat.com>
Date: Tue, 27 Apr 2010 22:20:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] export new cpuid KVM_CAP
References: <1272303988-21929-1-git-send-email-glommer@redhat.com> <1272303988-21929-2-git-send-email-glommer@redhat.com> <1272303988-21929-3-git-send-email-glommer@redhat.com> <1272303988-21929-4-git-send-email-glommer@redhat.com> <1272303988-21929-5-git-send-email-glommer@redhat.com> <4BD7291F.6010809@redhat.com> <20100427190901.GS16166@mothafucka.localdomain>
In-Reply-To: <20100427190901.GS16166@mothafucka.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 10:09 PM, Glauber Costa wrote:
>
>> Hmm.  We already have an API to get cpuid bits:
>> KVM_GET_SUPPORTED_CPUID2.  The nice thing about it is that it will
>> mean -cpu host will work out of the box.
>>      
> Ok, from what I understand, KVM_GET_CPUID2 gets a set of features, and tells
> userspace which of them are available. Right?
>    

No.  KVM_GET_CPUID2 reads what was set by KVM_SET_CPUID, as modified by 
the guest executing the cpuid instruction.  KVM_GET_SUPPORTED_CPUID 
tells userspace which bits are supported by the host cpu and kvm.

> If this is the case, userspace could ask for 0xffffffff, and then we tell them
> which of them are present.
>
> Does that make sense?
>    

The API for KVM_GET_SUPPORTED_CPUID returns all cpuid leaves supported 
in one go, IIRC.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

