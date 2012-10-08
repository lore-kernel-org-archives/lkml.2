Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab2JHOCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 10:02:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294Ab2JHOCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 10:02:38 -0400
Date: Mon, 8 Oct 2012 16:04:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Arapov <anton@redhat.com>, Kyle McMartin <kmcmarti@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] uprobes: misc bugfixes
Message-ID: <20121008140407.GA8034@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core

Mostly bugfixes. Nothing really serious, but probably makes sense
for 3.7 anyway, everything looks straightforward enough.

Oleg Nesterov (19):
      uprobes: Do not leak UTASK_BP_HIT if find_active_uprobe() fails
      uprobes: Do not setup ->active_uprobe/state prematurely
      uprobes: Fix UPROBE_SKIP_SSTEP checks in handle_swbp()
      uprobes: Kill UTASK_BP_HIT state
      uprobes: Move clear_thread_flag(TIF_UPROBE) to uprobe_notify_resume()
      uprobes: Change write_opcode() to use FOLL_FORCE
      uprobes: Change valid_vma() to demand VM_MAYEXEC rather than VM_EXEC
      uprobes: Restrict valid_vma(false) to skip VM_SHARED vmas
      uprobes: Kill set_swbp()->is_swbp_at_addr()
      uprobes: Introduce copy_opcode(), kill read_opcode()
      uprobes: Kill set_orig_insn()->is_swbp_at_addr()
      uprobes: Simplify is_swbp_at_addr(), remove stale comments
      uprobes/x86: Only rep+nop can be emulated correctly
      uprobes: Don't return success if alloc_uprobe() fails
      uprobes: Do not delete uprobe if uprobe_unregister() fails
      uprobes: Fix handle_swbp() vs unregister() + register() race
      uprobes: Introduce prepare_uprobe()
      uprobes: Fix prepare_uprobe() race with itself
      uprobes: Fix the racy uprobe->flags manipulation

 arch/x86/kernel/signal.c  |    4 +-
 arch/x86/kernel/uprobes.c |   16 +--
 include/linux/uprobes.h   |   11 --
 kernel/events/uprobes.c   |  345 +++++++++++++++++++++------------------------
 4 files changed, 165 insertions(+), 211 deletions(-)

