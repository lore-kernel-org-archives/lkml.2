Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab2APPQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 10:16:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943Ab2APPQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 10:16:13 -0500
Date: Mon, 16 Jan 2012 16:10:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [GIT PULL] tracing: make signal tracepoints more useful
Message-ID: <20120116151001.GB12817@redhat.com>
References: <20120110174509.GA30802@redhat.com> <20120113182015.GA3902@redhat.com> <20120115182441.GA24694@redhat.com> <20120116074540.GE15641@elte.hu> <1326717070.7642.144.camel@gandalf.stny.rr.com> <20120116125329.GB31667@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116125329.GB31667@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16, Ingo Molnar wrote:
>
> * Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > On Mon, 2012-01-16 at 08:45 +0100, Ingo Molnar wrote:
> >
> > > Looks good to me at a first (quick) sight, except this bit
> > > which changes the ABI:
> > >
> > > > > 	-       TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d",
> > > > > 	+       TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d grp=%d res=%d",
> > >
> > > That's not how we change tracepoints generally - we add a new
> > > one and eventually phase out the old one. Which apps/tools rely
> > > on the old tracepoint? If it's exactly zero apps then we might
> > > be able to change it, but this needs to be investigated.
> >
> > But this tracepoint wasn't changed, it was added on to.
> > There's a difference. Any tool that uses this (including
> > something like powertop) should be able to handle it. [...]
>
> That's mostly true in theory - the question is, is it true in
> practice?
>
> Say if an app relies on the smaller data structure, it sure
> might get surprised by the kernel writing a wider record ...

OK, I am not arguing, I'll resend the patch which adds the new
tracepoint...

But do we really need to keep the old tracepoint? IOW, what if
we simply rename it and add more info?

I am looking at "git log include/trace/events/", for example
"mm-tracepoint: rename page-free events" b413d48a.

Oleg.

