Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab0HQWk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 18:40:56 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:49356 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750752Ab0HQWkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 18:40:52 -0400
Date: Wed, 18 Aug 2010 08:40:48 +1000
From: Dave Chinner <david@fromorbit.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [tracing, hang] dumping events gets stuck in synchronise_sched
Message-ID: <20100817224048.GF7362@dastard>
References: <20100817073725.GO10429@dastard>
 <4C6A4A58.2030904@cn.fujitsu.com>
 <20100817115243.GE7362@dastard>
 <1282050158.3268.1303.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282050158.3268.1303.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 09:02:38AM -0400, Steven Rostedt wrote:
> On Tue, 2010-08-17 at 21:52 +1000, Dave Chinner wrote:
> > On Tue, Aug 17, 2010 at 04:37:44PM +0800, Lai Jiangshan wrote:
> > > On 08/17/2010 03:37 PM, Dave Chinner wrote:
> > > > Tracing folks,
> > > > 
> > > > I've got a machine stuck with a cpu spinning in a tight loop (the
> > > > new writeback/sync livelock avoidance code is, well, livelocking),
> > > > and I was trying to find out what triggered by using the writeback
> > > > trace events. Unfortunately, I can't dump the trace events because
> > > > it gets stuck here:
> > > 
> > > > 
> > > > Given that the trace events are there mainly for debugging, this
> > > > seems like a bit of an oversight - hanging a CPU in a tight loop is
> > > > not an uncommon event during code development....
> > > > 
> > > 
> > > You can try 'cat trace_pipe', if I did not miss you meaning.
> > 
> > I'll try it, but I'm really after the static event list which is why
> > I'm using the trace file rather than trace_pipe. I want the history,
> > not new events as they happen. 
> 
> When the systems locks up, I assume you want to see why? The trace_pipe
> should show that without locking the system.

Exactly.

> You could also try downloading trace-cmd and running the tracer with
> that. That will save all traces to a file while running the trace.

I don't have tens of GB available to store all the traces that an
xfstests test run generates. In general, I don't need the traces,
either, and when  I do the problem is usually in the current ring
buffer, which is why I typically dump the events after the fact.

If the trace file cannot be made to handle this type of use
robustly, then perhaps it should be removed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
