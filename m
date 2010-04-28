Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab0D1JsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 05:48:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab0D1JsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 05:48:17 -0400
Message-ID: <4BD80449.4010700@redhat.com>
Date: Wed, 28 Apr 2010 12:47:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM, Fix QEMU-KVM is killed by guest SRAO MCE
References: <1272351860.24125.15.camel@yhuang-dev.sh.intel.com>	 <4BD69680.10402@redhat.com>	 <1272360341.24125.116.camel@yhuang-dev.sh.intel.com>	 <4BD6AEC7.5020609@redhat.com> <1272423375.24125.189.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1272423375.24125.189.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2010 05:56 AM, Huang Ying wrote:
>    
>>>
>>> Just want to use the side effect of copy_from_user, SIGBUS will be sent
>>> to current process because the page touched is marked as poisoned. That
>>> is, failure is expected, so the return value is not checked.
>>>
>>>        
>> What if the failure doesn't happen?  Say, someone mmap()ed over the page.
>>      
> Sorry, not get your idea clearly. hva is re-mmap()ed? We just read the
> hva, not write, so I think it should be OK here.
>
>    

We don't generate a signal in this case.  Does the code continue to work 
correctly (not sure what correctly is in this case... should probably 
just continue).

There's also the possibility of -EFAULT.

-- 
error compiling committee.c: too many arguments to function

