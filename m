Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab0D0Jbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:31:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340Ab0D0Jbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:31:32 -0400
Message-ID: <4BD6AEC7.5020609@redhat.com>
Date: Tue, 27 Apr 2010 12:30:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
       kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM, Fix QEMU-KVM is killed by guest SRAO MCE
References: <1272351860.24125.15.camel@yhuang-dev.sh.intel.com>	 <4BD69680.10402@redhat.com> <1272360341.24125.116.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1272360341.24125.116.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 12:25 PM, Huang Ying wrote:
>
>
>> On 04/27/2010 10:04 AM, Huang Ying wrote:
>>      
>>> +static void kvm_send_hwpoison_signal(struct kvm *kvm, gfn_t gfn)
>>> +{
>>> +	char buf[1];
>>> +	void __user *hva;
>>> +	int r;
>>> +
>>> +	/* Touch the page, so send SIGBUS */
>>> +	hva = (void __user *)gfn_to_hva(kvm, gfn);
>>> +	r = copy_from_user(buf, hva, 1);
>>>
>>>        
>> No error check?  What will a copy_from_user() of poisoned page expected
>> to return?
>>
>> Best to return -EFAULT on failure for consistency.
>>      
> Just want to use the side effect of copy_from_user, SIGBUS will be sent
> to current process because the page touched is marked as poisoned. That
> is, failure is expected, so the return value is not checked.
>    

What if the failure doesn't happen?  Say, someone mmap()ed over the page.

btw, better to use (void)copy_from_user(...) instead to avoid the 
initialized but not used warning the compiler may generate.


-- 
error compiling committee.c: too many arguments to function

