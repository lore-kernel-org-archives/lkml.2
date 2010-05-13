Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab0EMGF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 02:05:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42037 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992Ab0EMGFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 02:05:55 -0400
Date: Thu, 13 May 2010 08:05:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Eric Paris <eparis@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] Unified lockup detector
Message-ID: <20100513060517.GC697@elte.hu>
References: <1273713674-8434-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273713674-8434-1-git-send-regression-fweisbec@gmail.com>
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

> Ingo,
> 
> Please pull the perf/nmi branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/nmi
> 
> There is also a merge of v2.6.34-rc7 to catch up with latest
> softlockup changes and prevent from conflicts.
> 
> Thanks,
> 	Frederic
> ---
> 
> Don Zickus (7):
>       lockup_detector: Combine nmi_watchdog and softlockup detector
>       lockup_detector: Touch_softlockup cleanups and softlockup_tick removal
>       lockup_detector: Remove old softlockup code
>       lockup_detector: Remove nmi_watchdog.c file
>       x86: Move trigger_all_cpu_backtrace to its own die_notifier
>       x86: Cleanup hw_nmi.c cruft
>       lockup_detector: Separate touch_nmi_watchdog code path from touch_watchdog
> 
> Frederic Weisbecker (2):
>       lockup_detector: Make BOOTPARAM_SOFTLOCKUP_PANIC depend on LOCKUP_DETECTOR
>       lockup_detector: Fix forgotten config conversion
> 
> 
>  Documentation/kernel-parameters.txt |    2 +
>  arch/x86/include/asm/nmi.h          |    2 +-
>  arch/x86/kernel/apic/Makefile       |    4 +-
>  arch/x86/kernel/apic/hw_nmi.c       |  119 +++-----
>  arch/x86/kernel/traps.c             |    4 +-
>  include/linux/nmi.h                 |    8 +-
>  include/linux/sched.h               |   12 +-
>  init/Kconfig                        |    5 +-
>  kernel/Makefile                     |    3 +-
>  kernel/nmi_watchdog.c               |  259 ----------------
>  kernel/softlockup.c                 |  293 ------------------
>  kernel/sysctl.c                     |   52 ++--
>  kernel/timer.c                      |    1 -
>  kernel/watchdog.c                   |  564 +++++++++++++++++++++++++++++++++++
>  lib/Kconfig.debug                   |   32 ++-
>  15 files changed, 679 insertions(+), 681 deletions(-)

Pulled, thanks a lot guys! Was a long process, but the end result looks pretty 
nifty IMO.

	Ingo
