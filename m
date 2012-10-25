Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913Ab2JYAwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 20:52:04 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44516 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab2JYAwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 20:52:01 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
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
Subject: [PATCH 0/5] cputime: Moar cleanups / enhancements v2
Date: Thu, 25 Oct 2012 02:51:48 +0200
Message-Id: <1351126313-17804-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I made some changes to the series:

- Handle possible softirq interrupting idle on local_bh_enable()
- Have a dedicated vtime.h header file
- Do some clearer ifdeffery
- Use an irqsafe vtime_account_system() on kvm.

Patches 1/5 and 5/5 are something I really think we want. Patch 3/5
implicitly fixes a bug in s390. If you prefer I can just fix s390
and drop the rest of the patch that is just a micro-optimization
in the kvm guest switch path.

The rest of the patches is micro optimizations on the irq path.
If you think these are pointless over-optimizations, I can just drop
these and only keep 1/5, rebase 5/5 and extract the bug fix in s390 that
resides in 3/5.

Otherwise I'll send a pull request to Ingo in a week or so.

If you want to test, it is pullable from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	cputime/cleanups-v3

Tested on powerpc and x86. Built tested on ia64. s390 doesn't build defconfig
on v3.7-rc2.

Frederic Weisbecker (5):
  vtime: Gather vtime declarations to their own header file
  vtime: Provide an irq safe version of vtime_account_system()
  kvm: Directly account vtime to system on guest switch
  cputime: Specialize irq vtime hooks
  cputime: Separate irqtime accounting from generic vtime

 arch/s390/kernel/vtime.c    |    4 +++
 include/linux/hardirq.h     |   15 ++----------
 include/linux/kernel_stat.h |    9 +-------
 include/linux/kvm_host.h    |   12 +++++++++-
 include/linux/vtime.h       |   48 +++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/cputime.c      |   13 +++++++++-
 kernel/softirq.c            |    6 ++--
 7 files changed, 80 insertions(+), 27 deletions(-)
 create mode 100644 include/linux/vtime.h

-- 
1.7.5.4

