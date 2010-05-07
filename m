Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab0EGSBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:01:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46141 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196Ab0EGSBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:01:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XZiOa/EOG4ebP3Ww2xIrN1BF1Pcd0zliQtDiIDgbeM1kjoBBQNh7+SmyyEtAnmdful
         PmD2bJbV5om2kyjkcv1Jf5NVFzh3EhTXy/DzAy3ZA8BxvdbutEcRs4SOIOx9IwUkoID1
         GFWJQ14i6BEoXDUKgkcVAt7ErNnfispzQ31tI=
Date: Fri, 7 May 2010 20:01:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/9 - v2][RFC] tracing: Remove per event trace
	registering
Message-ID: <20100507180130.GA5401@nowhere>
References: <20100504034045.085822814@goodmis.org> <20100504034202.282030521@goodmis.org> <20100507042025.GC8069@nowhere> <20100507145438.GB29573@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507145438.GB29573@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 10:54:38AM -0400, Mathieu Desnoyers wrote:
> * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > On Mon, May 03, 2010 at 11:40:48PM -0400, Steven Rostedt wrote:
> > > From: Steven Rostedt <srostedt@redhat.com>
> > > 
> > > This patch removes the register functions of TRACE_EVENT() to enable
> > > and disable tracepoints. The registering of a event is now down
> > > directly in the trace_events.c file. The tracepoint_probe_register()
> > > is now called directly.
> > > 
> > > The prototypes are no longer type checked, but this should not be
> > > an issue since the tracepoints are created automatically by the
> > > macros. If a prototype is incorrect in the TRACE_EVENT() macro, then
> > > other macros will catch it.
> > 
> > 
> > 
> > Agreed. Typechecking matters for human code but not in this context.
> > Considering that the tracepoint and the probe are created by the same
> > CPP code, bugs will be tracked down quickly and located to a single
> > place.
> 
> So it seems that I am the only one asking for extra type-checking and
> caring about problems that can appear subtily on architectures where the
> number of caller/callee arguments must match. And also the only one
> considering that passing more arguments to a callback that does not
> expect all of them might be a problem on some architectures.
> 
> Am I the only one thinking there is something fishy there ? I might be
> entirely over-paranoid, but this approach has rarely failed me in the
> past.


You are confusing two different and unrelated issues here.

One is the lost typechecking when we _register_ a probe because we now use
directly tracepoint_probe_register() for that.
I don't care personally because both tracepoint and probe are created by
the same automation. There is very few risk of callback type mess and
if there is, it will be located in a small and isolated code.

The second is this extra parameter passed whether or not it is needed.
And although we suppose it is safe, I don't feel comfortable with it.
So if we can find a more proper way to avoid it, I'm all for it.

Thanks.

