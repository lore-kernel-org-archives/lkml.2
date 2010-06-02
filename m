Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab0FBS7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 14:59:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758237Ab0FBS7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 14:59:08 -0400
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
Subject: Re: [PATCH] oom: Make coredump interruptible
In-Reply-To: Oleg Nesterov's message of  Wednesday, 2 June 2010 19:53:25 +0200 <20100602175325.GA16474@redhat.com>
References: <20100601093951.2430.A69D9226@jp.fujitsu.com>
	<20100601201843.GA20732@redhat.com>
	<20100602221805.F524.A69D9226@jp.fujitsu.com>
	<20100602154210.GA9622@redhat.com>
	<20100602172956.5A3E34A491@magilla.sf.frob.com>
	<20100602175325.GA16474@redhat.com>
X-Windows: let it get in *your* way.
Message-Id: <20100602185812.4B5894A549@magilla.sf.frob.com>
Date: Wed,  2 Jun 2010 11:58:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Because it is per-thread.

I see.

> when select_bad_process() finds the task P to kill it can participate
> in the core dump (sleep in exit_mm), but we should somehow inform the
> thread which actually dumps the core: P->mm->core_state->dumper.

Perhaps it should simply do that: if you would choose P to oom-kill, and
P->mm->core_state!=NULL, then choose P->mm->core_state->dumper instead.

> Well, we can use TIF_MEMDIE if we chose the right thread, I think.
> But perhaps mm->flags |= MMF_OOM is better, it can have other user.
> I dunno.

This is all the quick hack before get around to just making core dumping
fully-interruptible, no?  So we should go with whatever is the simplest
change now.

Perhaps this belongs in another thread as you suggested.  But I wonder what
we might get just from s/TASK_UNINTERRUPTIBLE/TASK_KILLABLE/ in exit_mm.


Thanks,
Roland
