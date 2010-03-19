Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab0CSIyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 04:54:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56177 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab0CSIyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 04:54:03 -0400
Date: Fri, 19 Mar 2010 09:53:46 +0100
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
Message-ID: <20100319085346.GG12576@elte.hu>
References: <4BA23FE1.5050402@codemonkey.ws>
 <20100318151737.GA2875@elte.hu>
 <4BA250BF.80704@codemonkey.ws>
 <20100318162853.GB447@elte.hu>
 <4BA256FE.5080501@codemonkey.ws>
 <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com>
 <20100318170223.GB9756@elte.hu>
 <4BA25E66.2050800@redhat.com>
 <20100318172805.GB26067@elte.hu>
 <4BA32E1A.2060703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA32E1A.2060703@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> > There were two negative reactions immediately, both showed a fundamental 
> > server versus desktop bias:
> >
> >  - you did not accept that the most important usecase is when there is a
> >    single guest running.
> 
> Well, it isn't.

Erm, my usability points are _doubly_ true when there are multiple guests ...

The inconvenience of having to type:

  perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms \
  --guestmodules=/home/ymzhang/guest/modules top

is very obvious even with a single guest. Now multiply that by more guests ...

The crux is: we are working on improving KVM instrumentation. There are 
working patches posted to this thread and we would like to have/implement an 
automatism to allow the discovery of all this information. The information 
should be available to the developer who wants it, and easily/transparently so 
- in true Linux fashion.

> >  - the reaction to the 'how do we get symbols out of the guest' sub-question
> >    was, paraphrased: 'we dont want that due to<unspecified>  security threat
> >    to XYZ selinux usecase with lots of guests'.
> 
> When I review a patch, I try to think of the difficult cases, not
> just the easy case.

You havent articulated an actionable reason and you have suggested no solution 
either, you just passive-agressive backed the claim that giving developers 
access to the symbol space is some sort of vague 'security threat'.

If that is not so i'd be glad to be proven wrong.

> > Anyone being aware of how Linux and KVM is being used on the desktop will 
> > know how detached that attitude is from the typical desktop usecase ...
> >
> > Usability _never_ sucks because of lack of patches or lack of suggestions. 
> > I bet if you made the next server feature contingent on essential 
> > usability fixes they'd happen overnight - for God's sake there's been 1000 
> > commits in the last 3 months in the Qemu repository so there's plenty of 
> > manpower...
> 
> First of all I am not a qemu maintainer. [...]

That is the crux of the matter. My experience in these threads was that no-one 
really seems to feel in charge of the whole thing. Should we really wonder why 
KVM usability sucks?

> [...] Second, from my point of view all contributors are volunteers (perhaps 
> their employer volunteered them, but there's no difference from my 
> perspective). Asking them to repaint my apartment as a condition to get a 
> patch applied is abuse.  If a patch is good, it gets applied.

This is one of the weirdest arguments i've seen in this thread. Almost all the 
time do we make contributions conditional on the general shape of the project. 
Developers dont get to do just the fun stuff.

This is a basic quid pro quo: new features introduce risks and create 
additional workload not just to the originating developer but on the rest of 
the community as well. You should check how Linus has pulled new features in 
the past 15 years: he very much requires the existing code to first be 
top-notch before he accepts new features for a given area of functionality.

Doing that and insisting on developers to see those imbalances as well is 
absolutely essential to code quality: otherwise everyone would be running 
around implementing just the features they are interested in, without regard 
for the general health of the project.

Of course, if you keep the project in two halves (KVM and Qemu), and pretend 
that they are separate and have little relation, imbalances of quality can 
mount up and you can throw your hands up and say that it's "too bad, I'm not 
maintaining that". It is your basic duty as a Linux maintainer to keep 
balances of quality. I do it all day, other maintainers do it all day.

> > Usability suckage - and i'm not going to be popular for saying this out 
> > loud - almost always shows a basic maintainer disconnect with the real 
> > world. See your very first reactions to my 'KVM usability' observations. 
> > Read back your and Anthony's replies: total 'sure, patches welcome' kind 
> > of indifference. It is _your project_, not some other project down the 
> > road ...
> 
> I could drop everything and write a gtk GUI for qemu.  Is that what you 
> want?

No, my suggestion to you (it's up to you whether you give my opinion any 
weight) is to accept your mistakes and improve, and to not stand in the way of 
people who'd like to improve the situation. You are happy with the server 
features and you also made it clear that you dont feel responsible for the 
rest of the package - which is a big mistake IMO.

Also, you have demonstrated it in this thread that you have near zero 
technical clue about basic desktop and development usability matters - for 
example your stance on symbol space access and your stance on how to enumerate 
guests symbolically are outright bizarre.

Thanks,

	Ingo
