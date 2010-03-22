Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab0CVUxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:53:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab0CVUxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:53:52 -0400
Message-ID: <4BA7D8C6.4010103@redhat.com>
Date: Mon, 22 Mar 2010 22:53:26 +0200
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
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100322143212.GE14201@elte.hu> <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu> <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu> <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu> <4BA7B9E0.5080009@codemonkey.ws> <20100322192739.GE21919@elte.hu> <4BA7C96D.2020702@redhat.com> <20100322204650.GD18126@elte.hu>
In-Reply-To: <20100322204650.GD18126@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 10:46 PM, Ingo Molnar wrote:
>
>>> You should instead read the long list of disadvantages above, invert them
>>> and list then as advantages for the kernel-based vcpu enumeration
>>> solution, apply common sense and go admit to yourself that indeed in this
>>> situation a kernel provided enumeration of vcpu contexts is the most
>>> robust solution.
>>>        
>> Having qemu enumerate guests one way or another is not a good idea IMO since
>> it is focused on one guest and doesn't have a system-wide entity.  A
>> userspace system-wide entity will work just as well as kernel
>> implementation, without its disadvantages.
>>      
> A system-wide user-space entity only solves one problem out of the 4 i listed,
> still leaving the other 3:
>
>   - Those special files can get corrupted, mis-setup, get out of sync, or can
>     be hard to discover.
>    

That's a hard requirement anyway.  If it happens, we get massive data 
loss.  Way more troubling than 'perf kvm top' doesn't work.  So consider 
it fulfilled.

>   - Apps might start KVM vcpu instances without adhering to the
>     system-wide access method.
>    

Then you don't get their symbol tables.  That happens anyway if the 
symbol server is not installed, not running, handing out fake data.  So 
we have to deal with that anyway.

>   - There is no guarantee for the system-wide process to reply to a request -
>     while the kernel can always guarantee an enumeration result. I dont want
>     'perf kvm' to hang or misbehave just because the system-wide entity has
>     hung.
>    

When you press a key there is no guarantee no component along the way 
will time out.

> Really, i think i have to give up and not try to convince you guys about this
> anymore - i dont think you are arguing constructively anymore and i dont want
> yet another pointless flamewar about this.
>
> Please consider 'perf kvm' scrapped indefinitely, due to lack of robust KVM
> instrumentation features: due to lack of robust+universal vcpu/guest
> enumeration and due to lack of robust+universal symbol access on the KVM side.
> It was a really promising feature IMO and i invested two days of arguments
> into it trying to find a workable solution, but it was not to be.
>    

I am not going to push libvirt or a subset thereof into the kernel for 
'perf kvm'.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

