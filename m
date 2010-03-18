Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414Ab0CRQpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 12:45:24 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:50472 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab0CRQpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 12:45:23 -0400
Message-ID: <4BA256FE.5080501@codemonkey.ws>
Date: Thu, 18 Mar 2010 11:38:22 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>,
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
References: <20100318085607.GB2157@elte.hu> <4BA1FC80.2000401@redhat.com> <20100318105013.GB24464@elte.hu> <4BA20EB8.60707@redhat.com> <20100318114821.GB13168@elte.hu> <4BA21B09.6060706@redhat.com> <20100318130047.GA7424@elte.hu> <4BA23FE1.5050402@codemonkey.ws> <20100318151737.GA2875@elte.hu> <4BA250BF.80704@codemonkey.ws> <20100318162853.GB447@elte.hu>
In-Reply-To: <20100318162853.GB447@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 11:28 AM, Ingo Molnar wrote:
>>> There are all kernel space projects, going through Xorg would be a
>>> horrible waste of performance for full-screen virtualization. It's fine
>>> for the windowed or networked case (and good as a compatibility fallback),
>>> but very much not fine for local desktop use.
>>>        
> For the full-screen case (which is a very common mode of using a guest OS on
> the desktop) there's not much of window management needed. You need to
> save/restore as you switch in/out.
>    

I don't think I've ever used full-screen mode with my VMs and I use 
virtualization on a daily basis.

We hear very infrequently from users using full screen mode.

>> 3D graphics virtualization is extremely difficult in the non-passthrough
>> case.  It really requires hardware support that isn't widely available today
>> (outside a few NVIDIA chipsets).
>>      
> Granted it's difficult in the general case.
>
>    
>>>> Xorg framebuffer driver doesn't implement any of the optimizations that the
>>>> Linux framebuffer supports and the Xorg driver does not provide use the
>>>> kernel's interfaces for providing update regions.
>>>>
>>>> Of course, we need to pull in X into the kernel to fix this, right?
>>>>          
>>> FYI, this part of X has already been pulled into the kernel, it's called
>>> DRM. If then it's being expanded.
>>>        
>> It doesn't provide the things we need to a good user experience. You need
>> things like an absolute input device, host driven display resize, RGBA
>> hardware cursors.  None of these go through DRI and it's those things that
>> really provide the graphics user experience.
>>      
> With KSM the display resize is in the kernel.

KMS

>   Cursor management is not. Yet: i
> think it would be a nice feature as the cursor could move even if Xorg is
> blocked or busy with other things.
>    

If it was all in the kernel, we'd try to support it.

>>>> Any sufficiently complicated piece of software is going to interact with
>>>> a lot of other projects.  The solution is not to pull it all into one
>>>> massive repository.  It's to build relationships and to find ways to
>>>> efficiently work with the various communities.
>>>>          
>>> That's my whole point with this thread: the kernel side of KVM and qemu,
>>> but all practical purposes should not be two 'separate communities'. They
>>> should be one and the same thing.
>>>        
>> I don't know why you keep saying this.  The people who are in these
>> "separate communities" keep claiming that they don't feel this way.
>>      
> If you are not two separate communities but one community, then why do you go
> through the (somewhat masochistic) self-punishing excercise of keeping the
> project in two different pieces?
>    

I don't see any actual KVM developer complaining about this so I'm not 
sure why you're describing it like this.

> In a distant past Qemu was a separate project and KVM was just a newcomer who
> used it for fancy stuff. Today as you say(?) the two communities are one and
> the same. Why not bring it to its logical conclusion?
>    

We lose a huge amount of users and contributors if we put QEMU in the 
Linux kernel.  As I said earlier, a huge number of our contributions 
come from people not using KVM.

>> I'm not just saying this to be argumentative.  Many of the people in the
>> community have thought this same thing, and tried it themselves, and we've
>> all come to the same conclusion.
>>
>> It's certainly possible that we just missed the obvious thing to do but
>> we'll never know that unless someone shows us.
>>      
> I'm not aware of anyone in the past having attempted to move qemu to
> tools/kvm/ in the uptream kernel repo, and having reported on the experiences
> with such a contribution setup. (obviously it's not possible at all without
> heavy cooperation and acceptance from you and Avi, so this will probably
> remain a thought experiment forever)
>    

We've tried to create a "clean" version of QEMU specifically for KVM.  
Moving it into tools/kvm would be the second step.  We've all failed on 
the firs step.

> If then you must refer to previous attempts to 'strip down' Qemu, right? Those
> attempts didnt really solve the fundamental problem of project code base
> separation.
>    

If the problem is combining the two, I've sent you a patch that you can 
put into tip.git if you're so inclined.

Regards,

Anthony Liguori

> 	Ingo
>    

