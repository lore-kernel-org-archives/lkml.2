Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab1CJQFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:05:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64215 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1CJQFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:05:37 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=s7jom2g7sBwA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=AUd_NHdVAAAA:8 a=DH71FMdJ9oxqK1ysVqgA:9 a=Dj5TeHEHZnv5O62KUhPX_Nf-Dd0A:4 a=PUjeQqilurYA:10 a=JfD0Fch1gWkA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/6] perf script: move printing of 'common' data from
 print_event and rename
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <daahern@cisco.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de
In-Reply-To: <20110310155109.GB23555@ghostprotocols.net>
References: <1299734608-5223-1-git-send-email-daahern@cisco.com>
	 <1299734608-5223-4-git-send-email-daahern@cisco.com>
	 <20110310152053.GB12521@home.goodmis.org>
	 <20110310155109.GB23555@ghostprotocols.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 11:05:35 -0500
Message-ID: <1299773135.15854.352.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 12:51 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Mar 10, 2011 at 10:20:53AM -0500, Steven Rostedt escreveu:
> > On Wed, Mar 09, 2011 at 10:23:25PM -0700, David Ahern wrote:
> > > This change does impact output: latency data is trace specific and is now
> > > printed after the common data - comm, tid, cpu, time and event name.
> 
> > > Signed-off-by: David Ahern <daahern@cisco.com>
> 
> > >  tools/perf/builtin-script.c         |   38 ++++++++++++++++++++++-----
> > >  tools/perf/util/trace-event-parse.c |   49 +++++++---------------------------
> 
> > I was hoping after the next merge window to start making a common library
> > for parsing events. This way things like powertop and timechart or
> > anything that uses the perf interface does not need to write its own
> > parsing of events, or expect the event formats to be hardcoded.
> > 
> > The trace-event-parse.c was taking from trace-cmd's parse-events.c code
> > and hopefully the two can merge again. The parse-events.c code in
> > trace-cmd has gone through several iterations that has made it much more
> > robust and flexible. I purposely kept it as a separate libarary not
> > dependent on trace-cmd so that it could be used by other utilities like
> > perf.
> 
> David is kinda new to this perf/ftrace/trace-cmd/etc soap opera, and he

Lucky him ;)

> has been patient to go thru the motions with Peter, Thomas, Frédéric and
> me, going from doing what he wants in 'perf report' to 'perf script',
> etc.
> 
> We're almost to the point where his feature is implemented in a
> way Frédéric, the one most actively reviewing his work, is satisfied,
> right Frédéric?

You must have one of those keyboards where it is easy to make that é

> 
> I think the merge with the libraries you mention is something that is
> not a precondition to merging David's work.
> 
> And his work is at least moving things in the trace parts of tools/,
> that was so far dormant.

Note, I'm not saying that his work should be put on hold. I actually
want to start it up again. Maybe I worded this response wrong. It was
more about bringing David up to speed on what I want to do next than
saying not to do this work.

Thanks,

-- Steve


