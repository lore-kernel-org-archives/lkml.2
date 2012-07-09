Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab2GIRvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:51:04 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:36276 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab2GIRvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:51:02 -0400
Date: Mon, 9 Jul 2012 19:50:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/4] cputime: Virtual cputime accounting small cleanups
 and consolidation
Message-ID: <20120709175053.GE8185@somewhere.redhat.com>
References: <1340113391-1896-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340113391-1896-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 03:43:07PM +0200, Frederic Weisbecker wrote:
> Not sure to which tree this should go. The scheduler one may be.
> Anyway if you're fine with it, it is pullable at:
> 
> git://github.com/fweisbec/linux-dynticks.git
> 	virt-cputime

Ping. Are you guys fine with the patchset?

> 
> This is only built tested on the relevant archs.
> 
> I wish we could do more vtime cputime accounting consolidation
> but archs do the things pretty differently although I bet the
> behaviour could be more unified.
> 
> 
> Frederic Weisbecker (4):
>   cputime: Generalize CONFIG_VIRT_CPU_ACCOUNTING
>   sched: Move cputime code to its own file
>   cputime: Consolidate vtime handling on context switch
>   s390: Remove leftover account_tick_vtime() header
> 
>  arch/Kconfig                           |    3 +
>  arch/ia64/Kconfig                      |   12 +-
>  arch/ia64/include/asm/switch_to.h      |    8 -
>  arch/ia64/kernel/time.c                |    4 +-
>  arch/powerpc/include/asm/time.h        |    6 -
>  arch/powerpc/kernel/process.c          |    3 -
>  arch/powerpc/kernel/time.c             |    6 +
>  arch/powerpc/platforms/Kconfig.cputype |   16 +-
>  arch/s390/Kconfig                      |    5 +-
>  arch/s390/include/asm/switch_to.h      |    4 -
>  arch/s390/kernel/vtime.c               |    4 +-
>  include/linux/kernel_stat.h            |    6 +
>  init/Kconfig                           |   13 +
>  kernel/sched/Makefile                  |    2 +-
>  kernel/sched/core.c                    |  552 +-------------------------------
>  kernel/sched/cputime.c                 |  497 ++++++++++++++++++++++++++++
>  kernel/sched/sched.h                   |   63 ++++
>  17 files changed, 600 insertions(+), 604 deletions(-)
>  create mode 100644 kernel/sched/cputime.c
> 
> -- 
> 1.7.5.4
> 
