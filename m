Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab2CaJwL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 05:52:11 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43216 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab2CaJwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 05:52:08 -0400
Date: Sat, 31 Mar 2012 11:52:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, David Smith <dsmith@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: fix the "old_pid" usage in
 trace_sched_process_exec()
Message-ID: <20120331095158.GA887@gmail.com>
References: <20120330162636.GA4857@redhat.com>
 <20120330162930.GA4902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120330162930.GA4902@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 03/30, Oleg Nesterov wrote:
> >
> > 1. TRACE_EVENT(sched_process_exec) forgets to actually use the
> >    old pid argument, it sets ->old_pid = p->pid.
> >
> > 2. search_binary_handler() uses the wrong pid number. tracepoint
> >    needs the global pid_t from the root namespace, while old_pid
> >    is the virtual pid number as it seen by the tracer/parent.
> 
> Not really serious, but probably makes sense for 3.4. This fixes
> the recently merged 4ff16c25e2cc48cbe6956e356c38a25ac063a64d
> "tracepoint, vfs, sched: Add exec() tracepoint"

Thanks Oleg - will queue your fix up in tip:perf/urgent.

Thanks,

	Ingo
