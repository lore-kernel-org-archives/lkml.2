Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0C2VuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 17:50:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40614 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab0C2VuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 17:50:19 -0400
Date: Mon, 29 Mar 2010 18:50:10 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip 5/7] perf probe: Query basic types from debuginfo
Message-ID: <20100329215009.GA2851@ghostprotocols.net>
References: <20100329203736.2577.56018.stgit@localhost6.localdomain6>
 <20100329203829.2577.44718.stgit@localhost6.localdomain6>
 <20100329205143.GQ3625@ghostprotocols.net>
 <4BB119F8.7020206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB119F8.7020206@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 29, 2010 at 05:22:00PM -0400, Masami Hiramatsu escreveu:
> Arnaldo Carvalho de Melo wrote:
> > Em Mon, Mar 29, 2010 at 04:38:29PM -0400, Masami Hiramatsu escreveu:
> > Question, should we use the equivalent to panic'ing the kernel in the
> > userspace bits in tools/?

> > I tend to see all code there as potentially part of a library, i.e. to
> > be callable by some unantecipated new tool or library that would rather
> > receive a return value telling it that the operation can't be performed
> > for some reason so that it can inform the user instead of having the
> > whole tool exit to the command line.
> 
> OK, so that you want to see 
> 
> ret = library_func();
> if (ret < 0)	/* Something wrong happened */
> 	return ret;
> 
> instead of 
> 
> library_func();
> hopefully_executed_next_func();

Exactly. That was my _suggestion_ :-)
 
> > It may well be that some specific operation needs lots of resources but
> > many other don't, panic'c because the one that requires lots of
> > resources can't be performed, bringing down a gui/tui is really nasty.
> 
> Hmm, agreed. But I'd like to have some API for storing dying^H^H^H^H^Herror
> message. (maybe can we use setjump/longjump approach - like try/cache - for die()?)

Can't we do just as we do in the kernel and propagate the error back to
callers? All the way to userspace, that in this case would be the user
instead of an app started by a user?  :-)

Wrt api for storing messages, we have pr_{warning,error,debug}, etc, in
the TUI mode it is even redirected to the bottom line and I plan to have
them get into something browseable if the user wants to see the last pr_
messages.

IOW, just act like you're writing kernel code, that will make it more
likely that people that are used to writing code like that will feel at
ease while hacking tools/.

- Arnaldo
