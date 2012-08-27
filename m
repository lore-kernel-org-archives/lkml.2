Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab2H0RmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:42:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab2H0RmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:42:19 -0400
Date: Mon, 27 Aug 2012 19:44:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 0/3] uprobes: teach uprobes to clear MMF_HAS_UPROBES
Message-ID: <20120827174428.GA438@redhat.com>
References: <20120819164008.GA25454@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120819164008.GA25454@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srikar, this is still waiting for your review ;)

FYI, I created the tree to accumulate the acked patches,
kernel.org:/pub/scm/linux/kernel/git/oleg/misc

Currently it has:

	Oleg Nesterov (7):
	      uprobes: kill uprobes_state->count
	      uprobes: kill dup_mmap()->uprobe_mmap(), simplify uprobe_mmap/munmap
	      uprobes: change uprobe_mmap() to ignore the errors but check fatal_signal_pending()
	      uprobes: do not use -EEXIST in install_breakpoint() paths
	      uprobes: introduce MMF_HAS_UPROBES
	      uprobes: fold uprobe_reset_state() into uprobe_dup_mmap()
	      uprobes: remove "verify" argument from set_orig_insn()

	Sebastian Andrzej Siewior (1):
	      uprobes: remove check for uprobe variable in handle_swbp()

	Srikar Dronamraju (1):
	      uprobes: Remove redundant lock_page/unlock_page

You didn't ack Sebastian's patch, but it looks simple. If you
have any objections please let me know.

On 08/19, Oleg Nesterov wrote:
>
> Hello.
>
> On top of "kill uprobes_state->count, add MMF_HAS_UPROBES"
> series.
>
> Once again, I am not sure we really need this (except 1/3).
> Perhaps we could remove uprobe_munmap() instead and forget
> about the false-positive MMF_HAS_UPROBES's.
>
> OTOH, imho it looks a bit more clean this way. Please comment.
>
> diffstat reports the code bloat, but note that the previous
> series removed more code.
>
> Oleg.
>
>  include/linux/sched.h   |    3 +-
>  kernel/events/uprobes.c |   82 +++++++++++++++++++++++++++++++++++++----------
>  2 files changed, 67 insertions(+), 18 deletions(-)

