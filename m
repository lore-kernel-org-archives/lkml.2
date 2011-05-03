Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab1ECNZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 09:25:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44586 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1ECNZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 09:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gM1zfBbC+SesHNb6tx35XWyGMLx1M5blb6jlFvu7qSU6f3bULw3Ph631SP1MxyWZDH
         UCyR/swxCIDCjAMj/fNwYJQPgZaJMlqnSS+ExrUytG7lVl4iFY18DBkCv5lZFM0k9ERg
         1IU1o9ETVEvJOGsnIUrxk25nST1MqTggQlbbY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>,
        "v2 . 6 . 33 . ." <stable@kernel.org>
Subject: [GIT PULL] hw_breakpoint fixes
Date: Tue,  3 May 2011 15:25:19 +0200
Message-Id: <1304429124-2376-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent

I couldn't get Oleg's review/ack for the generic ptrace part
but I think he was fine with the general solution when it was
a simple draft. Few things have changed since then, I essentially
addressed his review.

Thanks,
	Frederic
---

Frederic Weisbecker (5):
      ptrace: Prepare to fix racy accesses on task breakpoints
      x86, hw_breakpoints: Fix racy access to ptrace breakpoints
      powerpc, hw_breakpoints: Fix racy access to ptrace breakpoints
      arm, hw_breakpoints: Fix racy access to ptrace breakpoints
      sh, hw_breakpoints: Fix racy access to ptrace breakpoints


 arch/arm/kernel/ptrace.c     |    8 ++++++++
 arch/powerpc/kernel/ptrace.c |    3 +++
 arch/sh/kernel/ptrace_32.c   |    4 ++++
 arch/x86/kernel/ptrace.c     |   36 ++++++++++++++++++++++++++----------
 include/linux/ptrace.h       |   13 ++++++++++++-
 include/linux/sched.h        |    3 +++
 kernel/exit.c                |    2 +-
 kernel/ptrace.c              |   17 +++++++++++++++++
 8 files changed, 74 insertions(+), 12 deletions(-)
