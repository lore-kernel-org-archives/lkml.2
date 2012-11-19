Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab2KSRZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 12:25:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095Ab2KSRZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:25:48 -0500
Date: Mon, 19 Nov 2012 18:26:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Jovi Zhang <bookjovi@gmail.com>,
        Rabin Vincent <rabin@rab.in>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] uprobes: single-step cleanups + reg/unreg fix
Message-ID: <20121119172600.GA11012@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core

- arch_uprobe_*_step() should die before arm port.

- "Use percpu_rw_semaphore to fix register/unregister vs dup_mmap() race"
  fixes the serious bug, the "random" task can be killed after unregister.

Jovi Zhang (1):
      uprobes: Fix misleading log entry

Oleg Nesterov (5):
      uprobes/powerpc: Don't clear TIF_UPROBE in do_notify_resume()
      uprobes/powerpc: Do not use arch_uprobe_*_step() helpers
      uprobes/x86: Cleanup the single-stepping code
      uprobes: Kill arch_uprobe_enable/disable_step() hooks
      uprobes: Use percpu_rw_semaphore to fix register/unregister vs dup_mmap() race

Rabin Vincent (1):
      uprobes: Flush cache after xol write

 arch/powerpc/kernel/signal.c  |    4 +--
 arch/powerpc/kernel/uprobes.c |    6 ++++
 arch/x86/kernel/uprobes.c     |   54 ++++++++++++++--------------------------
 include/linux/uprobes.h       |   10 ++++++-
 kernel/events/uprobes.c       |   43 +++++++++++++++++++++-----------
 kernel/fork.c                 |    2 +
 kernel/trace/trace_uprobe.c   |    2 +-
 7 files changed, 65 insertions(+), 56 deletions(-)

