Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab2DNTPS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 15:15:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53219 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab2DNTPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 15:15:16 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
        srivatsa.bhat@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: [RFC 0/3] Extend type checking macros
Date: Sat, 14 Apr 2012 18:14:42 -0400
Message-Id: <1334441685-4438-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e3831ed ("sched: Fix incorrect usage of for_each_cpu_mask() in
select_fallback_rq()") fixes a very non obvious bug in select_fallback_rq()
which was caused by passing 'struct cpumask' instead of 'struct cpumask *'
to a macro in include/linux/cpumask.h

This bug was quite a pain to debug since it doesn't raise any warnings or
erros during compilation, and the assumption of the kernel hackers who try
to fix a bug is that if the compiler didn't complain, they passed the right
types to functions.

This series of patches adds some more type checking macros to the forgotten
include/linux/typecheck.h, it modified for_each_cpu_mask() to use those
macros to trigger a warning when needed (this is a nice demonstration of how
the bug mentioned before would have been visible with these checks), and
modifies min()/max() and friend to use these macros as well to show their
value in reducing duplicate code and improving readability.

Sasha Levin (3):
  typecheck: extend typecheck.h with more useful typechecking macros
  sched: add type checks to for_each_cpu_mask()
  kernel.h: use new typechecking macros in min()/max() and friends

 include/linux/cpumask.h   |    4 ++-
 include/linux/kernel.h    |   47 ++++++++++++++------------------------------
 include/linux/typecheck.h |   42 ++++++++++++++++++++++++++++++++-------
 3 files changed, 52 insertions(+), 41 deletions(-)

-- 
1.7.8.5

