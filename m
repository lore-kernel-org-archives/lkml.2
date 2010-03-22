Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab0CVOrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:47:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53215 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab0CVOrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:47:10 -0400
Date: Mon, 22 Mar 2010 15:47:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
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
Message-ID: <20100322144701.GF14201@elte.hu>
References: <20100319085346.GG12576@elte.hu>
 <4BA3747F.60401@codemonkey.ws>
 <20100321191742.GD25922@elte.hu>
 <4BA67B2F.4030101@redhat.com>
 <20100321203121.GA30194@elte.hu>
 <4BA6900B.1040408@redhat.com>
 <20100321215207.GA13219@elte.hu>
 <4BA712F0.5030806@redhat.com>
 <20100322112340.GD3483@elte.hu>
 <4BA76746.1000505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA76746.1000505@redhat.com>
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

> On 03/22/2010 01:23 PM, Ingo Molnar wrote:
> >* Avi Kivity<avi@redhat.com>  wrote:
> >
> >>IMO the reason perf is more usable than oprofile has less to do with the
> >>kernel/userspace boundary and more do to with effort and attention spent on
> >>the userspace/user boundary.
> >>
> >>[...]
> >
> > If you are interested in the first-hand experience of the people who are 
> > doing the perf work then here it is: by far the biggest reason for perf 
> > success and perf usability is the integration of the user-space tooling 
> > with the kernel-space bits, into a single repository and project.
> 
> Please take a look at the kvm integration code in qemu as a fraction of the 
> whole code base.

You have to admit that much of Qemu's past 2-3 years of development was 
motivated by Linux/KVM (i'd say more than 50% of the code). As such it's one 
and the same code base - you just continue to define Qemu to be different from 
KVM.

I very much remember how Qemu looked like _before_ KVM: it was a struggling, 
dying project. KVM clearly changed that.

> > The very move you are opposing so vehemently for KVM.
> 
> I don't want to fracture a working community.

Would you accept (or at least not NAK) a new tools/kvm/ tool that builds 
tooling from grounds up, while leaving Qemu untouched? [assuming it's all 
clean code, etc.]

Although i have doubts about how well that would work 'against' your opinion: 
such a tool would need lots of KVM-side features and a positive attitude from 
you to be really useful. There's a lot of missing functionality to cover.

> > Oprofile went the way you proposed, and it was a failure. It failed not 
> > because it was bad technology (it was pretty decent and people used it), 
> > it was not a failure because the wrong people worked on it (to the 
> > contrary, very capable people worked on it), it was a failure in hindsight 
> > because it simply incorrectly split into two projects which stiffled the 
> > progress of each other.
> 
> Every project that has some kernel footprint, except perf, is split like 
> that.  Are they all failures?

No. Did i ever claim KVM was a failure? I said it's hindered by this design 
aspect.

Are other Linux kernel tool projects affected by similar problems? You bet ...

> Seems like perf is also split, with sysprof being developed outside the 
> kernel.  Will you bring sysprof into the kernel?  Will every feature be 
> duplicated in prof and sysprof?

I'd prefer if sysprof merged into perf as 'perf view' - but its maintainer 
does not want that - which is perfectly OK. So we are building equivalent 
functionality into perf instead.

Think about it like Firefox plugins: the main Firefox project picks up the 
functionality of the most popular Firefox plugins all the time. Session Saver, 
Tab Mix Plus, etc. were all in essence 'merged' (in functionality, not in 
code) into the 'reference' Firefox project.

I think that's a fundamentally healthy model: it allows extensions and thus 
give others an honest chance to show that you are potentially coding an 
inferior piece of code - but also express a clear opinion about what you 
consider a full, usable, high-quality reference implementation and constantly 
improve this reference implementation.

I dont think that can be argued to be a bad model. Yes, it takes a bit of 
thinking outside the box to do tools/kvm/ but of all people i'd expect some of 
that from you.

	Ingo
