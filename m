Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762597Ab0HGHCc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 03:02:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60805 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805Ab0HGHC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 03:02:27 -0400
Date: Sat, 7 Aug 2010 09:01:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] lockup_detector: Make DETECT_HUNT_TASK default depend on
 LOCKUP_DETECTOR
Message-ID: <20100807070135.GC23108@elte.hu>
References: <4C58C7FF.5060906@cn.fujitsu.com>
 <20100806005801.GB5436@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100806005801.GB5436@nowhere>
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


(Linus Cc:-ed)

* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, Aug 04, 2010 at 09:53:03AM +0800, Li Zefan wrote:
> > CONFIG_DETECT_SOFTLOCKUP has been removed, so switch the
> > default value to LOCKUP_DETECTOR.
> > 
> > Also fix the help text of BOOT_PRINTK_DELAY.
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > ---
> 
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Thanks.

The thing is, CONFIG_DETECT_SOFTLOCKUP was default-y before, so many people 
had it enabled [and had it forced-enabled if DEBUG_KERNEL was off], even if 
they didnt really want or need it.

So i turned off the new generic watchdog code's default intentionally - as it 
clearly does not cure cancer ;-)

I think distros will enable it, and most testers will as well. Those who dont 
enable it and run into a lockup have an easy option to enable.

Maybe a better change would be to make it more generally available - right now 
it's:

 config LOCKUP_DETECTOR
         bool "Detect Hard and Soft Lockups"
         depends on DEBUG_KERNEL && !S390

which means that it cannot be enabled when DEBUG_KERNEL is off.

So i think we should:

 - Remove the s390 hack and add an ARCH_HAS_LOCKUP_DETECTOR flag
 - Remove the DEBUG_KERNEL dependency

Hm?

Thanks,

	Ingo
