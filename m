Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab0DJSK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 14:10:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54146 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab0DJSK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 14:10:28 -0400
Date: Sat, 10 Apr 2010 15:10:16 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip v2 7/8] perf probe: Remove die() from probe-finder
 code
Message-ID: <20100410181016.GP3908@ghostprotocols.net>
References: <20100406220542.13329.45837.stgit@localhost6.localdomain6>
 <20100406220629.13329.71869.stgit@localhost6.localdomain6>
 <4BBFB5CE.7070104@redhat.com>
 <20100410012815.GC16721@ghostprotocols.net>
 <4BBFFC86.4020201@redhat.com>
 <20100410142700.GN3908@ghostprotocols.net>
 <4BC0ABCA.1020004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC0ABCA.1020004@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Apr 10, 2010 at 12:48:10PM -0400, Masami Hiramatsu escreveu:
> Arnaldo Carvalho de Melo wrote:
> > Em Sat, Apr 10, 2010 at 12:20:22AM -0400, Masami Hiramatsu escreveu:
> >> Arnaldo Carvalho de Melo wrote:
> >>> Em Fri, Apr 09, 2010 at 07:18:38PM -0400, Masami Hiramatsu escreveu:
> >>>>>  	tvar->value = xstrdup(regs);
> >>>>>  	if (ref) {
> >>>>>  		tvar->ref = xzalloc(sizeof(struct kprobe_trace_arg_ref));

> >>> We have to kill those xzcalloc, etc, too they are die() in disguise :-)

> >> Hmm, I think that will cost high, because only failing to allocate memory,
> >> which theoretically means we can't continue to operate it. In that case,
> >> we'd better just use backtrace() and die().

> > Consider a situation where we are trying to allocate lots of objects
> > allocated for some big operation (adding probes for all functions in all
> > threads, whatever), we can just say to the user "hey, you don't have
> > memory to do this" but other operations are possible, so calling
> > panic(), oops, die() is not the right thing to do.

> Hmm, OK, so we'd better remove wrapper.c...

Yeah, that came from git, we'll eventually get rid of it, its just that
I wanted to make clear the rationale behind avoiding spreading its use.

- Arnaldo
