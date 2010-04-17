Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab0DQTRb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 15:17:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab0DQTRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 15:17:30 -0400
Message-ID: <4BCA092A.8050308@redhat.com>
Date: Sat, 17 Apr 2010 22:16:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       kvm@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>,
       linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, tim.c.chen@intel.com,
       zhiteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V4 1/2] perf & kvm: Enhance perf to collect KVM guest
 os statistics from host side
References: <1271403275.2078.509.camel@ymzhang.sh.intel.com> <4BC9FC9A.6050807@redhat.com> <20100417191308.GA25160@elte.hu>
In-Reply-To: <20100417191308.GA25160@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2010 10:13 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 04/16/2010 10:34 AM, Zhang, Yanmin wrote:
>>      
>>> Below is the kernel patch to enable perf to collect guest os statistics.
>>>
>>> Joerg,
>>>
>>> Would you like to add support on svm? I don't know the exact point to trigger
>>> NMI to host with svm.
>>>
>>> See below code with vmx:
>>>
>>> +		kvm_before_handle_nmi(&vmx->vcpu);
>>>   		asm("int $2");
>>> +		kvm_after_handle_nmi(&vmx->vcpu);
>>>
>>> Signed-off-by: Zhang Yanmin<yanmin_zhang@linux.intel.com>
>>>        
>> Can you please split it further?
>>
>> Patch 1 introduces perf_register_guest_info_callbacks() and related. Ingo
>> can merge this into a branch in tip.git. Patch 2 is just the kvm bits, I'll
>> apply that after merging the branch with patch 1. Patch 3 adds the
>> tools/perf changes.
>>
>> This way perf development can continue on tip.git, and kvm development can
>> continue on kvm.git, without the code bases diverging and requiring a merge
>> later.
>>      
> I'd like to pull the KVM bits from you into perf - so that there's a testable
> form of the changes. We can do that via a branch that has 1-2 changes, plus
> minimal conflicts down the line, right?
>    

We can try doing this (currently we don't, but this is simple enough 
that we could).  I'd still like 1-2 in two patches.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

