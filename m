Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab0CRNqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 09:46:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab0CRNqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:46:52 -0400
Message-ID: <4BA22E9E.4000607@redhat.com>
Date: Thu, 18 Mar 2010 15:46:06 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Frank Ch. Eigler" <fche@redhat.com>, Alexander Graf <agraf@suse.de>,
       Anthony Liguori <anthony@codemonkey.ws>,
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
References: <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com> <20100318085607.GB2157@elte.hu> <F0F75B33-C0BA-42EB-BFC4-D60B1E232E6D@suse.de> <20100318101025.GA13073@elte.hu> <4BA1FEB0.7000400@redhat.com> <20100318113527.GA13168@elte.hu> <y0m4okdzu4z.fsf@fche.csb> <20100318130226.GB7424@elte.hu> <4BA22663.7070509@redhat.com> <20100318133124.GA25642@elte.hu>
In-Reply-To: <20100318133124.GA25642@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 03:31 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 03/18/2010 03:02 PM, Ingo Molnar wrote:
>>      
>>>        
>>>> [...] What users eagerly replace their kernels?
>>>>          
>>> Those 99% who click on the 'install 193 updates' popup.
>>>
>>>        
>> Of which 1 is the kernel, and 192 are userspace updates (of which one may be
>> qemu).
>>      
> I think you didnt understand my (tersely explained) point - which is probably
> my fault. What i said is:
>
>   - distros update the kernel first. Often in stable releases as well if
>     there's a new kernel released. (They must because it provides new hardware
>     enablement and other critical changes they generally cannot skip.)
>    

No, they don't.  RHEL 5 is still on 2.6.18, for example.  Users don't 
like their kernels updated unless absolutely necessary, with good reason.

Kernel updates = reboots.

>   - Qemu on the other hand is not upgraded with (nearly) that level of urgency.
>     Completely new versions will generally have to wait for the next distro
>     release.
>    

F12 recently updated to 2.6.32.  This is probably due to 2.6.31.stable 
dropping away, and no capacity at Fedora to maintain it on their own.  
So they are caught in a bind - stay on 2.6.31 and expose users to 
security vulnerabilities or move to 2.6.32 and cause regressions.  Not a 
happy choice.

> With in-kernel tools the kernel and the tooling that accompanies the kernel
> are upgraded in the same low-latency pathway. That is a big plus if you are
> offering things like instrumentation (which perf does), which relates closely
> to the kernel.
>
> Furthermore, many distros package up the latest -git kernel as well. They
> almost never do that with user-space packages.
>    

I'm sure if we ask the Fedora qemu maintainer to package qemu-kvm.git 
they'll consider it favourably.  Isn't that what rawhide is for?

> Let me give you a specific example:
>
> I'm running Fedora Rawhide with 2.6.34-rc1 right now on my main desktop, and
> that comes with perf-2.6.34-0.10.rc1.git0.fc14.noarch.
>
> My rawhide box has qemu-kvm-0.12.3-3.fc14.x86_64 installed. That's more than a
> 1000 Qemu commits older than the latest Qemu development branch.
>
> So by being part of the kernel repo there's lower latency upgrades and earlier
> and better testing available on most distros.
>
> You made it very clear that you dont want that, but please dont try to claim
> that those advantages do not exist - they are very much real and we are making
> good use of it.
>    

I don't mind at all if rawhide users run on the latest and greatest, but 
release users deserve a little more stability.

-- 
error compiling committee.c: too many arguments to function

