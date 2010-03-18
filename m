Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168Ab0CRLfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 07:35:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40444 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab0CRLfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 07:35:37 -0400
Date: Thu, 18 Mar 2010 12:35:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Alexander Graf <agraf@suse.de>, Anthony Liguori <anthony@codemonkey.ws>,
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
Message-ID: <20100318113527.GA13168@elte.hu>
References: <20100316130840.GA24808@elte.hu>
 <4B9FBA8B.8020200@codemonkey.ws>
 <20100316173940.GA23859@elte.hu>
 <4BA00F1F.1090907@codemonkey.ws>
 <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
 <20100318085607.GB2157@elte.hu>
 <F0F75B33-C0BA-42EB-BFC4-D60B1E232E6D@suse.de>
 <20100318101025.GA13073@elte.hu>
 <4BA1FEB0.7000400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA1FEB0.7000400@redhat.com>
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

> > Still it's _very_ useful to have a single reference implementation under 
> > tools/perf/ where we concentrate the best of the code. That is where we 
> > make sure that each new kernel feature is appropriately implemented in 
> > user-space as well, that the combination works well together and is 
> > releasable to users. That is what keeps us all honest: the latency of 
> > features is much lower, and there's no ping-pong of blame going on between 
> > the two components in case of bugs or in case of misfeatures.
> 
> That would make sense for a truly minimal userspace for kvm: we once had a 
> tool called kvmctl which was used to run tests (since folded into qemu).  It 
> didn't contain a GUI and was unable to run a general purpose guest.  It was 
> a few hundred lines of code, and indeed patches to kvmctl had a much closer 
> correspondence to patches with kvm (though still low, as most kvm patches 
> don't modify the ABI).

If it's functional to the extent of at least allowing say a serial console via 
the console (like the UML binary allows) i'd expect the minimal user-space to 
quickly grow out of this minimal state. The rest will be history.

Maybe this is a better, simpler (and much cleaner and less controversial) 
approach than moving a 'full' copy of qemu there.

There's certainly no risk: if qemu stays dominant then nothing is lost 
[tools/kvm/ can be removed after some time], and if this clean base works out 
fine then the useful qemu technologies will move over to it gradually and 
without much fuss, and the developers will move with it as well.

If it's just a token effort with near zero utility to begin with it certainly 
wont take off.

Once it's there in tools/kvm/ and bootable i'd certainly hack up some quick 
xlib based VGA output capability myself - it's not that hard ;-) It would also 
allow me to test whether latest-KVM still boots fine in a much simpler way. 
(most of my testboxes dont have qemu installed)

So you have one user signed up for that already ;-)

> > Same goes for KVM+Qemu: it would be so much nicer to have a single, 
> > well-focused reference implementation under tools/kvm/ and have 
> > improvements flow into that code base.
> >
> > That way KVM developers cannot just shrug "well, GUI suckage is a 
> > user-space problem" - like the answers i got in the KVM usability thread 
> > ...
> >
> > The buck will stop here.
> 
> Suppose we copy qemu tomorrow into tools/.  All the problems will be copied 
> with it.  Someone still has to write patches to fix them. Who will it be?

What we saw with tools/perf/ was that pure proximity to actual kernel testers 
and kernel developers produces a steady influx of new developers. It didnt 
happen overnight, but it happened. A simple:

  cd tools/perf/
  make -j install

Gets them something to play with. That kind of proximity is very powerful.

The other benefit was that distros can package perf with the kernel package, 
so it's updated together with the kernel. This means a very efficient 
distribution of new technologies, together with new kernel releases.

Distributions are very eager to update kernels even in stable periods of the 
distro lifetime - they are much less willing to update user-space packages.

You can literally get full KVM+userspace features done _and deployed to users_ 
within the 3 months development cycle of upstream KVM.

All these create synergies that are very clear once you see the process in 
motion. It's a powerful positive feedback loop. Give it some thought please.

	Ingo
