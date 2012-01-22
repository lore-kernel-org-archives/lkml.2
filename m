Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab2AVX6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 18:58:32 -0500
Received: from ozlabs.org ([203.10.76.45]:34299 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499Ab2AVX6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 18:58:31 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][GIT PULL][v3.3] tracing: Add header wrappers event_headers_start.h and event_headers_end.h
In-Reply-To: <1326909412.17534.91.camel@gandalf.stny.rr.com>
References: <1326754637.7642.177.camel@gandalf.stny.rr.com> <20120117095418.GG10397@elte.hu> <1326807145.17534.26.camel@gandalf.stny.rr.com> <20120118120711.GB14863@elte.hu> <1326909412.17534.91.camel@gandalf.stny.rr.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 23 Jan 2012 09:29:27 +1030
Message-ID: <877h0jgx80.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jan 2012 12:56:52 -0500, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2012-01-18 at 13:07 +0100, Ingo Molnar wrote:
> 
> > I'd argue that __raise_softirq_irqoff() should not be inline - 
> > that would solve a whole host of issues. Event tracing is 
> > enabled in most distros so there's no real overhead argument to 
> > be made here either - so it's probably a bit faster in fact to 
> > have this uninlined. What do you think?
> 
> Sure, I have no problem moving that out of the header. I don't think
> raising a softirq is in that critical a path that it can't be a function
> call.
> 
> There's only one trace/events header left which is in module.h. Perhaps
> we can move __module_get() and try_module_get() out of the header. We
> could just move the "if" part out.

Agreed.  Since GCC should be able to eliminate that branch in almost all
cases, since it's usually a literal NULL or address of a (non-weak)
symbol.

Be interesting to see the before/after sizes with this out-of-line.

Thanks,
Rusty.
