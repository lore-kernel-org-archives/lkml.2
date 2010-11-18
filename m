Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab0KROte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:49:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50269 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758759Ab0KROtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:49:33 -0500
Date: Thu, 18 Nov 2010 15:49:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/3] x86: only call smp_processor_id in non-preempt cases
Message-ID: <20101118144921.GB28350@elte.hu>
References: <1289573455-3410-1-git-send-email-dzickus@redhat.com>
 <20101118081407.GB23481@elte.hu>
 <20101118142213.GB18100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118142213.GB18100@redhat.com>
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


* Don Zickus <dzickus@redhat.com> wrote:

> On Thu, Nov 18, 2010 at 09:14:07AM +0100, Ingo Molnar wrote:
> > 
> > * Don Zickus <dzickus@redhat.com> wrote:
> > 
> > > There are some paths that walk the die_chain with preemption on.
> > 
> > What are those codepaths? At minimum it's worth documenting them.
> 
> Well the one that caused the bug was do_general_protection which walks the
> die_chain with DIE_GPF.
> 
> I can document them, though it might be time consuming to audit them and hope they 
> don't change.

Listing one example is enough.

> [...]  I guess my bigger question is, is it expected that anyone who calls the 
> die_chain to have preemption disabled?  If not, then does it matter if we document 
> it?

Yes, it might be a bug to call those handlers with preemption on (or even with irqs 
on). But if the code is fine as-is then documenting a single example would be nice.

Thanks,

	Ingo
