Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab1ASWV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:21:58 -0500
Received: from mail.openrapids.net ([64.15.138.104]:40424 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754682Ab1ASWVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:21:46 -0500
Date: Wed, 19 Jan 2011 17:21:44 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Miller <davem@davemloft.net>, richm@oldelvet.org.uk,
        609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
	Unknown relocation: 36
Message-ID: <20110119222144.GC23544@Krystal>
References: <20110118.223247.241909079.davem@davemloft.net> <20110118.232045.58440904.davem@davemloft.net> <20110119153326.GC11022@Krystal> <20110119.134047.232915743.davem@davemloft.net> <1295474423.12215.1612.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295474423.12215.1612.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:19:45 up 57 days,  3:22,  4 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2011-01-19 at 13:40 -0800, David Miller wrote:
> 
> > My concern is that if there is ever a u64 or similarly "long long"
> > typed member in these tracing structures, it will not be aligned
> > sufficiently to avoid unaligned access traps on 32-bit systems.
> 
> The structure that gets placed in this section is the ftrace_event_call.
> It consists only of pointers, a struct list_head, a couple of "int", and
> a struct trace_event, which consists of: a struct hlist_node, a struct
> list_head, an int, and a pointer.
> 
> None of these are more than "long" and I don't foresee them needing a
> long long type. I think assuming that a long is the largest item should
> due.
> 
> We can add a comment next to these structures specifying this
> dependency, and hopefully it would be updated if we ever do include a
> long long in them.

I still wonder how a 32-bit system can generate an unaligned access trap for an
access to a 64-bit variable aligned on 32-bit, given that there is, by
definition, no 64-bit memory accesses available on the architecture ?

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
