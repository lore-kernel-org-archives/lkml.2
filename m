Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933956Ab2LIMGJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 07:06:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50421 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755705Ab2LIMGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 07:06:07 -0500
Date: Sun, 9 Dec 2012 13:06:03 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@amd64.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [RFC PATCH -v2 3/4] perf: Add persistent event facilities
Message-ID: <20121209120603.GA20535@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Borislav Petkov <bp@amd64.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Borislav Petkov <borislav.petkov@amd.com>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
 <1345139123-15212-4-git-send-email-bp@amd64.org>
 <1345155155.3708.19.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1345155155.3708.19.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 06:12:35PM -0400, Steven Rostedt wrote:
> On Thu, 2012-08-16 at 19:45 +0200, Borislav Petkov wrote:
> >  
> > -static void ring_buffer_put(struct ring_buffer *rb)
> > +void ring_buffer_put(struct ring_buffer *rb)
> >  {
> >  	struct perf_event *event, *n;
> >  	unsigned long flags;
> 
> I have to say that it is really unfortunate that we have two ring
> buffers in the kernel, called struct ring_buffer. One being global and
> one being local to events. And now we are exporting the name
> "ring_buffer_*" too! This is going to confuse the hell out of people.
> 
> Perhaps this should have been called perf_buffer, as that is what it's
> used for.

How about we prepend all non-static stuff which is part of the perf ring
buffer with "perf_" ?

This way we'll have perf_ring_buffer_put() and the namespace is still
short enough and tells you exactly which buffer we're talking about.

Hmm?

-- 
Regards/Gruss,
    Boris.
