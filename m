Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab1FHRsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 13:48:43 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35125 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab1FHRsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 13:48:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BOgEYjhnQOdl5bVTs2E4NEOsaxmG9Fn3TKgEfCRzLQp47MbzIstpR/nN6dn7PJOVd8
         0WfDdwgHL6h832SQQ0s68gbBtUVuoMS4SCqY3nHsI1D4x7EoCKESnDY3TRgENBLaVb6J
         SHv3RTOr9dVV+LiD1baMeUdpXiDvyvBC3qqbg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/4] sched: Make sleep inside atomic detection work on !PREEMPT
Date: Wed,  8 Jun 2011 19:48:31 +0200
Message-Id: <1307555315-30989-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aside it may mostly avoid the need for a specific PROVE_RCU
check when we sleep inside an rcu read side critical section.

Better make sleeping inside atomic sections work everywhere.

Frederic Weisbecker (4):
  sched: Remove pointless in_atomic() definition check
  sched: Isolate preempt counting in its own config option
  sched: Make sleeping inside spinlock detection working in
    !CONFIG_PREEMPT
  sched: Generalize sleep inside spinlock detection

 Documentation/DocBook/kernel-hacking.tmpl  |    2 +-
 Documentation/SubmitChecklist              |    2 +-
 Documentation/development-process/4.Coding |    2 +-
 Documentation/ja_JP/SubmitChecklist        |    2 +-
 Documentation/zh_CN/SubmitChecklist        |    2 +-
 include/linux/bit_spinlock.h               |    2 +-
 include/linux/hardirq.h                    |    4 ++--
 include/linux/kernel.h                     |    2 +-
 include/linux/pagemap.h                    |    4 ++--
 include/linux/preempt.h                    |   26 +++++++++++++++++---------
 include/linux/rcupdate.h                   |   12 ++++++------
 include/linux/sched.h                      |    2 +-
 kernel/Kconfig.preempt                     |    3 +++
 kernel/sched.c                             |    6 ++----
 lib/Kconfig.debug                          |    9 ++++++---
 15 files changed, 46 insertions(+), 34 deletions(-)

-- 
1.7.5.4

