Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2DBKTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 06:19:01 -0400
Received: from mail4.comsite.net ([205.238.176.238]:35500 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2DBKTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 06:19:00 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=129.33.192.96;
From: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH v3 0/4] tools: Add a toplevel Makefile
To: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Message-Id: <tools-makefile-T2@mdm.bga.com>
In-Reply-To: <20120331184906.GA25809@merkur.ravnborg.org>
References: <1333023957-22746-1-git-send-email-bp@amd64.org>
   <20120330052605.GA30508@merkur.ravnborg.org>
   <20120330161526.GE30876@aftab>
   <20120331084908.GA14149@gmail.com>
	<20120331184906.GA25809@merkur.ravnborg.org>
Date: Mon, 02 Apr 2012 05:18:57 -0500
X-Originating-IP: 129.33.192.96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[fix a missing comma in cc ]

On Sat, 31 Mar 2012 20:49:06 +0200, Sam Ravnborg wrote:
> 
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
>
> Make will try to update the two targets "tools/perf" and "install"
> in parallel. And it does not look easy to teach make that when you
> specify the target "tools/*" then the install target should just
> be ignored and passed down to the sub-make.

When I saw this concept, my thought was we should add a T= option,
similar to M= option to build a single module.  The T would take
the path under tools/ .  This would also be similar to how we add O=
for output directory and M= for building "external" modules (and also
similar to $(build)= for subdirectories).

> Anything that adds more complexity to the top-level Makefile should
> be avoided if at all possible. It is un-maintainable as-is.
> And the consistency issue is also important.

I think this could be a simple rule, if we find the variable on the
command line we pass everything to the tools Makefile (after processing
O= I guess).

I'll leave the implementation to someone else, I have more than enough
on my plate right now.

milton
