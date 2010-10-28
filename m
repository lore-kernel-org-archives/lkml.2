Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059Ab0J1NRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 09:17:41 -0400
Received: from mail.openrapids.net ([64.15.138.104]:34384 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754324Ab0J1NRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 09:17:40 -0400
Date: Thu, 28 Oct 2010 09:17:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: fix TRACE_EVENT power tracepoint creation
Message-ID: <20101028131737.GA20674@Krystal>
References: <20101028021632.GA18117@Krystal> <1288232716.18238.140.camel@gandalf.stny.rr.com> <20101028110321.GA24711@Krystal> <1288270424.18238.211.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288270424.18238.211.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:14:08 up 35 days, 17:16,  3 users,  load average: 0.04, 0.12,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2010-10-28 at 07:03 -0400, Mathieu Desnoyers wrote:
> 
> > Given that trace/power.h is inluded in more than one .c file, generating
> > DEFINE_TRACE() when CREATE_TRACE_POINTS is not set does not work. So what
> > alternative do you suggest ?
> 
> Right, DEFINE_TRACE should only be set when CREATE_TRACE_POINTS is set,
> and that is only set in the C file that the DEFINE_TRACE is to be
> defined.
> 
> In fact, I don't even see what bug you are trying to fix?
> 
> The file include/trace/define_trace.h converts all the TRACE_EVENTS()
> into DEFINE_TRACE() when CREATE_TRACE_POINTS is set. No other C file
> that includes power.h should have CREATE_TRACE_POINTS set. I guess if it
> did, the CONFIG_EVENT_TRACING would break too.
> 
> It should just work.

This is the culprit:

kernel/trace/ is not built when CONFIG_TRACING=n
kernel/trace/power-traces.o is only built when CONFIG_EVENT_TRACING=y

So the DEFINE_TRACE is never done when CONFIG_EVENT_TRACING=n or
CONFIG_TRACING=n.

What you are telling me is that changing the makefiles should be enough, and I
don't need to add those DEFINE_TRACE(), correct ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
