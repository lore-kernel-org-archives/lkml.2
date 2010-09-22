Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0IVSgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:36:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35193 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab0IVSgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:36:16 -0400
X-Authority-Analysis: v=1.1 cv=QPMnOuvfoRK4nyqTv0NRvva4Xk0fUUuJArrqv1I9dZo= c=1 sm=0 a=LtE-Q6vqAlEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=qcI_Xbgvs27S6Lh4MC8A:9 a=ygsOnqIsVAWwUAgmjVkA:7 a=hwDC1HOwtIK6bpzAZjp7ngShGboA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing, perf: add more power related events
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Jean Pihet <jean.pihet@newoldbits.com>,
        Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <len.brown@intel.com>, arjan@infradead.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-users@vger.kernel.org
In-Reply-To: <1285180000.2275.1036.camel@laptop>
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>
	 <201009171736.14170.trenn@suse.de>	<20100917162412.GB3341@elte.hu>
	 <201009180026.59482.trenn@suse.de>
	 <AANLkTimMAr9kEzybFGai3qGyXx36v055iPpXq_C1vW8C@mail.gmail.com>
	 <4C9A21AD.1000800@linux.intel.com>
	 <AANLkTim6B+Je=LykgJb9=0vK5Br1rkft619BRJkBcHdP@mail.gmail.com>
	 <4C9A2FB3.105@linux.intel.com> <1285173835.2275.1026.camel@laptop>
	 <4C9A37AE.2010509@linux.intel.com>  <1285176629.2275.1033.camel@laptop>
	 <1285179355.26872.27.camel@gandalf.stny.rr.com>
	 <1285180000.2275.1036.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 22 Sep 2010 14:36:14 -0400
Message-ID: <1285180574.26872.51.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 20:26 +0200, Peter Zijlstra wrote:
> On Wed, 2010-09-22 at 14:15 -0400, Steven Rostedt wrote:
> > On Wed, 2010-09-22 at 19:30 +0200, Peter Zijlstra wrote:
> > > On Wed, 2010-09-22 at 10:06 -0700, Arjan van de Ven wrote:
> > > 
> > 
> > > That said, I really didn't read this discussion much, but your stance
> > > seems to be that any tracepoint you use must stay valid, and I object to
> > > that.
> > 
> > We could add a TRACE_EVENT_ABI() as Ingo has been suggesting. If
> > anything, it could mean that the given tracepoint will always have the
> > same name. And perhaps the data it holds will always be there, but may
> > also be extended.
> 
> I still don't see why you need TRACE_EVENT_ABI for that, if its the same
> name and the format can be extended you get the same results with what
> we've got. Apps need to read/parse the format thing anyway.

Just a marker that these trace points are being used by apps.

> 
> > > 
> > > What will do you do when we include a new scheduling policy and all the
> > > scheduler tracepoints need to change? (yes that's really going to
> > > happen)
> > 
> > The tracepoint sched_switch should stay the same. We may add more data,
> > but the comm, pid, prio => comm, pid, prio, I don't see going away.
> 
> Right, it would need additional fields. Preferably not only at the end.

Why not at the end? The tools should easily be able to represent them in
anyway they want. The print-fmt field helps in this regard too.

But then again, we present the fields in the data. The tools should use
a parse library (which a generic one will soon be out too). This way, we
don't need them at the "end" but the parsing tools could find the fields
no matter where they are in the record.

> 
> > > I'm not going to carry double tracepoints, and I'm not going to not

"not going to not" eeek! double negative!

> > > merge that policy. 
> > 
> > Not sure what you mean by "double tracepoints"
> 
> Two different tracepoints in the same location.

Agreed, that is wrong to have.

-- Steve


