Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab1A0Mbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 07:31:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388Ab1A0Mbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 07:31:35 -0500
Message-ID: <4D41659B.1010706@redhat.com>
Date: Thu, 27 Jan 2011 14:31:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, aliguori@us.ibm.com
Subject: Re: [PATCH 01/16] KVM-HDR: register KVM basic header infrastructure
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>	 <1295892397-11354-2-git-send-email-glommer@redhat.com>	 <4D400045.2000405@redhat.com>	 <1296044013.15920.47.camel@mothafucka.localdomain>	 <4D4039CB.6060008@redhat.com>	 <1296056170.3591.14.camel@mothafucka.localdomain>	 <4D405853.6010003@codemonkey.ws> <1296064182.3591.30.camel@mothafucka.localdomain>
In-Reply-To: <1296064182.3591.30.camel@mothafucka.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2011 07:49 PM, Glauber Costa wrote:
> >
> >  If type becomes implied based on the MSR number, you'd get the best of
> >  both worlds, no?
> >
> >  I do think advertising features in CPUID is nicer than writing to an MSR
> >  and then checking for an ack in the memory region.
> Fine. But back to the point, I think the reasoning here is that I see
> all those areas as just a single feature, shared data.

That's not a feature.  kvmclock and apf are features.

> >
> >  I do think having a standard mechanism for small regions of shared
> >  memory between the hypervisor and guest is a reasonable thing to do.
>
> Through what I am proposing, or through something else? (including
> slight variations)
>

I'd like to keep the current way of doing things.  Helpers in the guest 
and host to consolidate code are fine, but there's no need to impact the 
ABI.

e.g.

     kvm_register_feature_msr(u32 msr, u64 alignment, struct cpuid_bit 
*feature, int (*callback)(struct kvm_vcpu *vcpu, u64 value))

will install handlers for wrmsr and rdmsr, and declare the msr for 
save/restore, tell the wrmsr handler which cpuid bit allows exposing the 
msr, and registers a callback for when the msr is written by the guest.

-- 
error compiling committee.c: too many arguments to function

