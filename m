Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab0F1SEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 14:04:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab0F1SE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 14:04:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: uninterruptible CLONE_VFORK (Was: oom: Make coredump
	interruptible)
In-Reply-To: Oleg Nesterov's message of  Monday, 28 June 2010 19:33:06 +0200 <20100628173306.GA20039@redhat.com>
References: <20100604112721.GA12582@redhat.com>
	<20100609195309.GA6899@redhat.com>
	<20100613175547.616F.A69D9226@jp.fujitsu.com>
	<20100613155354.GA8428@redhat.com>
	<20100613171337.GA12159@redhat.com>
	<20100614005608.0D006408C1@magilla.sf.frob.com>
	<20100614163304.GA21313@redhat.com>
	<20100614191710.18C0E403B2@magilla.sf.frob.com>
	<20100628173306.GA20039@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20100628180416.66F9149A4F@magilla.sf.frob.com>
Date: Mon, 28 Jun 2010 11:04:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The parent can play with real_blocked or saved_sigmask to block all
> signals except STOP and KILL, use TASK_INTERRUPTIBLE for wait, and
> just return ERESTART each time it gets the signal (it should clear
> child->vfork_done if fatal_signal_pending).

Yes, perhaps.

> We should also check PF_KTHREAD though, there are in kernel users
> of CLONE_VFORK.

There is only __call_usermodehelper, but yes.

> > Bu the way that happens ordinarily is
> > to get all the way back to user mode and reenter with a normal syscall.
> > That doesn't touch the user stack itself, but it sure makes one nervous.
> 
> me too. Especially because I do not really know how !x86 machines
> implement this all.

The only problem I know of off hand is ia64's TIF_RESTORE_RSE (an
arch-specific ptrace detail).  But yes, it would require a careful
reading of all the arch code paths.

> We should also verify that the exiting/stopping parent can never write
> to its ->mm. For example, exit_mm() does put_user(tsk->clear_child_tid).
> Fortunately we can rely on PF_SIGNALED flag in this case.

Right.


Thanks,
Roland
