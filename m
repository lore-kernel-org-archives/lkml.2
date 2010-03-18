Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab0CRJyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:54:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41991 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233Ab0CRJyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:54:33 -0400
Date: Thu, 18 Mar 2010 10:54:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100318095418.GD2157@elte.hu>
References: <20100316112500.GA5337@elte.hu>
 <4B9F77E7.2060101@redhat.com>
 <20100316122903.GA8831@elte.hu>
 <4B9F7C6A.3070207@redhat.com>
 <20100316130840.GA24808@elte.hu>
 <4B9FBA8B.8020200@codemonkey.ws>
 <20100316173940.GA23859@elte.hu>
 <4BA00F1F.1090907@codemonkey.ws>
 <20100317081041.GC16374@elte.hu>
 <4BA1E7E2.3010803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA1E7E2.3010803@redhat.com>
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


* Jes Sorensen <Jes.Sorensen@redhat.com> wrote:

> On 03/17/10 09:10, Ingo Molnar wrote:
>
> > I wish both you and Avi looked back 3-4 years and realized what made KVM 
> > so successful back then and why the hearts and minds of virtualization 
> > developers were captured by KVM almost overnight.
> 
> Ingo,
> 
> What made KVM so successful was that the core kernel of the hypervisor was 
> designed the right way, as a kernel module where it belonged. It was obvious 
> to anyone who had been exposed to the main competition at the time, Xen, 
> that this was the right approach. What has ended up killing Xen in the end 
> is the not-invented-here approach of copying everything over, reformatting 
> it, and rewriting half of it, which made it impossible to maintain and 
> support as a single codebase. [...]

Yes, exactly.

I was part of that nightmare so i know.

> [...]
>
> At my previous employer we ended up dropping all Xen efforts exactly because 
> it was like maintaining two separate operating system kernels. The key to 
> KVM is that once you have Linux, you practically have KVM as well.

Yes. Please realize that what is behind it is a strikingly simple argument:

 "Once you have a single project to develop and maintain all is much better."

> > Fast forward to 2010. The kernel side of KVM is maximum goodness - by far 
> > the worst-quality remaining aspects of KVM are precisely in areas that you 
> > mention: 'if we have to support third party tools, then it significantly 
> > complicates things'. You kept Qemu as an external 'third party' entity to 
> > KVM, and KVM is clearly hurting from that - just see the recent KVM 
> > usability thread for examples about suckage.
> >
> > So a similar 'complication' is the crux of the matter behind KVM quality 
> > problems: you've not followed through with the original KVM vision and you 
> > have not applied that concept to Qemu!
> 
> Well there are two ways to go about this. Either you base the KVM userland 
> on top of an existing project, like QEMU, _or_ you rewrite it all from 
> scratch. [...]

Btw., i made similar arguments to Avi about 3 years ago when it was going 
upstream, that qemu should be unified with KVM. This is more true today than 
ever.

> [...] However, there is far more to it than just a couple of ioctls, for 
> example the stack of reverse device-drivers is a pretty significant code 
> base, rewriting that and maintaining it is not a trivial task. It is 
> certainly my belief that the benefit we get from sharing that with QEMU by 
> far outweighs the cost of forking it and keeping our own fork in the kernel 
> tree. In fact it would result in exactly the same problems I mentioned above 
> wrt Xen.

I do not suggest forking Qemu at all, i suggest using the most natural 
development model for the KVM+Qemu shared project: a single repository.

> > If you want to jump to the next level of technological quality you need to 
> > fix this attitude and you need to go back to the design roots of KVM. 
> > Concentrate on Qemu (as that is the weakest link now), make it a first 
> > class member of the KVM repo and simplify your development model by having 
> > a single repo:
> >
> >  - move a clean (and minimal) version of the Qemu code base to tools/kvm/,
> >    in the upstream kernel repo, and work on that from that point on.
> 
> With this you have just thrown away all the benefits of having the QEMU 
> repository shared with other developers who will actively fix bugs in 
> components we do care about for KVM.

Not if it's a unified project.

> >  - encourage kernel-space and user-space KVM developers to work on both
> >    user-space and kernel-space bits as a single unit. It's one project and 
> >    a single experience to the user.
> 
> This is already happening and a total non issue.

