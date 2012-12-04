Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab2LDNOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 08:14:33 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:50815 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab2LDNOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 08:14:31 -0500
Date: Tue, 4 Dec 2012 05:05:03 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: fweisbec@gmail.com, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL rcu/next] One more RCU commit for 3.8
Message-ID: <20121204130503.GA13878@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12120413-7282-0000-0000-00000FAB12CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

Could you please pull one more commit?  This is an update to Frederic
Weisbecker's context-tracking subsystem that is another stepping stone
towards adaptive-idle and tickless userspace execution.  This has been
subjected to -next testing.  It does give two checkpatch.pl errors,
but these are on cpp macro definitions used within assembly code -- and
following checkpatch.pl's suggestions would result in assembler errors.
(I have reported this to Andy Whitcroft, checkpatch.pl's maintainer.)

These changes are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next

							Thanx, Paul

---------------->
Frederic Weisbecker (1):
      context_tracking: New context tracking susbsystem

 arch/Kconfig                                       |   15 ++--
 arch/x86/Kconfig                                   |    2 +-
 arch/x86/include/asm/{rcu.h => context_tracking.h} |   15 ++--
 arch/x86/kernel/entry_64.S                         |    2 +-
 arch/x86/kernel/ptrace.c                           |    8 +-
 arch/x86/kernel/signal.c                           |    5 +-
 arch/x86/kernel/traps.c                            |    2 +-
 arch/x86/mm/fault.c                                |    2 +-
 include/linux/context_tracking.h                   |   18 ++++
 include/linux/rcupdate.h                           |    2 -
 init/Kconfig                                       |   28 ++++----
 kernel/Makefile                                    |    1 +
 kernel/context_tracking.c                          |   83 ++++++++++++++++++++
 kernel/rcutree.c                                   |   64 +---------------
 kernel/sched/core.c                                |   11 ++-
 15 files changed, 150 insertions(+), 108 deletions(-)
 rename arch/x86/include/asm/{rcu.h => context_tracking.h} (63%)
 create mode 100644 include/linux/context_tracking.h
 create mode 100644 kernel/context_tracking.c

