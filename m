Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab2JHWgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:36:22 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:47531 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab2JHWgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:36:16 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Alexander Graf <agraf@suse.de>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [PATCH 0/3] cputime: Moar cleanups / enhancements
Date: Tue,  9 Oct 2012 00:36:05 +0200
Message-Id: <1349735768-17586-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think that the 1st and 3rd patches are pretty uncontroversial given
how vtime_account() confusingly tries to do everything for
CONFIG_VIRT_CPU_ACCOUNTING and CONFIG_IRQ_TIME_ACCOUNTING.

I believe the 2nd is also desired. vtime_account() is called
two times per irq, sometimes more if softirqs are involved. So
I think we want to optimize that by calling directly its specialized
APIs when possible.

There is still some work to do but I'm proceeding step by step.
I may focuse more on that generic vtime implementation next
time to implement cputime accounting for the tickmess patchset.
That, for sure, will inspire for even more cputime optimizations/cleanups.

Thanks.

PS: tested on x86 and ppc64 (checked reliability of times and /proc/stat).
But only built tested on s390 and ia64.

Frederic Weisbecker (3):
  kvm: Directly account vtime to system on guest switch
  cputime: Specialize irq vtime hooks
  cputime: Separate irqtime accounting from generic vtime

 arch/ia64/kernel/time.c     |    1 +
 arch/powerpc/kernel/time.c  |    1 +
 arch/s390/kernel/vtime.c    |    4 ++
 include/linux/hardirq.h     |   80 +++++++++++++++++++++++++++++++++++--------
 include/linux/kernel_stat.h |    8 ----
 include/linux/kvm_host.h    |   12 +++++-
 kernel/sched/cputime.c      |    8 ++--
 kernel/softirq.c            |    6 ++--
 8 files changed, 88 insertions(+), 32 deletions(-)

-- 
1.7.5.4

