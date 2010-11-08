Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab0KHPFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 10:05:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837Ab0KHPFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 10:05:09 -0500
Date: Mon, 8 Nov 2010 15:57:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Q: perf_event && event->owner
Message-ID: <20101108145754.GB3434@redhat.com>
References: <20101108145647.GA3426@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108145647.GA3426@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another thing I can't understand, event->owner/owner_entry.

Say, some thread calls sys_perf_event_open() and creates the event.
It becomes its owner. Now this thread exits, but fd/event are still
here, and event->owner refers to the dead task_struct.

ptrace looks even more strange. Debugger can attach the breakpoint
to the tracee and then exit/detach. ->ptrace_bps events still point
to the same (may be dead) task. Even if another debugger attaches
and reuses these events.

And for what? Afaics, this is only used by PR_TASK_PERF_EVENTS_xxABLE.
Looks like, tools/perf/ used prctl() in the past. Perhaps this API
can die now and we can kill ->owner/owner_entry?

Oleg.

