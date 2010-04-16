Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694Ab0DPROn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 13:14:43 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:34503 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758668Ab0DPROl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 13:14:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sPU4KJBtS5GtL/8/qobg9vAnMacWfaQMqs7IGRk/tv4xKZuAmxuTxhNbZJasTkavaG
         Oxb713VtgDJniv8oot4qnG75co5pR5EFbh6FWlHiM8Pe59y4OZM8gV8ghDUJxeJi3Ca5
         IMJ695V4aa2j9KcwkNhR/Amtt3wdk3c8lZ64Y=
MIME-Version: 1.0
In-Reply-To: <1271436413.1934.5.camel@localhost>
References: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com>
	 <1271262016-18650-3-git-send-email-chase.douglas@canonical.com>
	 <20100415210357.GG5069@nowhere>
	 <k2u40ec3ea41004151445je53e7ef2u5c0e48e038e4efca@mail.gmail.com>
	 <alpine.LFD.2.00.1004160051390.3625@localhost.localdomain>
	 <p2n40ec3ea41004151627u11ca4d7dw46cbd6b58df9f1c8@mail.gmail.com>
	 <alpine.LFD.2.00.1004160138200.3625@localhost.localdomain>
	 <alpine.LFD.2.00.1004160204510.3625@localhost.localdomain>
	 <i2z40ec3ea41004152101gd55713f2w9eadd8d5ea721688@mail.gmail.com>
	 <1271436413.1934.5.camel@localhost>
Date: Fri, 16 Apr 2010 10:14:40 -0700
X-Google-Sender-Auth: f5bdc5613a719097
Message-ID: <v2s40ec3ea41004161014o484fa344x9e3ac871019161fa@mail.gmail.com>
Subject: Re: [PATCH 3/3] Stop tracing on a schedule bug
From: Chase Douglas <chase.douglas@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 9:46 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2010-04-15 at 21:01 -0700, Chase Douglas wrote:
>> > 2) tracing off can be done via filters on functions and/or events
>> >   already - so I doubt that the tracing_off_event(level) is necessary
>> >   at all.
>> >
>> >   schedule_bug() definitely deserves a separate trace_schedule_bug()
>> >   event which can be used to stop the tracer by already existing
>> >   functionality.
>>
>> Steven said he would be fine with a separate TRACE_EVENT_<blah> macro
>> for the schedule bug if needed, but I'm not sure we need to go that
>> far. If it's configurable through debugfs at run time then it serves
>> my purpose. Unless you feel we should have finer grained control
>> specifically for scheduling while atomic bugs, I'll just leave it as
>> TRACE_EVENT_WARN.
>
> I actually like Thomas's idea better. I need to add the "stop trace on
> event" functionality, and we can insert trace events for bugs, and not
> have this whole "stop tracing here" functions. Instead we could just add
> tracepoints and have a way to pick and choose where to stop tracing.
>
> add a:
>
> include/trace/events/errors.h
>
> #define TRACE_SYSTEM errors
>
> TRACE_EVENT(sched_bug, ....)
>
> etc,
>
>
> When I get back home, I'll add this functionality to stop tracing on
> events. Perhaps I'll even add "TRACE_SUB_SYSTEM" so in the events
> directory, we can have sub layers:
>
> events/errors/BUG/...
> events/errors/WARNING/...
>
> etc

Ok, I see where this is going now. I agree this sounds like a much
better approach. I'll wait for the implementation of the stop tracing
on event functionality so I know how it will work, and then I can
submit patches for the BUG, WARN, panic, and schedule_bug paths.

-- Chase
