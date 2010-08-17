Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab0HQNCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:02:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33164 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab0HQNCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:02:40 -0400
X-Authority-Analysis: v=1.1 cv=nbWoJD01ruQLYOYE44JZbYtzz81AmFDL3LnuPvZDHs8= c=1 sm=0 a=ToTR1L1PYWcA:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=llhKIf-NW9iPoSPSSYkA:9 a=qI9Aod0nABEAgdZeD4BOvWhGycQA:4 a=PUjeQqilurYA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: Re: [tracing, hang] dumping events gets stuck in synchronise_sched
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100817115243.GE7362@dastard>
References: <20100817073725.GO10429@dastard>
	 <4C6A4A58.2030904@cn.fujitsu.com>  <20100817115243.GE7362@dastard>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 17 Aug 2010 09:02:38 -0400
Message-ID: <1282050158.3268.1303.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 21:52 +1000, Dave Chinner wrote:
> On Tue, Aug 17, 2010 at 04:37:44PM +0800, Lai Jiangshan wrote:
> > On 08/17/2010 03:37 PM, Dave Chinner wrote:
> > > Tracing folks,
> > > 
> > > I've got a machine stuck with a cpu spinning in a tight loop (the
> > > new writeback/sync livelock avoidance code is, well, livelocking),
> > > and I was trying to find out what triggered by using the writeback
> > > trace events. Unfortunately, I can't dump the trace events because
> > > it gets stuck here:
> > 
> > > 
> > > Given that the trace events are there mainly for debugging, this
> > > seems like a bit of an oversight - hanging a CPU in a tight loop is
> > > not an uncommon event during code development....
> > > 
> > 
> > You can try 'cat trace_pipe', if I did not miss you meaning.
> 
> I'll try it, but I'm really after the static event list which is why
> I'm using the trace file rather than trace_pipe. I want the history,
> not new events as they happen. 

When the systems locks up, I assume you want to see why? The trace_pipe
should show that without locking the system.

You could also try downloading trace-cmd and running the tracer with
that. That will save all traces to a file while running the trace.

-- Steve


