Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab0CYUvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 16:51:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52604 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726Ab0CYUvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 16:51:48 -0400
Date: Thu, 25 Mar 2010 21:51:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, peterz@infradead.org, tglx@linutronix.de,
       andi@firstfloor.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       jesse.brandeburg@intel.com
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
Message-ID: <20100325205124.GB27801@elte.hu>
References: <alpine.LFD.2.00.1003251054030.3721@i5.linux-foundation.org>
 <20100325182930.GA7709@elte.hu>
 <alpine.LFD.2.00.1003251206550.3721@i5.linux-foundation.org>
 <20100325.124220.258885098.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325.124220.258885098.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Thu, 25 Mar 2010 12:10:22 -0700 (PDT)
> 
> > On Thu, 25 Mar 2010, Ingo Molnar wrote:
> >> 
> >> So the patch below should at most trigger bugs in areas that need fixing 
> >> anyway, and i'm quite sure that under no circumstance would it cause 
> >> unforeseen problems in 'thousands of drivers'.
> > 
> > If we do this, then we should just remove all the IRQF_DISABLED code in 
> > kernel/irq/manage.c too, and basically make IRQF_DISABLED a clear no-op 
> > (still leave it around as a #define, to not break any users).
> 
> FWIW, I'm currently using IRQF_DISABLED for virtual network device 
> interrupts on sparc64 as a workaround for some stack overflow issues.

I think IRQF_DISABLED is the sanest method to run IRQs: it's the most atomic, 
thus most cache-efficient, it doesnt nest, and it's also a tiny bit faster to 
execute, by a few instructions (on x86).

> This change will just force me to work harder to find out a better way to 
> fix the problem, so don't let my issue hold this back, it's just an FYI...

The patch i sent basically hardcodes IRQF_DISABLED - so it should fix your 
problem automatically. IRQF_DISABLED will become an unconditional thing, and 
we can then also remove it.

	Ingo
