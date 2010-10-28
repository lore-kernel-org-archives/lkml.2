Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab0J1LD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 07:03:29 -0400
Received: from mail.openrapids.net ([64.15.138.104]:44896 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752669Ab0J1LDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 07:03:25 -0400
Date: Thu, 28 Oct 2010 07:03:21 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: fix TRACE_EVENT power tracepoint creation
Message-ID: <20101028110321.GA24711@Krystal>
References: <20101028021632.GA18117@Krystal> <1288232716.18238.140.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288232716.18238.140.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 06:59:15 up 35 days, 15:01,  1 user,  load average: 1.31, 1.27,
	1.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2010-10-27 at 22:16 -0400, Mathieu Desnoyers wrote:
> > DEFINE_TRACE should also exist when CONFIG_EVENT_TRACING=n. Otherwise, setting
> > only TRACEPOINTS=y is broken.
> 
> NAK, DEFINE_TRACE is deprecated from use outside the tracing
> infrastructure.
> 
[...]
> The trace/events/power.h file should handle the DEFINE_TRACE() when
> CONFIG_EVENT_TRACING is not set. Thus, this is the wrong fix.

DEFINE_TRACE() must only be done once over the whole kernel for a particular
tracepoint. Currently, it is done in power-traces.c when CONFIG_EVENT_TRACING is
activated. This is the only instance where trace/power.h is included with
CREATE_TRACE_POINTS set.

Given that trace/power.h is inluded in more than one .c file, generating
DEFINE_TRACE() when CREATE_TRACE_POINTS is not set does not work. So what
alternative do you suggest ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
