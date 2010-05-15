Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab0EOHqL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 03:46:11 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:46863 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab0EOHqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 03:46:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=nVufhDVqWH7oPScFIUpO8BROatRuSenqKiWvEDj1Yo6QG3hCAWWj65iNVLF403ewNN
         yuRKBdOxEgseaQtEJpeee8MikEvDKCZMFWrGs7hcp2e+04Edrm/jq6Yjkwx0WgUzWLY4
         iAXm9hqDEgFM0q8sUPB9J7cbAVMcCNY8+Iiag=
Date: Sat, 15 May 2010 10:46:02 +0300
From: Pekka Paalanen <pq@iki.fi>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 3/4] tracing: Allow mmio tracer to display
 trace_printk() and other events
Message-ID: <20100515104602.59c1f0e1@daedalus.pq.iki.fi>
In-Reply-To: <1273763483.27703.991.camel@gandalf.stny.rr.com>
References: <20100513012110.558313399@goodmis.org>
	<20100513012302.352845720@goodmis.org>
	<20100513115414.7688b51d@daedalus.pq.iki.fi>
	<1273752909.27703.809.camel@gandalf.stny.rr.com>
	<20100513152915.3d3f852b@daedalus.pq.iki.fi>
	<1273763483.27703.991.camel@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I'm not at my email every day. Real life...

On Thu, 13 May 2010 11:11:23 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 2010-05-13 at 15:29 +0300, Pekka Paalanen wrote:
> > On Thu, 13 May 2010 08:15:09 -0400
> 
> > > It only displays other events if the user enabled those
> > > events.
> > > 
> > > But that said, I don't want to break existing userspace
> > > tools. I can add a mmiotrace option "mmiotrace_all_events",
> > > if the user wants to see all events within the mmiotracer
> > > then they can just enable that option, otherwise, the
> > > mmiotracer will act like it currently does.
> > > 
> > > How does that sound?
> > 
> > That would be fine. Is it not redundant with what you said in
> > your first sentence?
> > 
> 
> Right now with this patch as is. When you enable the mmiotracer it
> clears the ring buffer. But if someone previously enabled an
> event (like sched_switch for example) then that event will appear
> in the output of the tracer.
> 
> The user will need to disable that event and restart the
> mmiotracer so the output will not break the userspace tools. Is
> this OK?

I think it is ok. No non-mmiotrace events are enabled automatically,
right? Except perhaps trace_printk()?

If a user enables other events while mmiotracing, I would
assume he knows what he is doing. End users doing dumps per
request never even know about other kinds of tracing than
mmiotrace.

> If not, then my suggestion is to have an mmiotracer option that
> keeps it from printing out any event except for the ones it knows
> about.
> 
> The reason I added this patch in the first place was because Larry
> Finger was using the mmiotrace with trace_printk() and the
> current code does not print out the trace_printk() when
> mmiotracer is active.

If this is *only* about trace_printk(), why not make a handler
for it to emit MARK lines? Actually, I somehow assumed that
would have been the case, but apparently the event type is
different. I do not recall these things too well anymore.


Thanks for keeping me in the loop.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
