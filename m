Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab0CROhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:37:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38688 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715Ab0CROhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:37:24 -0400
Date: Thu, 18 Mar 2010 15:36:56 +0100
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
Message-ID: <20100318143656.GA20182@elte.hu>
References: <20100318101025.GA13073@elte.hu>
 <4BA1FEB0.7000400@redhat.com>
 <20100318113527.GA13168@elte.hu>
 <y0m4okdzu4z.fsf@fche.csb>
 <20100318130226.GB7424@elte.hu>
 <4BA22663.7070509@redhat.com>
 <20100318133124.GA25642@elte.hu>
 <4BA22E9E.4000607@redhat.com>
 <20100318135700.GC25642@elte.hu>
 <4BA237E2.10303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA237E2.10303@redhat.com>
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

> > Happy choice or not, this is what i said is the distro practice these 
> > days. (i dont know all the distros that well so i'm sure there's 
> > differences)
> 
> So in addition to all the normal kernel regressions, you want to force 
> tools/kvm/ regressions on users.

So instead you force a NxN compatibility matrix [all versions of qemu combined 
with all versions of the kernel] instead of a linear N versions matrix with a 
clear focus on the last version. Brilliant engineering i have to say ;-)

Also, by your argument the kernel should be split up into a micro-kernel, with 
different packages for KVM, scheduler, drivers, upgradeable separately.

That would be a nightmare. (i can detail many facets of that nightmare if you 
insist but i'll spare the electrons for now) Fortunately few kernel developers 
share your views about this.

> > > I don't mind at all if rawhide users run on the latest and greatest, but 
> > > release users deserve a little more stability.
> >
> > What are you suggesting, that released versions of KVM are not reliable? 
> > Of course any tools/ bits are release engineered just as much as the rest 
> > of KVM ...
> 
> No, I am suggesting qemu-kvm.git is not as stable as released versions (and 
> won't get fixed backported).  Keep in mind that unlike many userspace 
> applications, qemu exposes an ABI to guests which we must keep compatible.

I think you still dont understand it: if a tool moves to the kernel repo, then 
it is _released stable_ together with the next stable kernel.

I.e. you'd get a stable qemu-2.6.34 in essence, when v2.6.34 is released. You 
get minor updates with 2.6.34.1, 2.6.34.2, 2.6.34.3, etc - while development 
continues.

I.e. you get _more_ stability, because a matching kernel is released with a 
matching Qemu.

Qemu might have a different release schedule. Which, i argue, is not a good 
thing for exactly that reason :-) If it moved to tools/kvm/ it would get the 
same 90 days release frequency, merge window and stabilization window 
treatment as the upstream kernel.

Furthermore, users can also run experimental versions of qemu together with 
experimental versions of the kernel, by running something like 2.6.34-rc1 on 
Rawhide. Even if they dont download the latest qemu git and build it.

I.e. clearly _more_ is possible in such a scheme.

	Ingo
