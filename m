Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab0CVQcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:32:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39793 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227Ab0CVQc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:32:29 -0400
Date: Mon, 22 Mar 2010 17:32:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joro@8bytes.org>
Cc: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
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
Message-ID: <20100322163215.GC18796@elte.hu>
References: <20100318172805.GB26067@elte.hu>
 <4BA32E1A.2060703@redhat.com>
 <20100319085346.GG12576@elte.hu>
 <4BA3747F.60401@codemonkey.ws>
 <20100321191742.GD25922@elte.hu>
 <4BA67B2F.4030101@redhat.com>
 <20100321203121.GA30194@elte.hu>
 <20100322111040.GL13108@8bytes.org>
 <20100322122228.GH3483@elte.hu>
 <20100322134633.GD1940@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322134633.GD1940@8bytes.org>
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


* Joerg Roedel <joro@8bytes.org> wrote:

> [...] Look at the state of the alpha arch in Linux today, it is maintained 
> in one repository but nobody really cares about it. Thus it is miles behine 
> most other archs Linux supports today in quality and feature completeness.

I dont know how you can find the situation of Alpha comparable, which is a 
legacy architecture for which no new CPU was manufactored in the past ~10 
years.

The negative effects of physical obscolescence cannot be overcome even by the 
very best of development models ...

So this is a total non-argument in this context.

> On Mon, Mar 22, 2010 at 01:22:28PM +0100, Ingo Molnar wrote:
> > 
> > * Joerg Roedel <joro@8bytes.org> wrote:
> > 
> > > [...] Basically the reason of the oProfile failure is a disfunctional 
> > > community. [...]
> > 
> > Caused by: repository separation and the inevitable code and social fork a 
> > decade later.
> 
> No, the split-repository situation was the smallest problem after all. Its 
> was a community thing. If the community doesn't work a single-repo project 
> will also fail. [...]

So, what do you think creates code communities and keeps them alive? 
Developers and code. And the wellbeing of developers are primarily influenced 
by the repository structure and by the development/maintenance process - i.e. 
by the 'fun' aspect. (i'm simplifying things there but that's the crux of it.)

So yes, i do claim that what stiffled and eventually killed off the Oprofile 
community was the split repository. None of the other Oprofile shortcomings 
were really unfixable, but this one was. It gave no way for the community to 
grow in a healthy way, after the initial phase. Features were more difficult 
and less fun to develop.

And yes, there were times when there was still active Oprofile development but 
the development process warning signs should have been noticed, and the 
community could have been kept alive by unification and similar measures. 
Instead what happened was a complete rewrite and a competitive replacement by 
perf. (Which isnt particularly nice to users btw. - they prefer more gradual 
transitions - but there was no other option, so many problems accumulated in 
Oprofile.)

I simply do not want to see KVM face the same fate, and yes i do see similar 
warnings signs.

> > What you fail to realise (or what you fail to know, you werent around when 
> > Oprofile was written, i was) is that Oprofile _did_ have a functional 
> > single community when it was written. The tooling and the kernel bits was 
> > written by the same people.
> 
> Yes, this was probably the time when everybody was enthusiastic about the 
> feature and they could attract lots of developers. But situation changed 
> over time.

The thing is, the drift was pre-programmed by having a split ...

> > So i dont see much of a difference to the Oprofile situation really and i 
> > see many parallels. I also see similar kinds of desktop usability 
> > problems.
> 
> The difference is that KVM has a working community with good developers and 
> maintainers.

Oprofile certainly had good developers and maintainers as well. In the end it 
wasnt enough ...

Also, a project can easily still be 'alive' but not reach its full potential. 

Why do you assume that my argument means that KVM isnt viable today? It can 
very well still be viable and even healthy - just not _as healthy_ as it could 
be ...

> > The difference is that we dont have KVM with a decade of history and we 
> > dont have a 'told you so' KVM reimplementation to show that proves the 
> > point. I guess it's a matter of time before that happens, because Qemu 
> > usability is so absymal today - so i guess we should suspend any 
> > discussions until that happens, no need to waste time on arguing 
> > hypoteticals.
> 
> We actually have lguest which is small. But it lacks functionality and the 
> developer community KVM has attracted.

I suggested long ago to merge lguest into KVM to cover non-VMX/non-SVM 
execution.

> > I think you are rationalizing the status quo.
> 
> I see that there are issues with KVM today in some areas. You pointed out 
> the desktop usability already. I personally have trouble with the 
> qem-kvm.git because it is unbisectable. But repository unification doesn't 
> solve the problem here.

Why doesnt it solve the bisectability problem? The kernel repo is supposed to 
be bisectable so that problem would be solved.

> The point for a single repository is that it simplifies the development 
> process. I agree with you here. But the current process of KVM is not too 
> difficult after all. I don't have to touch qemu sources for most of my work 
> on KVM.

In my judgement you'd have to do that more frequently, if KVM was properly 
weighting its priorities. For example regarding this recent KVM commit of 
yours:

| commit ec1ff79084fccdae0dca9b04b89dcdf3235bbfa1
| Author: Joerg Roedel <joerg.roedel@amd.com>
| Date:   Fri Oct 9 16:08:31 2009 +0200
|
|     KVM: SVM: Add tracepoint for invlpga instruction
|     
|     This patch adds a tracepoint for the event that the guest
|     executed the INVLPGA instruction.

With integrated KVM tooling i might have insisted for that new tracepoint to 
be available to users as well via some more meaningful tooling than just a 
pure tracepoint.

There's synergies like that all around the place.

You should realize that naturally developers will gravitate towards the most 
'fun' aspects of a project. It is the task of the maintainer to keep the 
balance between fun and utility, bugs and features, quality and code-rot.

> > It's as if you argued in 1990 that the unification of East and West 
> > Germany wouldnt make much sense because despite clear problems and 
> > incompatibilites and different styles westerners were still allowed to 
> > visit eastern relatives and they both spoke the same language after all 
> > ;-)
> 
> Um, hmm. I don't think these situations have enough in common to compare 
> them ;-)

Probably, but it's an interesting parallel nevertheless ;-)

Thanks,

	Ingo
