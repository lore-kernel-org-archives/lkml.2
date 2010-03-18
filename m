Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab0CRLst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 07:48:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42456 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab0CRLsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 07:48:47 -0400
Date: Thu, 18 Mar 2010 12:48:21 +0100
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
Message-ID: <20100318114821.GB13168@elte.hu>
References: <20100316130840.GA24808@elte.hu>
 <4B9FBA8B.8020200@codemonkey.ws>
 <20100316173940.GA23859@elte.hu>
 <4BA00F1F.1090907@codemonkey.ws>
 <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
 <20100318085607.GB2157@elte.hu>
 <4BA1FC80.2000401@redhat.com>
 <20100318105013.GB24464@elte.hu>
 <4BA20EB8.60707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA20EB8.60707@redhat.com>
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

> On 03/18/2010 12:50 PM, Ingo Molnar wrote:
> >* Avi Kivity<avi@redhat.com>  wrote:
> >
> >>>The moment any change (be it as trivial as fixing a GUI detail or as
> >>>complex as a new feature) involves two or more packages, development speed
> >>>slows down to a crawl - while the complexity of the change might be very
> >>>low!
> >>Why is that?
> > It's very simple: because the contribution latencies and overhead compound,
> > almost inevitably.
> 
> It's not inevitable, if the projects are badly run, you'll have high 
> latencies, but projects don't have to be badly run.

So the 64K dollar question is, why does Qemu still suck?

> 
> >If you ever tried to implement a combo GCC+glibc+kernel feature you'll know
> >...
> >
> >Even with the best-run projects in existence it takes forever and is very
> >painful - and here i talk about first hand experience over many years.
> 
> Try sending a patch to qemu-devel@, you may be pleasantly surprised.
> 
> 
> >>I the maintainers of all packages are cooperative and responsive, then the
> >>patches will get accepted quickly.  If they aren't, development will be
> >>slow. [...]
> >I'm afraid practice is different from the rosy ideal you paint there. Even
> >with assumed 'perfect projects' there's always random differences between
> >projects, causing doubled (tripled) overhead and compounded up overhead:
> >
> >  - random differences in release schedules
> >
> >  - random differences in contribution guidelines
> >
> >  - random differences in coding style
> 
> None of these matter for steady contributors.
> 
> >>[...] It isn't any different from contributing to two unrelated kernel
> >>subsystems (which are in fact in different repositories until the next merge
> >>window).
> >You mention a perfect example: contributing to multipe kernel subsystems. Even
> >_that_ is very noticeably harder than contributing to a single subsystem - due
> >to the inevitable buerocratic overhead, due to different development trees,
> >due to different merge criteria.
> >
> >So you are underlining my point (perhaps without intending to): treating
> >closely related bits of technology as a single project is much better.
> >
> > Obviously arch/x86/kvm/, virt/ and tools/kvm/ should live in a single 
> > development repository (perhaps micro-differentiated by a few topical 
> > branches), for exactly those reasons you mention.
> 
> How is a patch for the qemu GUI eject button and the kvm shadow mmu related?  
> Should a single maintainer deal with both?

We have co-maintainers for perf that have a different focus. It works pretty 
well.

Look at git log tools/perf/ and how user-space and kernel-space components 
interact in practice. You'll patches that only impact one side, but you'll see 
very big overlap both in contributor identity and in patches as well.

Also, let me put similar questions in a bit different way:

 - ' how is an in-kernel PIT emulation connected to Qemu's PIT emulation? '

 - ' how is the in-kernel dynticks implementation related to Qemu's 
     implementation of hardware timers? '

 - ' how is an in-kernel event for a CD-ROM eject connected to an in-Qemu 
     eject event? '

 - ' how is a new hardware virtualization feature related to being able to 
     configure and use it via Qemu? '

 - ' how is the in-kernel x86 decoder/emulator related to the Qemu x86 
     emulator? '

 - ' how is the performance of the qemu GUI related to the way VGA buffers are 
     mapped and accelerated by KVM? '

They are obviously deeply related. The quality of a development process is not 
defined by the easy cases where no project unification is needed. The quality 
of a development process is defined by the _difficult_ cases.

	Ingo
