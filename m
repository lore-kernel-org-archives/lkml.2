Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab1ARUN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 15:13:28 -0500
Received: from mail.openrapids.net ([64.15.138.104]:57670 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753021Ab1ARUN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 15:13:27 -0500
Date: Tue, 18 Jan 2011 15:13:23 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Miller <davem@davemloft.net>, richm@oldelvet.org.uk,
        609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
	Unknown relocation: 36
Message-ID: <20110118201323.GA14930@Krystal>
References: <1295273486.16479.15.camel@gandalf.stny.rr.com> <20110117.213448.226787087.davem@davemloft.net> <20110117.220039.71097651.davem@davemloft.net> <20110117.220857.104046847.davem@davemloft.net> <20110118164633.GA12872@Krystal> <1295372019.12215.30.camel@gandalf.stny.rr.com> <1295374595.12215.32.camel@gandalf.stny.rr.com> <1295375178.12215.33.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295375178.12215.33.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:00:59 up 56 days,  1:04,  5 users,  load average: 1.08, 1.04,
	1.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2011-01-18 at 13:16 -0500, Steven Rostedt wrote:
> > On Tue, 2011-01-18 at 12:33 -0500, Steven Rostedt wrote:
> > > On Tue, 2011-01-18 at 11:46 -0500, Mathieu Desnoyers wrote:
> > 
> > > > Also align TRACE_PRINTKS on 8 bytes to make sure the beginning of the section is
> > > > aligned on pointer size.
> > > 
> > > If I can make it crash without the alignments and this fixes the issue,
> > > I'll apply both patches.
> > 
> > After applying David's patch, I do indeed get a crash. I'll now apply
> > yours and see if it fixes the issue.
> 
> Your patch doesn't seem to fix it either. I'll investigate this further.

I think David's patch missed kernel/trace/trace_export.c

struct ftrace_event_call __used                                         \
__attribute__((__aligned__(4)))                                         \
__attribute__((section("_ftrace_events"))) event_##call = {             \

and kernel/trace/trace.h:

#define FTRACE_ENTRY(call, struct_name, id, tstruct, print)             \
        extern struct ftrace_event_call                                 \
        __attribute__((__aligned__(4))) event_##call;

does it help if you remove these ?

Mathieu


> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
