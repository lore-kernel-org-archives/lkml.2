Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab1DLUCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:02:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53117 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147Ab1DLUCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:02:03 -0400
Date: Tue, 12 Apr 2011 22:01:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: adding trace-cmd's plugins to perf
Message-ID: <20110412200159.GB25123@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	David Ahern <dsahern@gmail.com>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <4DA12905.2020806@gmail.com>
 <20110412162245.GB2240@nowhere>
 <20110412183536.GA20452@ghostprotocols.net>
 <20110412185104.GA9891@liondog.tnic>
 <20110412185652.GB20452@ghostprotocols.net>
 <20110412190150.GC9891@liondog.tnic>
 <4DA4AA72.4070904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DA4AA72.4070904@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 01:39:30PM -0600, David Ahern wrote:
> 
> 
> On 04/12/11 13:01, Borislav Petkov wrote:
> >>> Also, just FYI, I have this RAS daemon patchset which splits perf functionality
> >>> into different sub-libs, which are more or less topic based:
> >>>
> >>> tools/lib/trace/ - all the trace-event* stuff from Steven
> >>> tools/lib/lk/	- generic enough stuff (git headers, etc) which several tools could use
> 
> Is this going to contain the option parsing as well? e.g., something
> tools/kvm is picking up from perf.

Nope, not yet. Acme suggested I export only the stuff I need. But you
can definitely add them there since I have the Makefiles adjusted and
you'd have to move the .[ch] files and adjust the includes.

Here's what's there so far:

lib/lk/
|-- cpumap.c
|-- cpumap.h
|-- ctype.c
|-- debugfs.c
|-- debugfs.h
|-- Makefile
|-- thread_map.c
|-- thread_map.h
|-- types.h
|-- usage.c
|-- util.c
|-- util.h
|-- xyarray.c
`-- xyarray.h

> >>> tools/lib/perf/ - functionality related to perf events
> >>>
> >>> Here's the last submission http://marc.info/?l=linux-edac&m=129562244211501&w=2
> >>> and I'm currently finishing a new rebase against tip/perf/core.
> >>>
> >>> If you're fine with that split I'd suggest I load off my stuff first so
> >>> that David can continue from there and I can finally stop rebasing like
> >>> crazy each time perf moves forward.
> >>>
> >>> Opinions? Suggestions?
> >>
> >> Yeah, David, can you try Borislav's patchset and tell us what you think
> >> wrt servicing your needs?
> > 
> > Yeah, but first let me post the latest version - I'll try to do so in
> > the next couple of days.
> > 
> > Thanks.
> > 
> 
> Sure. This is a background task, and I still need to spend time on
> trace-cmd to understand it. ie. it's not something I expect to do within
> the next week -- more like within the next month if I get the time.

Ok, I'll let you know when I have it done.

-- 
Regards/Gruss,
    Boris.
