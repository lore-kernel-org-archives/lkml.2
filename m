Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab2DAInC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 04:43:02 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56003 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2DAIm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 04:42:58 -0400
Date: Sun, 1 Apr 2012 10:42:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Borislav Petkov <bp@amd64.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/4] tools: Add a toplevel Makefile
Message-ID: <20120401084253.GB21108@gmail.com>
References: <1333023957-22746-1-git-send-email-bp@amd64.org>
 <20120330052605.GA30508@merkur.ravnborg.org>
 <20120330161526.GE30876@aftab>
 <20120331084908.GA14149@gmail.com>
 <20120331184906.GA25809@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120331184906.GA25809@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > 
> > One question. Instead of:
> > 
> >   make tools/perf_install
> > 
> > Couldnt we beat kbuild into submission to allow the much more 
> > obvious:
> > 
> >   make tools/perf install
> > 
> > ?
> It is more obvious if you look at it alone.
> But when you look at it with the other commands then you suddenly
> end up confused when you need to specify the command as a
> separate target "tools/perf install - and when it is just
> one target "tools/perf_install".
> 
> > 
> > I don't think anyone would expect the *kernel* to be installed 
> > in such a circumstance - so it's only a question of making the 
> > Makefile understand it, right?
> Make will try to update the two targets "tools/perf" and "install"
> in parallel. And it does not look easy to teach make that when you
> specify the target "tools/*" then the install target should just
> be ignored and passed down to the sub-make.
> 
> Anything that adds more complexity to the top-level Makefile should
> be avoided if at all possible. It is un-maintainable as-is.
> And the consistency issue is also important.
> 
> I know that if I do "make install" the kernel will be installed.
> So one could argue that the same should apply to
> the targets below tools/.
> But then this should be for all targets and not just install.
> If someone come up with a clean way to do so it is fine.
> but the original proposal with "tinstall" just do not cut it.

'tinstall' is definitely out, no argument about that.

Viable options are:

  tools/perf install
  tools/perf_install
  tools/perf-install

I'm fine with either one.

Thanks,

	Ingo
