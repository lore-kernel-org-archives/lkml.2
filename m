Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab0CaD65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 23:58:57 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63074 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab0CaD6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 23:58:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XGBxTob4yAdGHwUB+XdOCk3CAqErj9annktd61Hu7HGcR22kWc6ysERBxABqjl7A8A
         VCkyfKcMcAgKh0cufpsEi5Cbdf9TJnCgX4aLvUObByFEemAhEfeVXk33Cp8QjN8Sv36i
         orqVTVpx/9vogZNuKmXU3GWhjCpoEwq4hiUEo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL v2] perf fixes
Date: Wed, 31 Mar 2010 05:58:45 +0200
Message-Id: <1270007927-6391-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent

It fixes the conflict against latest linus's tree that raised
build errors (you can find a merge commit inside).

I am not yet totally sure about Peter's opinion concerning
the context switch event that is now captured from the kernel.
Our latest discussion on the strict exclude_kernel meaning
seems in favour of this change but I'd prefer to wait for his
final approval before you pull this.

(I'm not reposting the alignment fix as it is unchanged)

Thanks,
	Frederic
---

Frederic Weisbecker (2):
      perf: Correctly align perf event tracing buffer
      perf: Use hot regs with software sched switch/migrate events

Jason Wessel (1):
      x86,kgdb: Always initialize the hw breakpoint attribute


 arch/x86/kernel/cpu/perf_event.c |    2 --
 arch/x86/kernel/kgdb.c           |    2 +-
 include/linux/perf_event.h       |   21 ++++++++++++++-------
 kernel/perf_event.c              |    4 +---
 kernel/trace/trace_event_perf.c  |   11 +++++++++--
 5 files changed, 25 insertions(+), 15 deletions(-)
