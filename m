Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab1BJMox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:44:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40222 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123Ab1BJMow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:44:52 -0500
Date: Thu, 10 Feb 2011 13:44:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, anton@samba.org,
        Mike Travis <travis@sgi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PULL] cpumask offstack finalization
Message-ID: <20110210124416.GE26094@elte.hu>
References: <201102091608.59448.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102091608.59448.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> Hi Ingo,
> 
>    A few more obsolete uses of cpumask has crept into the tree; all easily
> fixed.  This is rebased onto your -tip tree and re-tested; it finally means
> that we can detect obsolescent (and hence dangerous) cpumask usage when 
> CONFIG_CPUMASK_OFFSTACK=y.  It finally reduces the actual allocation of
> cpumask_var_t to the number of cpus we actually have.

Hm, could we get rid of the obsolete percpu APIs once and for all? The fact that 
they are still around cause the leakage into new code to begin with.

> I assume you want these via your tree: they definitely need testing across 
> architectures, though the transforms are mechanical.

Can do i guess - we can cross-test most architectures in -tip and via -next there 
will be more testing. No need to spread this out via a zillion maintainer trees i 
think.

Thanks,

	Ingo
