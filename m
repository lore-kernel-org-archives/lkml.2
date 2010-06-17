Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686Ab0FQH5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 03:57:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab0FQH5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 03:57:53 -0400
Message-ID: <4C19D6D5.7060501@redhat.com>
Date: Thu, 17 Jun 2010 16:03:33 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: Zachary Amsden <zamsden@redhat.com>, avi@redhat.com, mtosatti@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/17] Unify vendor TSC logic
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com> <1276587259-32319-4-git-send-email-zamsden@redhat.com> <4C1886E2.2060509@redhat.com> <20100616132223.GI19104@mothafucka.localdomain>
In-Reply-To: <20100616132223.GI19104@mothafucka.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> On Wed, Jun 16, 2010 at 04:10:10PM +0800, Jason Wang wrote:
>   
>> Zachary Amsden wrote:
>>     
>>>  
>>>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>>  {
>>> +	kvm_x86_ops->vcpu_load(vcpu, cpu);
>>>  	if (unlikely(vcpu->cpu != cpu)) {
>>> +		/* Make sure TSC doesn't go backwards */
>>> +		s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 : 
>>> +				native_read_tsc() - vcpu->arch.last_host_tsc;
>>> +		if (tsc_delta < 0 || check_tsc_unstable())
>>>   
>>>       
>> It's better to do the adjustment also when tsc_delta > 0
>>     
> And why do you think so? Doing it on tsc_delta > 0 would force us to adjust
> at every entry but the first. And I guess we want to adjust as few times as 
> we can.
>
>   
This is not strange and is what current SVM code does. If we do not do
this, guest may see a jump in the value of TSC when tsc_delta > 0.
> For example, we would adjust on every cpu bounce even for machines that has
> a perfectly sync tsc. This could introduce an error not present before.
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

