Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab0HHVX3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 17:23:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54949 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab0HHVX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 17:23:28 -0400
Date: Sun, 8 Aug 2010 23:23:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH] lockup_detector: Make DETECT_HUNT_TASK default depend on
 LOCKUP_DETECTOR
Message-ID: <20100808212311.GA7194@elte.hu>
References: <4C58C7FF.5060906@cn.fujitsu.com>
 <20100806005801.GB5436@nowhere>
 <20100807070135.GC23108@elte.hu>
 <20100808195839.GA5387@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100808195839.GA5387@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > The thing is, CONFIG_DETECT_SOFTLOCKUP was default-y before, so many 
> > people had it enabled [and had it forced-enabled if DEBUG_KERNEL was off], 
> > even if they didnt really want or need it.
> 
> Hmm. It was:
> 
> config DETECT_SOFTLOCKUP
> 	bool "Detect Soft Lockups"
> 	depends on DEBUG_KERNEL && !S390
> 	default y
> 
> It means it's default enabled only if DEBUG_KERNEL, right? Then if you don't 
> select CONFIG_DEBUG_KERNEL, it's fine as it won't be selected.

Indeed, you are right.

Anyway, i think the general point remains: i'm not sure we should 
default-enable this feature.

> But I agree with you. There is a bunch of config options for which selection 
> is a duty when you are a kernel developer: PROVE_LOCKING, DETECT_HUNG_TASK, 
> DEBUG_PREEMPT, PROVE_RCU, etc... Because they all show (or prove we can 
> have) bugs that one might miss without these options. Softlockups are rarely 
> part of them because even without the lockup detector enabled, you'll 
> observe something is wrong.

Note that it's now detecting all kinds of lockups: softlockups, hard lockups 
and even unkillable hung tasks.

	Ingo
