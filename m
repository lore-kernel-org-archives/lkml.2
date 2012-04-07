Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab2DGJIg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 05:08:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51254 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab2DGJIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 05:08:34 -0400
Date: Sat, 7 Apr 2012 11:08:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 02/15] tools/events: Add files to create libtraceevent.a
Message-ID: <20120407090827.GA7966@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Steven Rostedt <srostedt@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@infradead.org>,
	Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
	Namhyung Kim <namhyung.kim@lge.com>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
 <1333666086-6517-3-git-send-email-fweisbec@gmail.com>
 <20120406132158.GG30425@liondog.tnic>
 <1333750544.2920.6.camel@acer.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1333750544.2920.6.camel@acer.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 06:15:44PM -0400, Steven Rostedt wrote:
> > Yeah, the name "do_warning" is awkward. Can we call it emit_warning or
> > _warning or whatever?
> 
> As this is just a macro defined as a helper in this file (not global),
> I'm not sure it needs to be changed. "emit" has two more characters to
> type over "do" ;-)

I know you're lazy :-) but "do_warning"? That's just nasty. How about
"_warning" or something?

[..]

> > I see you're using kernel-doc style comments. Is this aimed at providing
> > documentation for this library? If so, good idea!
> 
> That was the plan. It also forced me to document the API.

I like that. This'll probably give more users to the lib.

> > > + * pevent_buffer_init - init buffer for parsing
> > > + * @buf: buffer to parse
> > > + * @size: the size of the buffer
> > > + *
> > > + * For use with pevent_read_token(), this initializes the internal
> > > + * buffer that pevent_read_token() will parse.
> > > + */
> > > +void pevent_buffer_init(const char *buf, unsigned long long size)
> > > +{
> > > +	init_input_buf(buf, size);
> > > +}
> > 
> > Can't we unify pevent_buffer_init and init_input_buf()? I mean, it is
> > useless to have that kind of indirection.
> 
> Yeah I agree. This was more of a historical artifact. It use to be just
> init_input_buf() then I needed to export it for other users. Instead of
> doing a full rename, I cheesed out and did this.

:-)

> > In general, is "pevent" the prefix for this library's functions which
> > are getting exported to users?
> 
> Yep. It's the "namespace" used. But if people do not like it, we can
> come up with another name. I just want it to be a short prefix.

Agreed, maybe even shorter: "te" for "traceevent" See, the namespace
of the kernel userspace tools is not that polluted yet so two-letter
namespaces are still up for grabs.

[..]

> > > + * pevent_print_funcs - print out the stored functions
> > > + * @pevent: handle for the pevent
> > > + *
> > > + * This prints out the stored functions.
> > > + */
> > > +void pevent_print_funcs(struct pevent *pevent)
> > > +{
> > > +	int i;
> > > +
> > > +	if (!pevent->func_map)
> > > +		func_map_init(pevent);
> > > +
> > > +	for (i = 0; i < (int)pevent->func_count; i++) {
> > 
> > simply declare i as "unsigned int" and you don't need the cast here.
> 
> I think I did that once but it caused problems elsewhere. But we can
> look at it again.

It shouldn't since the 'i' is a local variable to that function and it
doesn't prevent you from keeping pevent->func_count an unsigned int
which is probably visible elsewhere.

[..]

> > 
> > Ok, enough for today. I'll review the rest only if you really want me to
> > :-).
> > 
> 
> Sure thanks for the comments now. The checkpatch clean ups should
> probably be fixed before this goes in, and removing the breakpoint
> function. But the other changes probably should wait. I would like what
> goes in to be as close to what is in trace-cmd as possible. Perhaps, we
> should add the cleanups as a separate patch. Just to have a nice
> transition.

Ok, makes sense. Let's leave those for another day.

-- 
Regards/Gruss,
    Boris.
