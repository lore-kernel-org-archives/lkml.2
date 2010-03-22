Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0CVLjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 07:39:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50523 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600Ab0CVLjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 07:39:51 -0400
Date: Mon, 22 Mar 2010 12:39:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Olivier Galibert <galibert@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
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
Message-ID: <20100322113931.GE3483@elte.hu>
References: <20100318172805.GB26067@elte.hu>
 <4BA32E1A.2060703@redhat.com>
 <20100319085346.GG12576@elte.hu>
 <4BA3747F.60401@codemonkey.ws>
 <20100321191742.GD25922@elte.hu>
 <4BA67B2F.4030101@redhat.com>
 <20100321200849.GA51323@dspnet.fr.eu.org>
 <4BA67D75.8060809@redhat.com>
 <20100321203704.GB30194@elte.hu>
 <4BA71012.7070004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA71012.7070004@redhat.com>
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

> On 03/21/2010 10:37 PM, Ingo Molnar wrote:
> >
> >>That includes the guest kernel.  If you can deploy a new kernel in the
> >>guest, presumably you can deploy a userspace package.
> >
> > Note that with perf we can instrument the guest with zero guest-kernel 
> > modifications as well.
> >
> > We try to reduce the guest impact to a bare minimum, as the difficulties 
> > in deployment are function of the cross section surface to the guest.
> >
> > Also, note that the kernel is special with regards to instrumentation: 
> > since this is the kernel project, we are doing kernel space changes, as we 
> > are doing them _anyway_. So adding symbol resolution capabilities would be 
> > a minimal addition to that - while adding a while new guest package for 
> > the demon would significantly increase the cross section surface.
> 
> It's true that for us, changing the kernel is easier than changing the rest 
> of the guest.  IMO we should still resist the temptation to go the easy path 
> and do the right thing (I understand we disagree about what the right thing 
> is).

It is not about the 'temptation to go the easy path'.

It is about finding the most pragmatic approach and realizing the cost of 
inaction: sucky Linux, sucky KVM.

Let me give you an example: Linus's commit in v2.6.30 that changed the 
user-space policy of the EXT3 filesystem to make it more desktop capable:

  bbae8bc: ext3: make default data ordering mode configurable

That changes was opposed vehemently with your kind of arguments: "such changes 
should be done by the distributions", "it should be done correctly", "the 
kernel should not implement policy", etc..

I can also tell you that this commit improved my desktop experience 
incredibly. Still, distros didnt do it for almost a decade of ext3 existence. 
Why?

Truth is that those kinds of "do it right" arguments are mistaken because they 
assume that we live in an ideal, 'perfect market' where all inefficiencies 
will get eliminated in the long run.

In reality the "market" for OSS software is imperfect:

 - there's marginal costs of action - a too small change has difficulty 
   getting over that

 - there's costs of modularization (which are both technical and social)

 - there's the power of the status quo acting against marginally good changes

 - there's the power of entropy ripping Linux distributions apart making
   all-distro changes harder 

So the solution to the "why dont the distributions do this" question you pose 
is exactly what i propose: _give a default, reference implementation of KVM 
tooling that has to be eclipsed_.

There's the unique position of the kernel that it can impose sanity in a more 
central way which acts as a reference implementation.

I.e. the kernel can very much improve quality all across the board by 
providing a sane default (in the ext3 case) - or, as in the case of perf, by 
providing a sane 'baseline' tooling. It should do the same for KVM as well.

If we dont do that, Linux will eventually stop mattering on the desktop - and 
some time after that, it will vanish from the server space as well. Then, may 
it be a decade down the line, you wont have a KVM hacking job left, and you 
wont know where all those forces eliminating your project came from.

But i told you now so you'll know ;-)

Reality is, the server space never was and never will be self-sustaining in 
the long run (as Novell has found it out with Netware), it is the desktop that 
dictates future markets. This is why i find your views about this naive and 
shortsighted.

Thanks,

	Ingo
