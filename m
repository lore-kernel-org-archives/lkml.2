Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab0CRN53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 09:57:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43549 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab0CRN51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:57:27 -0400
Date: Thu, 18 Mar 2010 14:57:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Alexander Graf <agraf@suse.de>,
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
Message-ID: <20100318135700.GC25642@elte.hu>
References: <20100318085607.GB2157@elte.hu>
 <F0F75B33-C0BA-42EB-BFC4-D60B1E232E6D@suse.de>
 <20100318101025.GA13073@elte.hu>
 <4BA1FEB0.7000400@redhat.com>
 <20100318113527.GA13168@elte.hu>
 <y0m4okdzu4z.fsf@fche.csb>
 <20100318130226.GB7424@elte.hu>
 <4BA22663.7070509@redhat.com>
 <20100318133124.GA25642@elte.hu>
 <4BA22E9E.4000607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA22E9E.4000607@redhat.com>
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

> On 03/18/2010 03:31 PM, Ingo Molnar wrote:
> >* Avi Kivity<avi@redhat.com>  wrote:
> >
> >>On 03/18/2010 03:02 PM, Ingo Molnar wrote:
> >>>>[...] What users eagerly replace their kernels?
> >>>Those 99% who click on the 'install 193 updates' popup.
> >>>
> >>Of which 1 is the kernel, and 192 are userspace updates (of which one may be
> >>qemu).
> >I think you didnt understand my (tersely explained) point - which is probably
> >my fault. What i said is:
> >
> >  - distros update the kernel first. Often in stable releases as well if
> >    there's a new kernel released. (They must because it provides new hardware
> >    enablement and other critical changes they generally cannot skip.)
> 
> No, they don't. [...]

I just replied to Frank Ch. Eigler with a specific example that shows how this 
happens - and believe me, it happens.

> [...]  RHEL 5 is still on 2.6.18, for example.  Users
> don't like their kernels updated unless absolutely necessary, with
> good reason.

Nope - RHEL 5 is on a 2.6.18 base for entirely different reasons.

> Kernel updates = reboots.

If you check the update frequency of RHEL 5 kernels you'll see that it's 
comparable to that of Fedora.

> >  - Qemu on the other hand is not upgraded with (nearly) that level of urgency.
> >    Completely new versions will generally have to wait for the next distro
> >    release.
> 
> F12 recently updated to 2.6.32.  This is probably due to 2.6.31.stable 
> dropping away, and no capacity at Fedora to maintain it on their own.  So 
> they are caught in a bind - stay on 2.6.31 and expose users to security 
> vulnerabilities or move to 2.6.32 and cause regressions.  Not a happy 
> choice.

Happy choice or not, this is what i said is the distro practice these days. (i 
dont know all the distros that well so i'm sure there's differences)

> > With in-kernel tools the kernel and the tooling that accompanies the kernel
> > are upgraded in the same low-latency pathway. That is a big plus if you are
> > offering things like instrumentation (which perf does), which relates closely
> > to the kernel.
> >
> > Furthermore, many distros package up the latest -git kernel as well. They
> > almost never do that with user-space packages.
> 
> I'm sure if we ask the Fedora qemu maintainer to package qemu-kvm.git 
> they'll consider it favourably.  Isn't that what rawhide is for?

Rawhide is generally for latest released versions, to ready them for the next 
distro release - with special exception for the kernel, which has a special 
position due being a hardware-enabler and because it has an extremely 
predictable release schedule of every 90 days (+- 10 days).

Very rarely do distro people jump versions for things like GCC or Xorg or 
Gnome/KDE, but they've been burned enough times by unexpected delays in those 
projects to be really loathe to do it.

Qemu might get an exception - dunno, you could ask. My point still holds: by 
hosting KVM user-space bits in the kernel together with the rest of KVM you 
get version parity - which has clear advantages.

You also might have more luck with a bleeding-edge distro such as Gentoo.

> >Let me give you a specific example:
> >
> >I'm running Fedora Rawhide with 2.6.34-rc1 right now on my main desktop, and
> >that comes with perf-2.6.34-0.10.rc1.git0.fc14.noarch.
> >
> >My rawhide box has qemu-kvm-0.12.3-3.fc14.x86_64 installed. That's more than a
> >1000 Qemu commits older than the latest Qemu development branch.
> >
> >So by being part of the kernel repo there's lower latency upgrades and earlier
> >and better testing available on most distros.
> >
> >You made it very clear that you dont want that, but please dont try to claim
> >that those advantages do not exist - they are very much real and we are making
> >good use of it.
> 
> I don't mind at all if rawhide users run on the latest and greatest, but 
> release users deserve a little more stability.

What are you suggesting, that released versions of KVM are not reliable? Of 
course any tools/ bits are release engineered just as much as the rest of KVM 
...

	Ingo
