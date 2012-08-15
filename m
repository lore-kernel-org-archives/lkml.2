Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab2HOEy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 00:54:58 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:60479 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab2HOEy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 00:54:56 -0400
Date: Wed, 15 Aug 2012 06:54:50 +0200
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
 and consolidation v2
Message-ID: <20120815045447.GB19716@somewhere>
References: <1344953810-20564-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344953810-20564-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 04:16:46PM +0200, Frederic Weisbecker wrote:
> Hi,
> 
> No fundamental change in this release but a rebase to solve conflicts
> against latest tip:/sched/core commits.
> 
> Thanks.

This can be pulled from:

git://github.com/fweisbec/linux-dynticks.git
	virt-cputime-v2

This patchset, besides beeing a desired consolidation and
cleanup IMO, is necessary for the adaptive nohz feature
(see: http://comments.gmane.org/gmane.linux.kernel/1337690)

Thanks.

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
>  kernel/sched/core.c                    |  558 +-------------------------------
>  kernel/sched/cputime.c                 |  503 ++++++++++++++++++++++++++++
>  kernel/sched/sched.h                   |   63 ++++
>  17 files changed, 606 insertions(+), 610 deletions(-)
>  create mode 100644 kernel/sched/cputime.c
> 
> -- 
> 1.7.5.4
> 
