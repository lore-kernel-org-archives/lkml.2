Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab0LVL0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:26:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53589 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab0LVL0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:26:50 -0500
Date: Wed, 22 Dec 2010 12:26:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, fweisbec@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
        dannf@hp.com
Subject: Re: [PATCH] x86, nmi_watchdog:  Remove ARCH_HAS_NMI_WATCHDOG and
 rely on CONFIG_HARDLOCKUP_DETECTOR
Message-ID: <20101222112636.GH3127@elte.hu>
References: <1292602853-21412-1-git-send-email-dzickus@redhat.com>
 <20101218153326.GA15675@elte.hu>
 <20101220153716.GB19138@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220153716.GB19138@redhat.com>
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

> On Sat, Dec 18, 2010 at 04:33:26PM +0100, Ingo Molnar wrote:
> > 
> > * Don Zickus <dzickus@redhat.com> wrote:
> > 
> > > The x86 arch has shifted its use of the nmi_watchdog from a local implementation 
> > > to the global one provide by kernel/watchdog.c.  This shift has caused a whole 
> > > bunch of compile problems under different config options.  I attempt to simplify 
> > > things with the patch below.
> > 
> > ok, this patch is looking better - but even after applying it to -tip (and resolving 
> > the conflict) i get this link failure on 64-bit allyesconfig:
> 
> Sorry about the conflict.  I guess I stupidly based the patch ontop of the
> small hack patch I sent to you a couple of hours before I sent this patch.
> 
> > 
> > watchdog.c:(.text+0x7eacc): undefined reference to `hw_nmi_get_sample_period'
> 
> That said, I'm not sure how you resolved the conflict, but the define
> ARCH_HAS_NMI_WATCHDOG should not be in the arch/x86/kernel/apic/hw_nmi.c
> file.
> 
> Other than that, I am unable to reproduce the error you are seeing.
> Looking at the code, 'hw_nmi_get_sample_period' is defined in one file and
> called in one spot in another file.  Both cases that code is wrapped only
> with CONFIG_HARDLOCKUP_DETECTOR, so I at a loss on where it would fail.
> 
> Do you have a branch I can look at it, just to double check?

Not anymore - could you please send a patch that applies cleanly to -tip - that way 
we eliminate all misinterpretation.

Thanks,

	Ingo
