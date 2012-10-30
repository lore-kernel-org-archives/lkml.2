Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab2J3JRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 05:17:36 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37998 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2J3JRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 05:17:33 -0400
Date: Tue, 30 Oct 2012 10:17:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Alexander Graf <agraf@suse.de>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [GIT PULL] cputime: Cleanups and optimizations
Message-ID: <20121030091727.GB10272@gmail.com>
References: <1351187283-20715-1-git-send-email-fweisbec@gmail.com>
 <1351555036-23545-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351555036-23545-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the latest cputime cleanups that can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git tags/cputime-cleanups-for-mingo
> 
> for you to fetch changes up to 3e1df4f506836e6bea1ab61cf88c75c8b1840643:
> 
>   cputime: Separate irqtime accounting from generic vtime (2012-10-29 21:31:32 +0100)
> 
> It is based on top of tip:sched/core of today.
> 
> Tested on x86 and powerpc. Built-tested only on ia64 and s390.
> 
> Thanks.
> 
> ----------------------------------------------------------------
> Cputime cleanups and optimizations:
> 
> * Gather vtime headers that were a bit scattered around
> 
> * Separate irqtime and vtime namespaces that were
> colliding, resulting in useless calls to irqtime accounting.
> 
> * Slightly optimize irq and guest vtime accounting.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> ----------------------------------------------------------------
> Frederic Weisbecker (5):
>       vtime: Gather vtime declarations to their own header file
>       vtime: Make vtime_account_system() irqsafe
>       kvm: Directly account vtime to system on guest switch
>       cputime: Specialize irq vtime hooks
>       cputime: Separate irqtime accounting from generic vtime
> 
>  arch/ia64/kernel/time.c     |    8 ++++----
>  arch/powerpc/kernel/time.c  |    4 ++--
>  arch/s390/kernel/vtime.c    |    4 ++++
>  arch/s390/kvm/kvm-s390.c    |    4 ----
>  include/linux/hardirq.h     |   15 +++-----------
>  include/linux/kernel_stat.h |    9 +--------
>  include/linux/kvm_host.h    |   12 +++++++++--
>  include/linux/vtime.h       |   47 +++++++++++++++++++++++++++++++++++++++++++
>  kernel/sched/cputime.c      |   20 +++++++++++++-----
>  kernel/softirq.c            |    6 +++---
>  10 files changed, 89 insertions(+), 40 deletions(-)
>  create mode 100644 include/linux/vtime.h

Pulled, thanks Frederic!

	Ingo
