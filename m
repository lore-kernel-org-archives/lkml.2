Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab0CTOHY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:07:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64311 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab0CTOHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:07:18 -0400
X-Authority-Analysis: v=1.0 c=1 a=owmX5hmkyK4A:10 a=IkcTkHD0fZMA:10 a=DXJNcLThthFFfznLLgQA:9 a=tg7o8DBFwFD3OcCyVdve379digAA:4 a=QEXdDO2ut3YA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [patch] trace: find the correct ftrace event
From: Steven Rostedt <rostedt@goodmis.org>
To: Dan Carpenter <error27@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20100320135604.GA28881@bicker>
References: <20100320131923.GA20922@bicker>
	 <1269092233.28658.9.camel@localhost>  <20100320135604.GA28881@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Mar 2010 10:07:16 -0400
Message-ID: <1269094036.28658.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-20 at 16:56 +0300, Dan Carpenter wrote:

> > > diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> > > index 4615f62..6070c70 100644
> > > --- a/kernel/trace/trace_events_filter.c
> > > +++ b/kernel/trace/trace_events_filter.c
> > > @@ -1388,16 +1388,19 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
> > >  	struct event_filter *filter;
> > >  	struct filter_parse_state *ps;
> > >  	struct ftrace_event_call *call = NULL;
> > > +	int found = 0;
> > >  
> > >  	mutex_lock(&event_mutex);
> > >  
> > >  	list_for_each_entry(call, &ftrace_events, list) {
> > > -		if (call->id == event_id)
> > > +		if (call->id == event_id) {
> > > +			found = 1;
> > >  			break;
> > > +		}
> > >  	}
> > >  
> > >  	err = -EINVAL;
> > > -	if (!call)
> > 
> > 	if (call == &ftrace_events)
> > 
> 
> Man...  That makes my head hurt.  It only works because ->list is the 
> first element in the struct.
> 
> We'd need a cast.

Oops, I missed the fact that it was list_*_entry(). That should be:

	if (call->list != &ftrace_events)

No cast needed.

> 
> Is that really cleaner?

Perhaps not, but I think it is more elegant ;-)

-- Steve


