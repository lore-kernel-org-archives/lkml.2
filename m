Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab2HQUej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 16:34:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756436Ab2HQUeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 16:34:19 -0400
Date: Fri, 17 Aug 2012 16:34:09 -0400
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>, tim.bird@am.sony.com,
        lizefan@huawei.com, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC PATCH 1/1] trace: Move trace event enable from fs_initcall
 to early_initcall
Message-ID: <20120817203408.GA19689@redhat.com>
References: <1345043907-18299-1-git-send-email-elezegarcia@gmail.com>
 <1345151883.3708.7.camel@gandalf.local.home>
 <CALF0-+WVoJ2NTPm7xZc0rr8-ZZ6an1BsN0SLtJvxzFd3CxA6bA@mail.gmail.com>
 <1345211714.3708.24.camel@gandalf.local.home>
 <CALF0-+VbJmAr0j-84sZM3Di2Ar-qAOn_SFuwW1sbd_-1hoojNg@mail.gmail.com>
 <1345214379.3708.29.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345214379.3708.29.camel@gandalf.local.home>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 10:39:39AM -0400, Steven Rostedt wrote:
> On Fri, 2012-08-17 at 11:04 -0300, Ezequiel Garcia wrote:
> > On Fri, Aug 17, 2012 at 10:55 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > > On Fri, 2012-08-17 at 08:01 -0300, Ezequiel Garcia wrote:
> > >
> > >> Regarding the 'complete solution': to be able to capture events from
> > >> the very beggining...
> > >> Have you thought about this?
> > >> Could you give me a hint on how could I implement it?
> > >
> > > How far in the "beginning"? Before memory is set up?
> > 
> > Yes.
> > 
> > > I wouldn't do that.
> > 
> > Yeah, perhaps it sounds crazy. It makes some sense for kmem events, though.
> 
> It doesn't sound crazy, because I've done it before. There may be ways
> to do it.
> 
> > 
> > > I have in the past (set up before memory was finished being
> > > initialized), but things have changed since then.
> > >
> > > One thing that we could do for those that want really early tracing, is
> > > to add a config option to add a static temporary ring buffer, that gets
> > 
> > Yes, something like this would be ideal. How would this ring buffer be
> > allocated?
> > Perhaps as static and __initdata?
> 
> Yes.
> 
> > This way it would be released afterwards, right?
> 
> Correct.
> 
> > 
> > > copied into the default ring buffer after memory is set up. That may be
> > > the easiest way.
> > >
> > > Once memory is set up, the ring buffer can be allocated and events can
> > > be traced, but the ring buffer needs to be set up first. All it would
> > > take is some calls in init/main.c start_kernel() to the initialization.
> > >
> > 
> > Note that my main concern is on trace_events (kmem events to be precise).
> > However this are registered through tracepoints and in turn this tracepoints
> > depend on kmalloc and friends. So, right now is a chicken-egg problem.
> 
> I don't think kmalloc is the issue. The big problem in front of you is
> jump labels. That's what enables and disables trace points, and it gets
> initialized just after memory is set up. You may have to force jump
> labels off when doing early tracing :-/ Although I'm not sure it
> requires allocations.
> 

The only allocation jump labels should do is when modules are loaded. So
I think you should be able to move them earlier, if need be.

Thanks,

-Jason
