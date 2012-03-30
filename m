Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761037Ab2C3QhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 12:37:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541Ab2C3QhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 12:37:10 -0400
Date: Fri, 30 Mar 2012 18:29:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: David Smith <dsmith@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: fix the "old_pid" usage in
	trace_sched_process_exec()
Message-ID: <20120330162930.GA4902@redhat.com>
References: <20120330162636.GA4857@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120330162636.GA4857@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30, Oleg Nesterov wrote:
>
> 1. TRACE_EVENT(sched_process_exec) forgets to actually use the
>    old pid argument, it sets ->old_pid = p->pid.
>
> 2. search_binary_handler() uses the wrong pid number. tracepoint
>    needs the global pid_t from the root namespace, while old_pid
>    is the virtual pid number as it seen by the tracer/parent.

Not really serious, but probably makes sense for 3.4. This fixes
the recently merged 4ff16c25e2cc48cbe6956e356c38a25ac063a64d
"tracepoint, vfs, sched: Add exec() tracepoint"

Oleg.

