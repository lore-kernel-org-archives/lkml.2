Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab2JBQaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:30:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42266 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab2JBQaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:30:07 -0400
Date: Tue, 2 Oct 2012 18:30:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCHv2 00/14] perf diff: Factor diff command
Message-ID: <20121002163002.GD16230@one.firstfloor.org>
References: <1348744175-11115-1-git-send-email-jolsa@redhat.com> <20120927213102.GO16230@one.firstfloor.org> <20121001081631.GB991@krava.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001081631.GB991@krava.brq.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Some minor issues I ran into (but no show stoppers):
> > - The error messages for bad -c expressions could be better
> > - I found the requirement for no space after -c unintuitive.
> 
> I'll see to that > 
> > - It would be nice to have support for doing the bucketizing per line
> > instead of per function. With a large function and/or inlining 
> > it's sometimes hard to identify the actual problem
> > Acme recently added this for perf report.
> 
> hm, I missed this one.. hopefully it should be no problem to add it

Here's more issues I found (again no show stopper):

For example you have a spinlock problem with different spinlock callers
that you want to handle.  Since the spinlocks are own functions which
are mixed together cannot be easily ratiod.

This is probably a bit hard to handle, but one way would be to use
a variant of the inclusive reporting Arun recently submitted. 
Define groups of callers that have a combined cost including all 
callees. Use this as the diff unit.

I really liked the oprofile behaviour of attributing lock costs 
to the caller by default. With that it would just work.

The other problem I ran into is that perf archive doesn't seem to 
work very well with kernels, so it's hard to move profiles from
different kernels around to diff them (e.g. for a performance regression)
One way around this would be options to diff to specify the vmlinux etc.
manually

-Andi
