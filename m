Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab0DMGqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 02:46:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab0DMGqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 02:46:36 -0400
Message-ID: <4BC41338.80206@redhat.com>
Date: Tue, 13 Apr 2010 09:46:16 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Zhang, Xiantao" <xiantao.zhang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       "Yang, Xiaowei" <xiaowei.yang@intel.com>,
       "Dong, Eddie" <eddie.dong@intel.com>, "Li, Xin" <xin.li@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: VM performance issue in KVM guests.
References: <EB8593BCECAB3D40A8248BE0B6400A3846903F4C@shzsmsx502.ccr.corp.intel.com> <4BC0D125.9050108@redhat.com> <EB8593BCECAB3D40A8248BE0B6400A384690419B@shzsmsx502.ccr.corp.intel.com> <4BC2C07B.4040607@redhat.com> <EB8593BCECAB3D40A8248BE0B6400A38469046C1@shzsmsx502.ccr.corp.intel.com>
In-Reply-To: <EB8593BCECAB3D40A8248BE0B6400A38469046C1@shzsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2010 03:50 AM, Zhang, Xiantao wrote:
> Avi Kivity wrote:
>    
>> On 04/12/2010 05:04 AM, Zhang, Xiantao wrote:
>>      
>>>        
>>>> What was the performance hit?  What was your I/O setup (image
>>>> format, using aio?)
>>>>
>>>>          
>>> The issue only happens when vcpu number is over-committed(e.g.
>>> vcpu/pcpu>2) and physical cpus are saturated. For example,  when run
>>> webbench in windows OS in this case, its performance drops by 80%.
>>> In our experiment, we are using image file through virtio, and I
>>> think aio should be used by default also.
>>>
>>>        
>> Is this on a machine that does pause-loop exits?  The current handing
>> of PLE is very suboptimal.  With proper directed yield we should be
>> much better there.
>>
>> Without PLE, we need paravirtualized spinlocks, no way around it.
>>      
> PLE has the ability to eliminate the issue at some extent, and pv solution should be helpful also.  But for windows guests running on machines without PLE, we still needs to enhance host side to resolve the issue.
>    

Well, was this on a machine with PLE or without PLE?

>> Spin loops need to be addressed first, they are known to kill
>> performance in overcommit situations.
>>      
> Even in overcommit case, if vcpu threads of one qemu are not scheduled or pulled to the same logical processor, the performance drop is tolerant like Xen's case today. But for KVM, it has to suffer from additional performance loss, since host's scheduler actively pulls these vcpu threads together.
>
>    

Can you quantify this loss?  Give examples of what happens?


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

