Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab2BFTfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:35:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48217 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab2BFTfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:35:18 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=p8-UtJQVZEYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=011aZRKWrtCsF7yB_V4A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328556916.2200.29.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 5/7] ftrace, perf: Add support to use function
 tracepoint in perf
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Mon, 06 Feb 2012 14:35:16 -0500
In-Reply-To: <20120204132153.GC13382@somewhere>
References: <1326912275-26405-1-git-send-email-jolsa@redhat.com>
	 <1327776209-4883-1-git-send-email-jolsa@redhat.com>
	 <1327776209-4883-6-git-send-email-jolsa@redhat.com>
	 <20120202181409.GH9071@somewhere.redhat.com>
	 <20120203125413.GB1531@m.brq.redhat.com> <20120204132153.GC13382@somewhere>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-04 at 14:21 +0100, Frederic Weisbecker wrote:
>   struct ftrace_event_call __used event_##call = {			\
> > @@ -170,4 +179,9 @@ struct ftrace_event_call __used event_##call = {			\
> >  struct ftrace_event_call __used						\
> >  __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call;
> >  
> > +#undef FTRACE_ENTRY
> > +#define FTRACE_ENTRY(call, struct_name, etype, tstruct, print)		\
> > +	FTRACE_ENTRY_REG(call, struct_name, etype,			\
> > +			 PARAMS(tstruct), PARAMS(print), NULL)
> > +
> >  #include "trace_entries.h"
> 
> 
> Yeah looks good. I wouldn't mind having only FTRACE_ENTRY() with one
> more parameter but I'm fine with the two macros as well.

I prefer the two macros. It's cleaner.

-- Steve


