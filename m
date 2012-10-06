Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab2JFNFj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 09:05:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57391 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313Ab2JFNFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 09:05:37 -0400
Date: Sat, 6 Oct 2012 15:05:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "x86@kernel.org" <x86@kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [PATCH v4] trace,x86: add x86 irq vector tracepoints
Message-ID: <20121006130532.GB11120@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Seiji Aguchi <seiji.aguchi@hds.com>,
	"Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
	"x86@kernel.org" <x86@kernel.org>,
	"dle-develop@lists.sourceforge.net" <dle-develop@lists.sourceforge.net>,
	Satoru Moriya <satoru.moriya@hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41385F33C@USINDEM103.corp.hds.com>
 <50612729.2080307@zytor.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D41386426D@USINDEM103.corp.hds.com>
 <50650A7E.90807@zytor.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D413869FD7@USINDEM103.corp.hds.com>
 <1349446428.6755.56.camel@gandalf.local.home>
 <506F7849.2080805@zytor.com>
 <1349492261.6755.87.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1349492261.6755.87.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 10:57:41PM -0400, Steven Rostedt wrote:
> > The problem I'm seeing is the constant "oh, just a little bit more."  My
> > experience over the years is that there is always demand for "just one
> > more debug feature", each of which has negible cost, because they always
> > use the previous thing as a baseline... noone ever looks at the grand
> > total cost of the package (and by the time that happens, it is too late.)
> 
> Now I can turn this back at you ;-)  We can implement the simple "just
> add the tracepoints in the code" first, and then later implement the
> table swap version and we can say "hey! we just made the code faster!".

I absolutely agree with hpa here - it's like he's reading my mind. The
sum of the total cost of all those features simply and surely slows down
the kernel with time and if we don't pay attention, we might get bogged
down with fat no matter the IPC improvements hw guys give us. Which are
not endless, btw, in case someone wonders.

What I'm missing with all those patches on LKML is: here's a patch that
doesn't add a new feature but gives us n% improv with this and that
workload. I wish we had more of those instead of the gazillion new
features each 3 months.

> > tracepoints in particular are something I'm getting concerned about,
> > because they are one of those things that turn kernel internals into an
> > ABI, which means misdesigned tracepoints can actually make kernel
> > internal changes very hard to do.  The cost of those kinds of issues go
> > up over time as the strain between where we'd like the code to be vs.
> > where the code is increases.
> 
> Honestly, I'm extremely concerned about this too. In fact, I've bitched
> about this so many times in the past, but it just fell to deaf ears:
> 
> http://lwn.net/Articles/412685/
> http://lwn.net/Articles/415591/
> http://lwn.net/Articles/416665/
> http://lwn.net/Articles/416684/

Absolutely agreed too. This is why we had such a long discussion about
the RAS tracepoint format recently, for example.

Thanks.

-- 
Regards/Gruss,
    Boris.
