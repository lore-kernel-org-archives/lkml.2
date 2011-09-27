Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab1I0Uz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:55:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56540 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab1I0Uz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:55:56 -0400
Date: Tue, 27 Sep 2011 22:55:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 3/4] trace: add ability to collect call chain of
 non-current task.
Message-ID: <20110927205548.GN18553@somewhere>
References: <1317052535-1765247-1-git-send-email-avagin@openvz.org>
 <1317052535-1765247-4-git-send-email-avagin@openvz.org>
 <1317132351.15383.66.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317132351.15383.66.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 04:05:51PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-09-26 at 19:55 +0400, Andrew Vagin wrote:
> > 
> > Know issues:
> > * Now call chains for non-current tasks are collected on x86 only,
> >   but it may be done for other architectures simply.
> > * It collects only kernel call chains, because we can't get direct
> >   access to memory of other processes and this operation should be
> >   fast enough. 
> 
> Also, it changes the semantics of tracepoint, normally you return the
> callchain leading to the tracepoint, this changes that.
> 
> 
> I'm not entirely against it, as I can see the use, but I would like to
> solicit other opinions.

There is also a problem in perf tools because we are dealing with a
callchain that doesn't belong to the current thread memory mapping and symbol
space. I believe that's a problem once we deal with the userspace part of
the callchain.

That and the fact there are other ways to get that callchain like taking
the one of the last sched_switch event from the waked thread.

Perhaps we should use the sched_switch event and a post_sched_switch
event, compute the time difference as a weight and use the callchain of any of
those. Perhaps as a plugin in perf report?

In any case that rather sounds like something that should be done in post-processing
in userspace, in perf tools.

We should probably avoid the remote callchains, sounds like asking for complications
everywhere.
