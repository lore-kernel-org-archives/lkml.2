Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab0CVRoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 13:44:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474Ab0CVRoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:44:44 -0400
Message-ID: <4BA7AC6B.3050103@redhat.com>
Date: Mon, 22 Mar 2010 19:44:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Joerg Roedel <joro@8bytes.org>, Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321203121.GA30194@elte.hu> <20100322111040.GL13108@8bytes.org> <20100322122228.GH3483@elte.hu> <20100322134633.GD1940@8bytes.org> <20100322163215.GC18796@elte.hu>
In-Reply-To: <20100322163215.GC18796@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 06:32 PM, Ingo Molnar wrote:
>
> So, what do you think creates code communities and keeps them alive?
> Developers and code. And the wellbeing of developers are primarily influenced
> by the repository structure and by the development/maintenance process - i.e.
> by the 'fun' aspect. (i'm simplifying things there but that's the crux of it.)
>    

There is nothing fun about having one repository or two.  Who cares 
about this anyway?

tools/kvm/ probably will draw developers, simply because of the glory 
associated with kernel work.  That's a bug, not a feature.  It means 
that effort is not distributed according to how it's needed, but because 
of irrelevant considerations.

> I simply do not want to see KVM face the same fate, and yes i do see similar
> warnings signs.
>    

The number of kvm and qemu developers keeps increasing.

We're having a kvm forum in August where we all meet.  Come and see for 
yourself.

>> We actually have lguest which is small. But it lacks functionality and the
>> developer community KVM has attracted.
>>      
> I suggested long ago to merge lguest into KVM to cover non-VMX/non-SVM
> execution.
>    

Rusty posted some initial patches for pv-only kvm but he lost interest 
before they were completed.  No one followed up.

btw, lguest has a single repository, userspace and kernel in the same 
repository, yet is practically dead.

>>> I think you are rationalizing the status quo.
>>>        
>> I see that there are issues with KVM today in some areas. You pointed out
>> the desktop usability already. I personally have trouble with the
>> qem-kvm.git because it is unbisectable. But repository unification doesn't
>> solve the problem here.
>>      
> Why doesnt it solve the bisectability problem? The kernel repo is supposed to
> be bisectable so that problem would be solved.
>    

These days qemu-kvm.git is bisectable (though not always trivially).  
qemu.git doesn't have this problem.

>> The point for a single repository is that it simplifies the development
>> process. I agree with you here. But the current process of KVM is not too
>> difficult after all. I don't have to touch qemu sources for most of my work
>> on KVM.
>>      
> In my judgement you'd have to do that more frequently, if KVM was properly
> weighting its priorities. For example regarding this recent KVM commit of
> yours:
>
> | commit ec1ff79084fccdae0dca9b04b89dcdf3235bbfa1
> | Author: Joerg Roedel<joerg.roedel@amd.com>
> | Date:   Fri Oct 9 16:08:31 2009 +0200
> |
> |     KVM: SVM: Add tracepoint for invlpga instruction
> |
> |     This patch adds a tracepoint for the event that the guest
> |     executed the INVLPGA instruction.
>
> With integrated KVM tooling i might have insisted for that new tracepoint to
> be available to users as well via some more meaningful tooling than just a
> pure tracepoint.
>    

Something I've wanted for a long time is to port kvm_stat to use 
tracepoints instead of the home-grown instrumentation.  But that is 
unrelated to this new tracepoint.  Other than that we're satisfied with 
ftrace.

> You should realize that naturally developers will gravitate towards the most
> 'fun' aspects of a project. It is the task of the maintainer to keep the
> balance between fun and utility, bugs and features, quality and code-rot.
>    

There are plenty of un-fun tasks (like fixing bugs and providing RAS 
features) that we're doing.  We don't do this for fun but to satisfy our 
users.

-- 
error compiling committee.c: too many arguments to function

