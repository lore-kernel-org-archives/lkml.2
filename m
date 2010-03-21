Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab0CUUXA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:23:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab0CUUW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:22:59 -0400
Message-ID: <4BA68009.5010906@redhat.com>
Date: Sun, 21 Mar 2010 22:22:33 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
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
References: <4BA250BF.80704@codemonkey.ws> <20100318162853.GB447@elte.hu> <4BA256FE.5080501@codemonkey.ws> <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com> <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA47AD0.2010509@redhat.com> <20100321190656.GC25922@elte.hu>
In-Reply-To: <20100321190656.GC25922@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2010 09:06 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>>>> [...] Second, from my point of view all contributors are volunteers
>>>> (perhaps their employer volunteered them, but there's no difference from
>>>> my perspective). Asking them to repaint my apartment as a condition to
>>>> get a patch applied is abuse.  If a patch is good, it gets applied.
>>>>          
>>> This is one of the weirdest arguments i've seen in this thread. Almost all
>>> the time do we make contributions conditional on the general shape of the
>>> project. Developers dont get to do just the fun stuff.
>>>        
>> So, do you think a reply to a patch along the lines of
>>
>>    NAK.  Improving scalability is pointless while we don't have a decent GUI.
>> I'll review you RCU patches
>>    _after_ you've contributed a usable GUI.
>>
>> ?
>>      
> What does this have to do with RCU?
>    

The example was rcuifying kvm which took place a bit ago.  Sorry, it 
wasn't clear.

> I'm talking about KVM, which is a Linux kernel feature that is useless without
> a proper, KVM-specific app making use of it.
>
> RCU is a general kernel performance feature that works across the board. It
> helps KVM indirectly, and it helps many other kernel subsystems as well. It
> needs no user-space tool to be useful.
>    

Correct.  So should I tell someone that has sent a patch that rcu-ified 
kvm in order to scale it, that I won't accept the patch unless they do 
some usability userspace work?  say, implementing an eject button. 
That's what I understood you to mean.

> KVM on the other hand is useless without a user-space tool.
>
> [ Theoretically you might have a fair point if it were a critical feature of
>    RCU for it to have a GUI, and if the main tool that made use of it sucked.
>    But it isnt and you should know that. ]
>
> Had you suggested the following 'NAK', applied to a different, relevant
> subsystem:
>
>    |   NAK.  Improving scalability is pointless while we don't have a usable
>    | tool.  I'll review you perf patches _after_ you've contributed a usable
>    | tool.
>    

That might hold, but the tool is usable at least for some people - it 
runs in production.  The people running it won't benefit from an eject 
button or any usability improvement since they run it through a 
centralized management tool that hides everything.  They will benefit 
from the scalability patches.  Should I still make those patches 
conditional on scalability work that is of no interest to the submitter?

>    
>>> This is a basic quid pro quo: new features introduce risks and create
>>> additional workload not just to the originating developer but on the rest
>>> of the community as well. You should check how Linus has pulled new
>>> features in the past 15 years: he very much requires the existing code to
>>> first be top-notch before he accepts new features for a given area of
>>> functionality.
>>>        
>> For a given area, yes. [...]
>>      
> That is my precise point.
>
> KVM is a specific subsystem or "area" that makes no sense without the
> user-space tooling it relates to. You seem to argue that you have no 'right'
> to insist on good quality of that tooling - and IMO you are fundamentally
> wrong with that.
>    

kvm contains many sub-areas.  I'm not going to tie unrelated things 
together like the GUI and sclability, configuration file format and 
emulator correctness, nested virtualization and qcow2 asynchronity, or 
other crazy combinations.  People either leave en mass or become 
frustrated if they can't.  I do reject patches touching a sub-area that 
I think need to be done in userspace, for example.

That's not to say kvm development is random.  We have a weekly 
conference call where regular contributors and maintainers of both qemu 
and kvm participate and where we decide where to focus.  Sadly the issue 
of a qemu GUI is not raised often.  Perhaps you can participate and 
voice your concerns.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

