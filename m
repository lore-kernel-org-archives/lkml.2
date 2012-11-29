Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab2K2RpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 12:45:21 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34079 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab2K2RpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 12:45:20 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [GIT PULL] cputime: Cleanups on adjusted cputime code
Date: Thu, 29 Nov 2012 18:45:11 +0100
Message-Id: <1354211111-12113-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1354125140-9294-1-git-send-email-fweisbec@gmail.com>
References: <1354125140-9294-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest cputime adjustment cleanups that can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git cputime/adjustment-v2

for you to fetch changes up to fa09205783d11cc05122ad6e4ce06074624b2c0c:

  cputime: Comment cputime's adjusting code (2012-11-28 17:08:20 +0100)

Note it's not related to my previous cputime pull request. Both are independant.

Thanks.

----------------------------------------------------------------
Cputime cleanups on reader side:

* Improve naming and code location

* Consolidate adjustment code

* Comment the adjustement code

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

----------------------------------------------------------------
Frederic Weisbecker (4):
      cputime: Move thread_group_cputime() to sched code
      cputime: Rename thread_group_times to thread_group_cputime_adjusted
      cputime: Consolidate cputime adjustment code
      cputime: Comment cputime's adjusting code

 fs/proc/array.c           |    4 +-
 include/linux/sched.h     |   27 ++++++++++---
 kernel/exit.c             |    4 +-
 kernel/fork.c             |    2 +-
 kernel/posix-cpu-timers.c |   24 -----------
 kernel/sched/cputime.c    |   98 ++++++++++++++++++++++++++++++++-------------
 kernel/sys.c              |    6 +--
 7 files changed, 99 insertions(+), 66 deletions(-)
