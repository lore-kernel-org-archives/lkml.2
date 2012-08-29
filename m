Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab2H2RwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 13:52:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab2H2RwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 13:52:12 -0400
Date: Wed, 29 Aug 2012 19:54:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [GIT PULL] (Was: uprobes: teach uprobes to clear MMF_HAS_UPROBES)
Message-ID: <20120829175424.GA2732@redhat.com>
References: <20120819164008.GA25454@redhat.com> <20120827174428.GA438@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120827174428.GA438@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27, Oleg Nesterov wrote:
>
> Srikar, this is still waiting for your review ;)

I was informed that Srikar is travelling and can't review this seris.

So I think it doesn't make sense to delay the already acked patches,
the more testing the better ;) Yes, uprobe_munmap() looks strange,
we should either remove it or apply this series. But we can do this
later, and uprobes have other problems.

Ingo, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes

Note: the patch from Sebastian wasn't acked by Srikar, but I hope
this cleanup is simple enough.

Oleg Nesterov (7):
      uprobes: Kill uprobes_state->count
      uprobes: Kill dup_mmap()->uprobe_mmap(), simplify uprobe_mmap/munmap
      uprobes: Change uprobe_mmap() to ignore the errors but check fatal_signal_pending()
      uprobes: Do not use -EEXIST in install_breakpoint() paths
      uprobes: Introduce MMF_HAS_UPROBES
      uprobes: Fold uprobe_reset_state() into uprobe_dup_mmap()
      uprobes: Remove "verify" argument from set_orig_insn()

Sebastian Andrzej Siewior (1):
      uprobes: Remove check for uprobe variable in handle_swbp()

Srikar Dronamraju (1):
      uprobes: Remove redundant lock_page/unlock_page

 include/linux/sched.h   |    2 +
 include/linux/uprobes.h |   13 ++--
 kernel/events/uprobes.c |  159 +++++++++++++----------------------------------
 kernel/fork.c           |    6 +--
 4 files changed, 54 insertions(+), 126 deletions(-)

