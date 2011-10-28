Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab1J1HuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 03:50:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50400 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549Ab1J1HuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 03:50:15 -0400
Date: Fri, 28 Oct 2011 09:48:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, hpa@zytor.com,
        jeremy.fitzhardinge@citrix.com, mingo@redhat.com, stable@kernel.org,
        tglx@linutronix.de, Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [Xen tree maintenance] Re: Not really merged? Re: [merged]
 x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode.patch
 removed from -mm tree
Message-ID: <20111028074810.GB27593@elte.hu>
References: <201110141951.p9EJpn3A006989@hpaq5.eem.corp.google.com>
 <20111025182450.GA9843@phenom.dumpdata.com>
 <20111027155329.0adc1358.akpm@linux-foundation.org>
 <20111028070838.GG12995@elte.hu>
 <20111028003935.a75d16b6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111028003935.a75d16b6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > > > Hey Andrew,
> > > > 
> > > > I am actually not seeing this in mainline? Was it accidently 
> > > > dropped out of your tree?
> > > 
> > > hm, well spotted.  I'm not sure what happened here - possibly 
> > > the patch was merged into an x86 tree (and hence linux-next) 
> > > but later got lost. Or possibly not, and I just screwed up.
>
> > No, a patch with the -i 'paravirt.*lazy' pattern never touched 
> > -tip, even temporarily.
> >
> > Could it be that someone else (say the Xen guys) picked it up, it 
> > went into linux-next, you thought it's applied - but then they 
> > dropped it?
> > 
> > Do we have a full log of all linux-next patches?
> 
> Don't know.
> 
> The patch was present in the linux-next which I pulled on 14 Oct.  
> It is no longer in linux-next.
[...]

> My drop was legitimate. 
> 
> Here's the commit from the Oct 14 linux-next:
> 
> 
> commit ab67482036cee590753dd42b7f66aada97e6dcde
> Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> AuthorDate: Fri Sep 23 17:02:29 2011 -0400
> Commit:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> CommitDate: Mon Sep 26 09:12:37 2011 -0400

ARGH!

Konrad, STOP THIS CRAP!

This is the Nth time you have interefered with the x86 tree's 
workflow - and now you have caused patch loss in -mm.

I'll have to insist on the Xen tree being merged via the x86 tree 
again, this clearly does not work, your maintenance practices are 
VERY incompetent and you are not learning.

The rule is very simple: don't EVER push anything arch/x86/ into 
linux-next that is outside the arch/x86/xen/ and 
arch/x86/include/asm/xen/ patterns, without very clear acks from the 
x86 maintainers and a binding promise to carry that patch upstream!

Thanks,

	Ingo
