Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1KWNQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 08:16:39 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37290 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab1KWNQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 08:16:38 -0500
Date: Wed, 23 Nov 2011 14:16:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2] printk: add console output tracing
Message-ID: <20111123131622.GA10669@somewhere.redhat.com>
References: <1321473443.4181.38.camel@frodo>
 <1321478719.4502.20.camel@jlt3.sipsolutions.net>
 <20111117145502.GA18437@somewhere>
 <1321541877.3997.31.camel@jlt3.sipsolutions.net>
 <20111117150040.GB18437@somewhere>
 <1321543268.3997.40.camel@jlt3.sipsolutions.net>
 <20111118184401.GA24787@somewhere.redhat.com>
 <1321641975.10266.73.camel@jlt3.sipsolutions.net>
 <20111118185449.GB24787@somewhere.redhat.com>
 <1321642752.10266.75.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321642752.10266.75.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 07:59:12PM +0100, Johannes Berg wrote:
> On Fri, 2011-11-18 at 19:54 +0100, Frederic Weisbecker wrote:
> > On Fri, Nov 18, 2011 at 07:46:15PM +0100, Johannes Berg wrote:
> > > On Fri, 2011-11-18 at 19:44 +0100, Frederic Weisbecker wrote:
> > > 
> > > > > +TRACE_EVENT_CONDITION(console,
> > > > > +	TP_PROTO(const char *log_buf, unsigned start, unsigned end,
> > > > > +		 unsigned log_buf_len),
> > > > > +
> > > > > +	TP_ARGS(log_buf, start, end, log_buf_len),
> > > > > +
> > > > > +	TP_CONDITION(start != end),
> > > > > +
> > > > > +	TP_STRUCT__entry(
> > > > > +		__dynamic_array(char, msg,
> > > > > +				((end - start + log_buf_len) &
> > > > > +				 (log_buf_len - 1)) + 1)
> > > > 
> > > > Is all that care about log_buf_len necessary? It seems that
> > > > printk ensures that log_end - con_start never exceeds log_buf_len,
> > > > looking at emit_log_char()
> > > 
> > > I think it is. The buffer can wrap around so in that case end < start,
> > > which just end-start won't handle here.
> > 
> > Even if it wraps, end - start should always give a positive result.
> > 
> > We have that check in call_console_drivers():
> > 
> > 	BUG_ON(((int)(start - end)) > 0)
> 
> That's .. confusing, start - end > 0 <=> start > end ??

Yeah. Both are unsigned, so converting the result into an int
and getting a positive value means we have wrapped INT_MAX.

> 
> Also, call_console_drivers() doesn't pass this start/end through to
> _call_console_drivers(), it has loops and stuff there...

Yeah but looking at the loop there, start and end passed to
__call_console_drivers() are bounded between start and end passed to
call_console_drivers().

> 
> In any case -- feel free to clean it all up, I basically copied the
> logic from _call_console_drivers assuming it was needed.

I'm just reviewing and suggesting a way to keep the patch more simple.
Outside that, I don't really need that patch myself ;)

> I don't really want to know about the printk details :-)

Well, it's like working out outside in winter. It may not sound
very entertaining in the beginning but then it quickly becomes
invigorating, toning and good for the mood...I think...