My experience as an external observer of the end result contradicts this.

Seemingly trivial usability changes to the KVM+Qemu combo are not being done 
often because they involve cross-discipline changes.

( _In this very thread_ there has been a somewhat self-defeating argument by 
  Anthony that multi-package scenario would 'significantly complicate' 
  matters. What more proof do we need to state the obvious? Keeping what
  has become one piece of technology over the years in two separate halves is
  obviously bad. )

> >  - [ and probably libvirt should go there too ]
> 
> Now that would be interesting, next we'll have to include things like libxml 
> in the kernel git tree as well, to make sure libvirt doesn't get out of sync 
> with the version supplied by your distribution vendor.

The way we have gone about this in tools/perf/ is similar to the route picked 
by Git: we only use very lowlevel libraries available everywhere, and we 
provide optional wrappers to the rest.

We are also using the kernel's libraries so we rarely need to go outside to 
get some functionality.

I.e. it's a non-issue in practice and despite perf having an (optional) 
dependency on xmlto and docbook we dont include those packages nor do we force 
users to install particular versions of them.

> > Yes, i've read a thousand excuses for why this is an absolutely impossible 
> > and a bad thing to do, and none of them was really convincing to me - and 
> > you also have become rather emotional about all the arguments so it's hard 
> > to argue about it on a technical basis.
> 
> So far your argument would justify pulling all of gdb into the kernel git 
> tree as well, to support the kgdb efforts, or gcc so we can get rid of the 
> gcc version quirks in the kernel header files, e2fsprogs and equivalent for 
> _all_ file systems included in the kernel so we can make sure our fs tools 
> never get out of sync with whats supported in the kernel......

gdb and gcc is clearly extrinsic to the kernel so why would we move them 
there?

I was talking about tools that are closely related to the kernel - where much 
of the development and actual use is in combination with the Linux kernel.

90%+ of the Qemu usecases are combined with Linux. (Yes, i know that you can 
run Qemu without KVM, and no, i dont think it matters in the grand scheme of 
things and most investment into Qemu comes from the KVM angle these days. In 
particular it for sure does not justify handicapping future KVM evolution so 
drastically.)

> > We made a similar (admittedly very difficult ...) design jump from 
> > oprofile to perf, and i can tell you from that experience that it's day 
> > and night, both in terms of development and in terms of the end result!
> 
> The user components for perf vs oprofile are _tiny_ projects compared to the 
> portions of QEMU that are actually used by KVM.

I know the size and scope of Qemu, i even hacked it - still my points remain. 
(my arguments are influenced and strengthened by that past hacking experience)

> Oh and you completely forgot SeaBIOS. KVM+QEMU rely on SeaBIOS too, so from 
> what you're saying we should pull that into the kernel git repository as 
> well. Never mind the fact that we share SeaBIOS with the coreboot project 
> which is very actively adding features to it that benefit us as well.....

SeaBIOS is in essence a firmware, so it could either be loaded as such.

Just look at the qemu source code - the BIOSes are .bin images in 
qemu/pc-bios/ imported externally in essence.

Moving qemu to tools/kvm/ would not change that much. The firmware could 
become part of /lib/firmware/*.bin.

( That would probably be a more intelligent approach to the BIOS image import 
  problem as well. )

> Sorry, but there are times when unification make sense, and there are times 
> where having a reasonably well designed split makes sense. KVM had problems 
> with QEMU in the past which resulted in the qemu-kvm branch of it, which 
> proved to be a major pain to deal with, but that is fortunately improving 
> and qemu-kvm should go away completely at some point.

qemu-kvm branch is not similar to my proposal at all: it made KVM _more_ 
fragmented, not more unified. I.e. it was a move in the exact opposite 
direction and i'd expect such a move to fail.

In fact the failure of qemu-kvm supports my point rather explicitly: it 
demonstrates that extra packages and split development are actively harmful.

I speak about this as a person who has done successful unifications of split 
codebases and in my judgement this move would be significantly beneficial to 
KVM.

You cannot really validly reject this proposal with "It wont work" as it 
clearly has worked in other, comparable cases. You could only reject this with 
"I have tried it and it didnt work".

Think about it: a clean and hackable user-space component in tools/kvm/. It's 
very tempting :-)

	Ingo
