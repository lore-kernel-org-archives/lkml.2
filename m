Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab2AZU0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 15:26:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39646 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab2AZU0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 15:26:42 -0500
Date: Thu, 26 Jan 2012 12:26:21 -0800
From: tip-bot for Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <tip-db7e527da41560f597ccdc4417cefa6b7657c0c0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, borntraeger@de.ibm.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, borntraeger@de.ibm.com,
        mingo@elte.hu
In-Reply-To: <1326268696-30904-1-git-send-email-borntraeger@de.ibm.com>
References: <1326268696-30904-1-git-send-email-borntraeger@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/s390: Fix compile error in sched/core.c
Git-Commit-ID: db7e527da41560f597ccdc4417cefa6b7657c0c0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 12:26:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db7e527da41560f597ccdc4417cefa6b7657c0c0
Gitweb:     http://git.kernel.org/tip/db7e527da41560f597ccdc4417cefa6b7657c0c0
Author:     Christian Borntraeger <borntraeger@de.ibm.com>
AuthorDate: Wed, 11 Jan 2012 08:58:16 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Jan 2012 19:38:11 +0100

sched/s390: Fix compile error in sched/core.c

Commit 029632fbb7b7c9d85063cc9eb470de6c54873df3 ("sched: Make
separate sched*.c translation units") removed the include of
asm/mutex.h from sched.c.

This breaks the combination of:

 CONFIG_MUTEX_SPIN_ON_OWNER=yes
 CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX=yes

like s390 without mutex debugging:

  CC      kernel/sched/core.o
  kernel/sched/core.c: In function ‘mutex_spin_on_owner’:
  kernel/sched/core.c:3287: error: implicit declaration of function ‘arch_mutex_cpu_relax’

Lets re-add the include to kernel/sched/core.c

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1326268696-30904-1-git-send-email-borntraeger@de.ibm.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e067df1..5255c9d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -74,6 +74,7 @@
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
+#include <asm/mutex.h>
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #endif
