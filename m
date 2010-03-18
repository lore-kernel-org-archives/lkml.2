Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab0CRKuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 06:50:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45145 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740Ab0CRKu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 06:50:27 -0400
Date: Thu, 18 Mar 2010 11:50:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
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
Message-ID: <20100318105013.GB24464@elte.hu>
References: <20100316122903.GA8831@elte.hu>
 <4B9F7C6A.3070207@redhat.com>
 <20100316130840.GA24808@elte.hu>
 <4B9FBA8B.8020200@codemonkey.ws>
 <20100316173940.GA23859@elte.hu>
 <4BA00F1F.1090907@codemonkey.ws>
 <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
 <20100318085607.GB2157@elte.hu>
 <4BA1FC80.2000401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA1FC80.2000401@redhat.com>
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

> > The moment any change (be it as trivial as fixing a GUI detail or as 
> > complex as a new feature) involves two or more packages, development speed 
> > slows down to a crawl - while the complexity of the change might be very 
> > low!
> 
> Why is that?

It's very simple: because the contribution latencies and overhead compound, 
almost inevitably.

If you ever tried to implement a combo GCC+glibc+kernel feature you'll know 
...

Even with the best-run projects in existence it takes forever and is very 
painful - and here i talk about first hand experience over many years.

> I the maintainers of all packages are cooperative and responsive, then the 
> patches will get accepted quickly.  If they aren't, development will be 
> slow. [...]

I'm afraid practice is different from the rosy ideal you paint there. Even 
with assumed 'perfect projects' there's always random differences between 
projects, causing doubled (tripled) overhead and compounded up overhead:

 - random differences in release schedules

 - random differences in contribution guidelines

 - random differences in coding style

> [...] It isn't any different from contributing to two unrelated kernel 
> subsystems (which are in fact in different repositories until the next merge 
> window).

You mention a perfect example: contributing to multipe kernel subsystems. Even 
_that_ is very noticeably harder than contributing to a single subsystem - due 
to the inevitable buerocratic overhead, due to different development trees, 
due to different merge criteria.

So you are underlining my point (perhaps without intending to): treating 
closely related bits of technology as a single project is much better.

Obviously arch/x86/kvm/, virt/ and tools/kvm/ should live in a single 
development repository (perhaps micro-differentiated by a few topical 
branches), for exactly those reasons you mention.

Just like tools/perf/ and kernel/perf_event.c and arch/*/kernel/perf*.c are 
treated as a single project.

[ Note: we actually started from a 'split' design [almost everyone picks that, 
  because of this false 'kernel space bits must be separate from user space 
  bits' myth] where the user-space component was a separate code base and 
  unified it later on as the project progressed.

  Trust me, the practical benefits of the unified approach are enormous to 
  developers and to users alike, and there was no looking back once we made 
  the switch. ]

Also, i dont really try to 'convince' you here - you made your position very 
clear early on and despite many unopposed technical arguments i made, the 
positions seem to have hardened and i expect it wont change, no matter what 
arguments i bring. It's a pity but hey, i'm just an observer here really - 
it's the rest of _your_ life this all impacts.

I just wanted to point out the root cause of KVM's usability problems as i see 
it - just like i was pointing out the mortal Xen design deficiencies back when 
i was backing KVM strongly, four years ago. Back then everyone was saying that 
i'm crazy and we are stuck with Xen forever and while KVM is nice it has no 
chance.

Just because you got the kernel bits of KVM right a few years ago does not 
mean you cannot mess up other design aspects, and sometimes badly so ;-) 
Historically i messed up more than half of all first-gut-feeling technical 
design decisions i did, so i had to correct the course many, many times.

I hope you are still keeping an open mind about it all and dont think that 
because the project was split for 4 years (to no fault of your own, simply out 
of necessity) it should be split forever ...

arch/x86 was split for a much longer period than that.

Circumstances have changed. Most Qemu users/contributions are now coming from 
the KVM angle, so please simply start thinking about the next level of 
evolution.

Thanks,

	Ingo
