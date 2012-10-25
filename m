Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934832Ab2JYRsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:48:14 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37029 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758485Ab2JYRsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:48:11 -0400
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
Subject: [PATCH 0/5] cputime: Moar cleanups / enhancements v3
Date: Thu, 25 Oct 2012 19:47:58 +0200
Message-Id: <1351187283-20715-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Changes since v2:

- Fix missing EXPORT_SYMBOL_GPL (thanks Wu Fenguang for the report)
- Drop that *_irqsafe naming, use vtime_account_system() as irq safe
and __vtime_account_system() for the raw arch implementation
- Drop local_irq_disable() on s390 kvm guest switch

If you want to test, it is pullable from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	cputime/cleanups-v3

Frederic Weisbecker (5):
  vtime: Gather vtime declarations to their own header file
  vtime: Make vtime_account_system() irqsafe
  kvm: Directly account vtime to system on guest switch
  cputime: Specialize irq vtime hooks
  cputime: Separate irqtime accounting from generic vtime

 arch/ia64/kernel/time.c     |    8 +++---
 arch/powerpc/kernel/time.c  |    4 +-
 arch/s390/kernel/vtime.c    |    4 +++
 arch/s390/kvm/kvm-s390.c    |    4 ---
 include/linux/hardirq.h     |   15 ++-----------
 include/linux/kernel_stat.h |    9 +-------
 include/linux/kvm_host.h    |   12 +++++++++-
 include/linux/vtime.h       |   47 +++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/cputime.c      |   20 +++++++++++++----
 kernel/softirq.c            |    6 ++--
 10 files changed, 89 insertions(+), 40 deletions(-)
 create mode 100644 include/linux/vtime.h

-- 
1.7.5.4

