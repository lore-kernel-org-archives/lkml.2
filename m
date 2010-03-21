Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0CUUzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:55:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39258 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab0CUUzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:55:46 -0400
Date: Sun, 21 Mar 2010 21:55:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
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
Message-ID: <20100321205531.GC30194@elte.hu>
References: <4BA256FE.5080501@codemonkey.ws>
 <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com>
 <20100318170223.GB9756@elte.hu>
 <4BA25E66.2050800@redhat.com>
 <20100318172805.GB26067@elte.hu>
 <4BA32E1A.2060703@redhat.com>
 <20100319085346.GG12576@elte.hu>
 <4BA47AD0.2010509@redhat.com>
 <20100321190656.GC25922@elte.hu>
 <4BA68009.5010906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA68009.5010906@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 03/21/2010 09:06 PM, Ingo Molnar wrote:
> >* Avi Kivity<avi@redhat.com>  wrote:
> >
> >>>>[...] Second, from my point of view all contributors are volunteers
> >>>>(perhaps their employer volunteered them, but there's no difference from
> >>>>my perspective). Asking them to repaint my apartment as a condition to
> >>>>get a patch applied is abuse.  If a patch is good, it gets applied.
> >>>This is one of the weirdest arguments i've seen in this thread. Almost all
> >>>the time do we make contributions conditional on the general shape of the
> >>>project. Developers dont get to do just the fun stuff.
> >>So, do you think a reply to a patch along the lines of
> >>
> >>   NAK.  Improving scalability is pointless while we don't have a decent GUI.
> >>I'll review you RCU patches
> >>   _after_ you've contributed a usable GUI.
> >>
> >>?
> >What does this have to do with RCU?
> 
> The example was rcuifying kvm which took place a bit ago.  Sorry, it wasn't 
> clear.
> 
> > I'm talking about KVM, which is a Linux kernel feature that is useless 
> > without a proper, KVM-specific app making use of it.
> >
> > RCU is a general kernel performance feature that works across the board. 
> > It helps KVM indirectly, and it helps many other kernel subsystems as 
> > well. It needs no user-space tool to be useful.
> 
> Correct.  So should I tell someone that has sent a patch that rcu-ified kvm 
> in order to scale it, that I won't accept the patch unless they do some 
> usability userspace work?  say, implementing an eject button. That's what I 
> understood you to mean.

Of course you could say the following:

  ' Thanks, I'll mark this for v2.6.36 integration. Note that we are not
    able to add this to the v2.6.35 kernel queue anymore as the ongoing 
    usability work already takes up all of the project's maintainer and 
    testing bandwidth. If you want the feature to be merged sooner than that 
    then please help us cut down on the TODO and BUGS list that can be found 
    at XYZ. There's quite a few low hanging fruits there. '

Although this RCU example is 'worst' possible example, as it's a pure speedup 
change with no functionality effect.

Consider the _other_ examples that are a lot more clear:

   ' If you expose paravirt spilocks via KVM please also make sure the KVM
     tooling can make use of it, has an option for it to configure it, and 
     that it has sufficient efficiency statistics displayed in the tool for 
     admins to monitor.'

   ' If you create this new paravirt driver then please also make sure it can
     be configured in the tooling. '

   ' Please also add a testcase for this bug to tools/kvm/testcases/ so we dont
     repeat this same mistake in the future. '

I'd say most of the high-level feature work in KVM has tooling impact.

And note the important arguement that the 'eject button' thing would not occur 
naturally in a project that is well designed and has a good quality balance. 
It would only occur in the transitionary period if a big lump of lower-quality 
code is unified with higher-quality code. Then indeed a lot of pressure gets 
created on the people working on the high-quality portion to go over and fix 
the low-quality portion.

Which, btw., is an unconditonally good thing ...

But even an RCU speedup can be fairly linked/ordered to more pressing needs of 
a project.

Really, the unification of two tightly related pieces of code has numerous 
clear advantages. Please give it some thought before rejecting it.

Thanks,

	Ingo
