Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab0KHPDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 10:03:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831Ab0KHPDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 10:03:31 -0500
Date: Mon, 8 Nov 2010 15:56:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Q: perf_event && task->ptrace_bps[]
Message-ID: <20101108145647.GA3426@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I am trying to understand the usage of hw-breakpoints in arch_ptrace().
ptrace_set_debugreg() and related code looks obviously racy. Nothing
protects us against flush_ptrace_hw_breakpoint() called by the dying
tracee. Afaics we can leak perf_event or use the already freed memory
or both.

Am I missed something?

Looking into the git history, I don't even know which patch should be
blamed (if I am right), there were too many changes. I noticed that
2ebd4ffb6d0cb877787b1e42be8485820158857e "perf events: Split out task
search into helper" moved the PF_EXITING check from find_get_context().
This check coould help if sys_ptrace() races with SIGKILL, but it was
racy anyway.

It is not clear to me what should be done. Looking more, I do not
understand the scope of perf_event/ctx at all, sys_perf_event_open()
looks wrong too, see the next email I am going to send.

Oleg.

