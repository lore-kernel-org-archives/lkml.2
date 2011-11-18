Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab1KRSqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 13:46:24 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:46273 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab1KRSqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 13:46:23 -0500
Subject: Re: [PATCH v2] printk: add console output tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20111118184401.GA24787@somewhere.redhat.com> (sfid-20111118_194444_693542_8E85EDDA)
References: <1321461693.4181.26.camel@frodo>
	 <1321461902.4502.14.camel@jlt3.sipsolutions.net>
	 <1321462856.4181.28.camel@frodo>
	 <1321468380.4502.16.camel@jlt3.sipsolutions.net>
	 <1321473443.4181.38.camel@frodo>
	 <1321478719.4502.20.camel@jlt3.sipsolutions.net>
	 <20111117145502.GA18437@somewhere>
	 <1321541877.3997.31.camel@jlt3.sipsolutions.net>
	 <20111117150040.GB18437@somewhere>
	 <1321543268.3997.40.camel@jlt3.sipsolutions.net>
	 <20111118184401.GA24787@somewhere.redhat.com>
	 (sfid-20111118_194444_693542_8E85EDDA)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 19:46:15 +0100
Message-ID: <1321641975.10266.73.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 19:44 +0100, Frederic Weisbecker wrote:

> > +TRACE_EVENT_CONDITION(console,
> > +	TP_PROTO(const char *log_buf, unsigned start, unsigned end,
> > +		 unsigned log_buf_len),
> > +
> > +	TP_ARGS(log_buf, start, end, log_buf_len),
> > +
> > +	TP_CONDITION(start != end),
> > +
> > +	TP_STRUCT__entry(
> > +		__dynamic_array(char, msg,
> > +				((end - start + log_buf_len) &
> > +				 (log_buf_len - 1)) + 1)
> 
> Is all that care about log_buf_len necessary? It seems that
> printk ensures that log_end - con_start never exceeds log_buf_len,
> looking at emit_log_char()

I think it is. The buffer can wrap around so in that case end < start,
which just end-start won't handle here.

johannes

