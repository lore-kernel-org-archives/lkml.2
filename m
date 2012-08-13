Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab2HMOkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 10:40:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19218 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab2HMOkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 10:40:46 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=GWnlZwk_GPcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=gQgWxiXoT4LK9aoVdZ4A:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1344868844.6935.121.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH 4/4] perf/events: Use helper functions in event
 assignment to shrink macro size
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 13 Aug 2012 10:40:44 -0400
In-Reply-To: <1344865977.31459.26.camel@twins>
References: <20120810034302.758092203@goodmis.org>
	 <20120810034708.589220175@goodmis.org> <1344845024.31459.9.camel@twins>
	 <1344863027.6935.111.camel@gandalf.stny.rr.com>
	 <1344865977.31459.26.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-13 at 15:52 +0200, Peter Zijlstra wrote:

> > Looking at the history of perf_trace_buf_submit(), it use to be more
> > than one function call. But when you inlined
> > perf_swevent_put_recursion_context(), it became just a one2one mapping.
> 
> Right.

OK, this should go as a separate change.

> 
> > I'm assuming that we want to convert all calls to
> > perf_trace_buf_submit()s into perf_tp_event()?
> 
> Yeah.. I think you're referring to the {u,k}probes open-coded nonsense?
> Should we make those use these new helpers you created as well?

They may not need it. The helpers I created were for the macros that are
created by all TRACE_EVENT() instances. If the uprobes and kprobes only
have a single instance, then they probably don't need the helpers. But
they still call the perf_trace_buf_submit(), which can can probably be
cleaned up.

-- Steve


