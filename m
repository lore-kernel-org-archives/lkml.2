Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab2DFMZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 08:25:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16453 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab2DFMZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 08:25:04 -0400
X-Authority-Analysis: v=2.0 cv=P4S4d18u c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=AiqSj1rLNt4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=3j4BkbkPAAAA:8 a=VfQlcW-9ofeQjZ8kS7YA:9 a=-8espD0-eYFKG9K7hrkA:7 a=QEXdDO2ut3YA:10 a=Z9puGo2VY4EA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 3/3] trace-cmd: setting plugin to 'nop' clears data
 before its recorded
From: Steven Rostedt <rostedt@goodmis.org>
To: Mark Asselstine <mark.asselstine@windriver.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9754868.ceVoCaPqDZ@super-penguin>
References: <1333653586-3379-1-git-send-email-mark.asselstine@windriver.com>
	 <1333653586-3379-4-git-send-email-mark.asselstine@windriver.com>
	 <1333661866.4595.9.camel@acer.local.home>
	 <9754868.ceVoCaPqDZ@super-penguin>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Apr 2012 08:24:53 -0400
Message-ID: <1333715093.23090.2.camel@pippen.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 08:06 -0400, Mark Asselstine wrote:

> Works for me. I see you make use of gboolean elsewhere so I assume you prefer 
> the use of this rather than using int?

Sure.

> 
> > Also, and this has nothing to do with you or your patches, I simply hate
> > the fact that I called these plugins. They should have been called
> > "tracers" but I think I'm stuck with it. The term now is ambiguous as it
> > means both a tracer (as it does here) and it means actual plugins that
> > you can load into trace-cmd itself.
> >
> 
> To stop the proliferation do you want me to name the bool 
> 'disable_current_tracer' rather than 'disable_plugin' or 'plugin'?

disable_tracer would due.

> 
>  
> > >  {
> > >  
> > >  	disable_tracing();
> > > 
> > > -	set_plugin("nop");
> > > 
> > >  	reset_events();
> > >  	
> > >  	/* Force close and reset of ftrace pid file */
> > > 
> > > @@ -911,6 +910,12 @@ static void disable_all(void)
> > > 
> > >  	clear_trace();
> > >  
> > >  }
> > > 
> > > +static void disable_all(void)
> > > +{
> > > +	disable_all_but_plugin();
> > > +	set_plugin("nop");
> > > +}
> > > +
> > > 
> > >  static void
> > >  update_sched_event(struct event_list **event, const char *file,
> > >  
> > >  		   const char *pid_filter, const char *field_filter)
> > > 
> > > @@ -2227,7 +2232,7 @@ void trace_record (int argc, char **argv)
> > > 
> > >  	}
> > >  	
> > >  	if (!keep)
> > > 
> > > -		disable_all();
> > > +		disable_all_but_plugin();
> > > 
> > >  	printf("Kernel buffer statistics:\n"
> > >  	
> > >  	       "  Note: \"entries\" are the entries left in the
> > >  	       kernel ring buffer and are not\n"> 
> > > @@ -2245,6 +2250,8 @@ void trace_record (int argc, char **argv)
> > > 
> > >  	record_data(date2ts);
> > >  	delete_thread_data();
> > > 
> > > +	if (!keep)
> > > +		set_plugin("nop");
> > > 
> > >  	if (keep)
> > >  	
> > >  		exit(0);
> > 
> > I think the above would have been better if you did:
> > 
> > 	if (keep)
> > 		exit(0);
> > 	else
> > 		set_plugin(nop);
> > 
> > -- Steve
> 
> Wow, I wasn't being too bright there was I? Agreed and the 'else' isn't 
> necessary either, so this is a good cleanup.
> 
> I will get this fixed up later today. Do you want a V2 of the full patch series 
> or just an update of this one patch?

You can just update this patch with a v2 on it. I'm currently traveling
home from a conference and wont be back to work till Tuesday. Please,
take your time.

Thanks!

-- Steve


