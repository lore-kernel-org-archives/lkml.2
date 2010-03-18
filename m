Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab0CRWo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:44:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41722 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab0CRWo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:44:58 -0400
Date: Thu, 18 Mar 2010 23:44:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100318224446.GC19669@elte.hu>
References: <20100316173940.GA23859@elte.hu>
 <4BA00F1F.1090907@codemonkey.ws>
 <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
 <20100318085607.GB2157@elte.hu>
 <4BA1FC80.2000401@redhat.com>
 <20100318105013.GB24464@elte.hu>
 <4BA294D4.2060700@redhat.com>
 <20100318211529.GA21367@elte.hu>
 <4BA2A70B.5080101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA2A70B.5080101@redhat.com>
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


* Zachary Amsden <zamsden@redhat.com> wrote:

> On 03/18/2010 11:15 AM, Ingo Molnar wrote:
> >* Zachary Amsden<zamsden@redhat.com>  wrote:
> >
> >>On 03/18/2010 12:50 AM, Ingo Molnar wrote:
> >>>* Avi Kivity<avi@redhat.com>   wrote:
> >>>
> >>>>>The moment any change (be it as trivial as fixing a GUI detail or as
> >>>>>complex as a new feature) involves two or more packages, development speed
> >>>>>slows down to a crawl - while the complexity of the change might be very
> >>>>>low!
> >>>>Why is that?
> >>>It's very simple: because the contribution latencies and overhead compound,
> >>>almost inevitably.
> >>>
> >>>If you ever tried to implement a combo GCC+glibc+kernel feature you'll know
> >>>...
> >>>
> >>>Even with the best-run projects in existence it takes forever and is very
> >>>painful - and here i talk about first hand experience over many years.
> >>Ingo, what you miss is that this is not a bad thing.  Fact of the
> >>matter is, it's not just painful, it downright sucks.
> >Our experience is the opposite, and we tried both variants and report about
> >our experience with both models honestly.
> >
> >You only have experience about one variant - the one you advocate.
> >
> >See the assymetry?
> >
> >>This is actually a Good Thing (tm).  It means you have to get your
> >>feature and its interfaces well defined and able to version forwards
> >>and backwards independently from each other.  And that introduces
> >>some complexity and time and testing, but in the end it's what you
> >>want.  You don't introduce a requirement to have the feature, but
> >>take advantage of it if it is there.
> >>
> >>It may take everyone else a couple years to upgrade the compilers,
> >>tools, libraries and kernel, and by that time any bugs introduced by
> >>interacting with this feature will have been ironed out and their
> >>patterns well known.
> >Sorry, but this is pain not true. The 2.4->2.6 kernel cycle debacle has taught
> >us that waiting long to 'iron out' the details has the following effects:
> >
> >  - developer pain
> >  - user pain
> >  - distro pain
> >  - disconnect
> >  - loss of developers, testers and users
> >  - grave bugs discovered months (years ...) down the line
> >  - untested features
> >  - developer exhaustion
> >
> >It didnt work, trust me - and i've been around long enough to have suffered
> >through the whole 2.5.x misery. Some of our worst ABIs come from that cycle as
> >well.
> 
> You're talking about a single project and comparing it to my argument about 
> multiple independent projects.  In that case, I see no point in the 
> discussion.  If you want to win the argument by strawman, you are welcome to 
> do so.

The kernel is a very complex project with many ABI issues, so all those 
arguments apply to it as well. The description you gave:

 | This is actually a Good Thing (tm).  It means you have to get your feature 
 | and its interfaces well defined and able to version forwards and backwards 
 | independently from each other.  And that introduces some complexity and 
 | time and testing, but in the end it's what you want.  You don't introduce a 
 | requirement to have the feature, but take advantage of it if it is there.

matches the kernel too. We have many such situations. (Furthermore, the 
tools/perf/ situation, which relates to ABIs and user-space/kernel-space 
interactions is similar as well.)

Do you still think i'm making a straw-man argument?

> > Sorry, but i really think you are really trying to rationalize a 
> > disadvantage here ...
> 
> This could very well be true, but until someone comes forward with 
> compelling numbers (as in, developers committed to working on the project, 
> number of patches and total amount of code contribution), there is no point 
> in having an argument, there really isn't anything to discuss other than 
> opinion.  My opinion is you need a really strong justification to have a 
> successful fork and I don't see that justification.

I can give you rough numbers for tools/perf - if that counts for you.

For the first four months of its existence, when it was a separate project, i 
had a single external contributor IIRC.

The moment it went into the kernel repo the number of contributors and 
contributions skyrocketed and basically all contributions were top-notch. We 
are at 60+ separate contributors now (after about 8 months upstream) - which 
is still small compared to the kernel or to Qemu, but huge for a relatively 
isolated project like instrumentation.

So in my estimation tools/kvm/ would certainly be popular. Whether it would be 
more popular than current Qemu is hard to tell - it would be pure speculation.

Any reliable numbers for the other aspect, whether a split project creates a 
more fragile and less developed ABI would be extremely hard to get. I believe 
it to be true, but that's my opinion based on my experience with other 
projects, extrapolated to KVM/Qemu.

Anyway, the issue is moot as there's clear opposition to the unification idea. 

Too bad - there was heavy initial opposition to the arch/x86 unification as 
well [and heavy opposition to tools/perf/ as well], still both worked out 
extremely well :-)

	Ingo
