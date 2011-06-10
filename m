Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab1FJNa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:30:29 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:50772 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab1FJNa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:30:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=li/R/G6Tmc+yeVuHGUebl84tWJqr/XnT0aMjxun8oEl6miAb/9hgDaOusxALs6UI5I
         Dn9zKfMqQJU9UOPSQeihEkwL5pbXzdj4Vh5ktjQOVmnTowrn2E2hHKtze7wDklis3xjq
         T9FhpRiu1xqmD9bBb6UNHtoA+AXiXfN+ZGV5U=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: [GIT PULL] sched: Make sleep inside atomic detection work on !PREEMPT
Date: Fri, 10 Jun 2011 15:30:18 +0200
Message-Id: <1307712622-11104-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the sched/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	sched/core

Thanks,
	Frederic
---

Frederic Weisbecker (4):
      sched: Remove pointless in_atomic() definition check
      sched: Isolate preempt counting in its own config option
      sched: Make sleeping inside spinlock detection working in !CONFIG_PREEMPT
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
