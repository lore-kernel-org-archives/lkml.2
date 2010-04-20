Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab0DTJjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 05:39:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204Ab0DTJjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 05:39:01 -0400
Message-ID: <4BCD761D.7050001@redhat.com>
Date: Tue, 20 Apr 2010 12:38:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Joerg Roedel <joro@8bytes.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V3] perf & kvm: Enhance perf to collect KVM guest  os
 statistics from host side
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com> <4BC9FA19.2070602@redhat.com> <4BCC136D.503@redhat.com> <201004201132.56039.sheng@linux.intel.com>
In-Reply-To: <201004201132.56039.sheng@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2010 06:32 AM, Sheng Yang wrote:
> On Monday 19 April 2010 16:25:17 Avi Kivity wrote:
>    
>> On 04/17/2010 09:12 PM, Avi Kivity wrote:
>>      
>>> I think you were right the first time around.
>>>        
>> Re-reading again (esp. the part about treatment of indirect NMI
>> vmexits), I think this was wrong, and that the code is correct.  I am
>> now thoroughly confused.
>>
>>      
> My fault...
>    

Not at all, it's really confusingly worded.

> To my understanding now, "If an event causes a VM exit directly, it does not
> update architectural state as it would have if it had it not caused the VM
> exit:", means: in NMI case, NMI would involve the NMI handler, and change the
> "architectural state" to NMI block. In VMX non-root mode, the behavior of
> calling NMI handler changed(determine by some VMCS fields), but not the
> affection to the "architectural state". So the NMI block state would remain
> the same.
>    

Agree.  It's confusing because the internal "nmi pending" flag is not 
set, while the "nmi blocking" flag is set.

(on svm both are set, but the NMI is not taken until the vmexit 
completes and the host unmasks NMIs).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

