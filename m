Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab0CVGuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 02:50:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321Ab0CVGuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 02:50:01 -0400
Message-ID: <4BA712F0.5030806@redhat.com>
Date: Mon, 22 Mar 2010 08:49:20 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321203121.GA30194@elte.hu> <4BA6900B.1040408@redhat.com> <20100321215207.GA13219@elte.hu>
In-Reply-To: <20100321215207.GA13219@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2010 11:52 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>>> I.e. you are arguing for microkernel Linux, while you see me as arguing
>>> for a monolithic kernel.
>>>        
>> No. I'm arguing for reducing bloat wherever possible.  Kernel code is more
>> expensive than userspace code in every metric possible.
>>      
> 1)
>
> One of the primary design arguments of the micro-kernel design as well was to
> push as much into user-space as possible without impacting performance too
> much so you very much seem to be arguing for a micro-kernel design for the
> kernel.
>
> I think history has given us the answer for that fight between microkernels
> and monolithic kernels.
>    

I am not arguing for a microkernel.  Again: reduce bloat where possible, 
kernel code is more expensive than userspace code.

> Furthermore, to not engage in hypotheticals about microkernels: by your
> argument the Oprofile design was perfect (it was minimalistic kernel-space,
> with all the complexity in user-space), while perf was over-complex (which
> does many things in the kernel that could have been done in user-space).
>
> Practical results suggest the exact opposite happened - Oprofile is being
> replaced by perf. How do you explain that?
>    

I did not say that the amount of kernel and userspace code is the only 
factor deciding the quality of software.  If that were so, microkernels 
would have won out long ago.

It may be that that perf has too much kernel code, and won against 
oprofile despite that because it was better in other areas.  Or it may 
be that perf has exactly the right user/kernel division.  Or maybe perf 
needs some of the code moved from userspace to the kernel.  I don't 
know, I haven't examined the code.

The user/kernel boundary is only one metric for code quality.  Nor is it 
always in favour of pushing things to userspace.  Narrowing or 
simplifying an interface is often an argument in favour of pushing 
things into the kernel.

IMO the reason perf is more usable than oprofile has less to do with the 
kernel/userspace boundary and more do to with effort and attention spent 
on the userspace/user boundary.

> 2)
>
> In your analysis you again ignore the package boundary costs and artifacts as
> if they didnt exist.
>
> That was my main argument, and that is what we saw with oprofile and perf:
> while maintaining more kernel-code may be more expensive, it sure pays off for
> getting us a much better solution in the end.
>    

Package costs are real.  We need to bear them.  I don't think that 
because maintaining another package (and the interface between two 
packages) is more difficult, then the kernel size should increase.

> And getting a 'much better solution' to users is the goal of all this, isnt
> it?
>
> I dont mind what you call 'bloat' per se if it's for a purpose that users find
> like a good deal. I have quite a bit of RAM in most of my systems, having 50K
> more or less included in the kernel image is far less important than having a
> healthy and vibrant development model and having satisfied users ...
>    

I'm not worried about 50K or so, I'm worried about a bug in those 50K 
taking down the guest.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

