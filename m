Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428Ab2LHOxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 09:53:24 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:42498 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab2LHOxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 09:53:22 -0500
Date: Sat, 8 Dec 2012 15:53:17 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Jovi Zhang <bookjovi@gmail.com>,
        Rabin Vincent <rabin@rab.in>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: single-step cleanups + reg/unreg fix
Message-ID: <20121208145317.GG12011@gmail.com>
References: <20121119172600.GA11012@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121119172600.GA11012@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> Ingo, please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core
> 
> - arch_uprobe_*_step() should die before arm port.
> 
> - "Use percpu_rw_semaphore to fix register/unregister vs dup_mmap() race"
>   fixes the serious bug, the "random" task can be killed after unregister.
> 
> Jovi Zhang (1):
>       uprobes: Fix misleading log entry
> 
> Oleg Nesterov (5):
>       uprobes/powerpc: Don't clear TIF_UPROBE in do_notify_resume()
>       uprobes/powerpc: Do not use arch_uprobe_*_step() helpers
>       uprobes/x86: Cleanup the single-stepping code
>       uprobes: Kill arch_uprobe_enable/disable_step() hooks
>       uprobes: Use percpu_rw_semaphore to fix register/unregister vs dup_mmap() race
> 
> Rabin Vincent (1):
>       uprobes: Flush cache after xol write
> 
>  arch/powerpc/kernel/signal.c  |    4 +--
>  arch/powerpc/kernel/uprobes.c |    6 ++++
>  arch/x86/kernel/uprobes.c     |   54 ++++++++++++++--------------------------
>  include/linux/uprobes.h       |   10 ++++++-
>  kernel/events/uprobes.c       |   43 +++++++++++++++++++++-----------
>  kernel/fork.c                 |    2 +
>  kernel/trace/trace_uprobe.c   |    2 +-
>  7 files changed, 65 insertions(+), 56 deletions(-)

Pulled, thanks a lot Oleg!

	Ingo
