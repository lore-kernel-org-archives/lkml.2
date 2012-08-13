Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab2HMNUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:20:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab2HMNU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:20:29 -0400
Date: Mon, 13 Aug 2012 15:16:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com,
        gdb-patches@sourceware.org
Subject: Re: [RFC 5/5] uprobes: add global breakpoints
Message-ID: <20120813131623.GA5269@redhat.com>
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de> <1344355952-2382-6-git-send-email-bigeasy@linutronix.de> <20120808131457.GA5309@redhat.com> <20120809171802.GB27835@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120809171802.GB27835@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09, Sebastian Andrzej Siewior wrote:
>
> * Oleg Nesterov | 2012-08-08 15:14:57 [+0200]:
>
> >> What I miss right now is an interface to tell the user/gdb that there is a
> >> program that hit a global breakpoint and is waiting for further instructions.
> >> A "tail -f trace" does not work and may contain also a lot of other
> >> informations. I've been thinking about a poll()able file which returns pids of
> >> tasks which are put on hold. Other suggestions?
> >
> >Honestly, I am not sure this is that useful...
>
> How would you notify gdb that there is a new task that hit a breakpoint?
> Or learn yourself?

But why do we need this?

OK, you do not need to convince me, I try to never argue with
new features.

However, I certainly dislike TASK_TRACED in uprobe_wait_traced().
And sleeping in ->handler() is not fair to other consumers.

And I do not think you should modify ptrace_attach() at all.
gdb/user can wakeup the task after PTRACE_ATTACH itself.

Oleg.

