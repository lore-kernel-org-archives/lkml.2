Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab0HRAzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 20:55:42 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:49533 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752162Ab0HRAzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 20:55:39 -0400
Date: Wed, 18 Aug 2010 10:55:35 +1000
From: Dave Chinner <david@fromorbit.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [tracing, hang] dumping events gets stuck in synchronise_sched
Message-ID: <20100818005535.GH7362@dastard>
References: <20100817073725.GO10429@dastard>
 <4C6A4A58.2030904@cn.fujitsu.com>
 <20100817115243.GE7362@dastard>
 <1282050158.3268.1303.camel@gandalf.stny.rr.com>
 <20100817224048.GF7362@dastard>
 <1282086431.3268.1975.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282086431.3268.1975.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 07:07:11PM -0400, Steven Rostedt wrote:
> On Wed, 2010-08-18 at 08:40 +1000, Dave Chinner wrote:
> 
> > > When the systems locks up, I assume you want to see why? The trace_pipe
> > > should show that without locking the system.
> > 
> > Exactly.
> 
> So it did work?

I haven't got back to the hanging kernel yet - I had to go back to
2.6.35 to triage and test a regression (which I couldn't with broken
writeback) and I'm still dealing with the fallout of that one...

> > If the trace file cannot be made to handle this type of use
> > robustly, then perhaps it should be removed...
> 
> You mean because it uses synchronize_sched() it should be removed? Seems
> that it was another kernel bug that caused the issue.

Right now I'm using the trace file for exactly what the docuemntation
says it should be used for, but it hangs. You're saying that the
interface is effectively redundant because there's a trace_pipe
interface that shouldn't hang and I should use that instead.

Debug interfaces should be reliable in the face of common problems -
a system burning a CPU in a tight loop is a pretty common problem.
That leads to three options: either fix the hang, document the fact
that the trace file is not reliable and that you should use other
interfaces, or remove the interface altogether.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
