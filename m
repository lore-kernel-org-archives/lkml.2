Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935410Ab2JXSFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:05:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934943Ab2JXSFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:05:00 -0400
Date: Wed, 24 Oct 2012 20:06:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: lots of suspicious RCU traces
Message-ID: <20121024180608.GA22840@redhat.com>
References: <20121017034918.GA13295@redhat.com> <20121024164235.GA2467@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024164235.GA2467@swordfish>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24, Sergey Senozhatsky wrote:
>
> small question,
>
> ptrace_notify() and forward calls are able to both indirectly and directly call schedule(),
> /* direct call from ptrace_stop()*/,
> should, in this case, rcu_user_enter() be called before tracehook_report_syscall_exit(regs, step)
> and ptrace chain?

Well, I don't really understand this magic... but why?

Until we return to user-mode this CPU should be in "in_user = false" state.

I am not sure I understand how it is guaranteed that rcu_user_exit() was
called... probably TIF_NOHZ should trigger the slow path and ensure that
syscall_trace_enter()->rcu_user_exit() will be called.

Oleg.

