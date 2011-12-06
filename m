Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab1LFRpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:45:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59935 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab1LFRpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:45:03 -0500
Date: Tue, 6 Dec 2011 18:43:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Nick Bowler <nbowler@elliptictech.com>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, ben@decadent.org.uk,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] lockdep, bug: Exclude
 TAINT_FIRMWARE_WORKAROUND from disabling lockdep
Message-ID: <20111206174320.GA25031@elte.hu>
References: <tip-xopopjjens57r0i13qnyh2yo@git.kernel.org>
 <20111206151345.GA22353@elliptictech.com>
 <20111206154206.441e85c6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206154206.441e85c6@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Tue, 6 Dec 2011 10:13:45 -0500
> Nick Bowler <nbowler@elliptictech.com> wrote:
> 
> > On 2011-12-06 01:38 -0800, tip-bot for Peter Zijlstra wrote:
> > > Commit-ID:  df754e6af2f237a6c020c0daff55a1a609338e31
> > > Gitweb:     http://git.kernel.org/tip/df754e6af2f237a6c020c0daff55a1a609338e31
> > > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > AuthorDate: Mon, 14 Nov 2011 13:13:49 +0100
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Tue, 6 Dec 2011 08:16:47 +0100
> > > 
> > > lockdep, bug: Exclude TAINT_FIRMWARE_WORKAROUND from disabling lockdep
> > > 
> > > It's unlikely that TAINT_FIRMWARE_WORKAROUND causes false
> > > lockdep messages, so do not disable lockdep in that case.
> > > We still want to keep lockdep disabled in the
> > > TAINT_OOT_MODULE case:
> > > 
> > >   - bin-only modules can cause various instabilities in
> > >     their and in unrelated kernel code
> > > 
> > >   - they are impossible to debug for kernel developers
> > > 
> > >   - they also typically do not have the copyright license
> > >     permission to link to the GPL-ed lockdep code.
> > 
> > This is all bogus.  We have a proprietary module taint for the above.
> > Out of tree does not mean "bin-only", "non-GPL" or anything else like
> > that.  
> 
> It also stops people developing drivers of their own who are 
> not building them in the kernel tree currently (eg when I'm 
> building tests of the GMA500 graphics driver). This is a 
> ludicrous patch and should be reverted

That patch is already upstream, it was done via the module tree:

 2449b8ba0745: module,bug: Add TAINT_OOT_MODULE flag for modules not built in-tree

lockdep disabling itself defensively is an effect of that 
change. The commit you replied to here does not change that 
aspect in any way.

My primary worry is to not have lockdep active when there's 
binary modules in a system - can TAINT_OOT_MODULE be set but 
TAINT_PROPRIETARY_MODULE not set for non-GPL modules?

If not, and if TAINT_OOT_MODULE set and TAINT_PROPRIETARY_MODULE 
cleared guarantees the GPL-ness of the module then i have no 
problem with keeping lockdep active in that case.

Thanks,

	Ingo
