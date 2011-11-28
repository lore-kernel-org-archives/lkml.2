Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab1K1US0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:18:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:60215 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab1K1USZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:18:25 -0500
Message-ID: <1322511490.2921.175.camel@twins>
Subject: Re: [PATCH 7/9] ftrace, perf: Add support to use function
 tracepoint in perf
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
Date: Mon, 28 Nov 2011 21:18:10 +0100
In-Reply-To: <1322511375.17003.25.camel@frodo>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1322417074-5834-8-git-send-email-jolsa@redhat.com>
	 <1322510318.17003.14.camel@frodo> <1322510931.2921.170.camel@twins>
	 <1322511002.2921.171.camel@twins> <1322511375.17003.25.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 15:16 -0500, Steven Rostedt wrote:
> On Mon, 2011-11-28 at 21:10 +0100, Peter Zijlstra wrote:
> 
> > > Yeah, but still not something you want to do during context switches,
> > > right? 
> > 
> > Also, that's x86, there's still archs that need stop_machine(), right?
> 
> s390 may need it, but till we add a work around there too.
> 
> But yeah, if this happens at context switch, then we want the fast
> enable/disable that Jiri made.

Right, so the way tracepoint->perf works currently is we enable the
tracepoint when we create the event. The tracepoint handler runs a
per-cpu hlist. perf then registers with the per-cpu hlist on context
switch.


