Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0CUVmx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 17:42:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab0CUVmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 17:42:52 -0400
Message-ID: <4BA692C3.7010408@redhat.com>
Date: Sun, 21 Mar 2010 23:42:27 +0200
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
References: <4BA256FE.5080501@codemonkey.ws> <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com> <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA47AD0.2010509@redhat.com> <20100321190656.GC25922@elte.hu> <4BA68009.5010906@redhat.com> <20100321205531.GC30194@elte.hu>
In-Reply-To: <20100321205531.GC30194@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2010 10:55 PM, Ingo Molnar wrote:
>
> Of course you could say the following:
>
>    ' Thanks, I'll mark this for v2.6.36 integration. Note that we are not
>      able to add this to the v2.6.35 kernel queue anymore as the ongoing
>      usability work already takes up all of the project's maintainer and
>      testing bandwidth. If you want the feature to be merged sooner than that
>      then please help us cut down on the TODO and BUGS list that can be found
>      at XYZ. There's quite a few low hanging fruits there. '
>    

That would be shooting at my own foot as well as the contributor's since 
I badly want that RCU stuff, and while a GUI would be nice, that itch 
isn't on my back.

You're asking a developer and a maintainer to put off the work they're 
interested in, in order to work on something someone else is interested 
in, but not contributing the work.

> Although this RCU example is 'worst' possible example, as it's a pure speedup
> change with no functionality effect.
>
> Consider the _other_ examples that are a lot more clear:
>
>     ' If you expose paravirt spilocks via KVM please also make sure the KVM
>       tooling can make use of it, has an option for it to configure it, and
>       that it has sufficient efficiency statistics displayed in the tool for
>       admins to monitor.'
>
>     ' If you create this new paravirt driver then please also make sure it can
>       be configured in the tooling. '
>
>     ' Please also add a testcase for this bug to tools/kvm/testcases/ so we dont
>       repeat this same mistake in the future. '
>    

All three happen quite commonly in qemu/kvm development.  Of course 
someone who develops a feature also develops a patch that exposes it in 
qemu.  There are several test cases in qemu-kvm.git/kvm/user/test.

> I'd say most of the high-level feature work in KVM has tooling impact.
>    

Usually, pretty low.  Plumbing down a feature is usually trivial.  There 
are exceptions, of course - smp is only supported in qemu-kvm.git, not 
in upstream qemu.git, for example.  In any case of course the work is 
done in both qemu and kvm - do you think people develop features to see 
them bitrot?

> And note the important arguement that the 'eject button' thing would not occur
> naturally in a project that is well designed and has a good quality balance.
> It would only occur in the transitionary period if a big lump of lower-quality
> code is unified with higher-quality code. Then indeed a lot of pressure gets
> created on the people working on the high-quality portion to go over and fix
> the low-quality portion.
>    

It's a matter of priorities.

> Which, btw., is an unconditonally good thing ...
>
> But even an RCU speedup can be fairly linked/ordered to more pressing needs of
> a project.
>    

Pressing to whom?

> Really, the unification of two tightly related pieces of code has numerous
> clear advantages. Please give it some thought before rejecting it.
>    

I'm not blind to the advantages.  Dropping tcg would be the biggest of 
them by far (much more than moving the repository, IMO).  But there are 
disadvantages as well.

Around two years ago I seriously considered forking qemu, at this time I 
do not think it is a good idea.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

