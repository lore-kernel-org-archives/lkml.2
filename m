Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab2CaItU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 04:49:20 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57380 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab2CaItN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 04:49:13 -0400
Date: Sat, 31 Mar 2012 10:49:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/4] tools: Add a toplevel Makefile
Message-ID: <20120331084908.GA14149@gmail.com>
References: <1333023957-22746-1-git-send-email-bp@amd64.org>
 <20120330052605.GA30508@merkur.ravnborg.org>
 <20120330161526.GE30876@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120330161526.GE30876@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> On Fri, Mar 30, 2012 at 07:26:05AM +0200, Sam Ravnborg wrote:
> > > $ make tools/<toolname> tinstall
> > But this makes no sense.
> > 
> > It would be better to be consistent - so the user does not need to remember
> > when to add a space and when not.
> > 
> > make tools/<command> where <command> is one of help, install, clean, "nothing"
> > make tools/<toolname>
> > make tools/<toolname>_<comand> where command is the same set of commands
> > 
> > 
> > then a user could do:
> > 
> >     make tools/clean
> >     make tools/perf
> >     make tools/perf_install
> > 
> > or
> > 
> >     make tools/clean
> >     make tools/
> >     make tools/install
> 
> This one I had hard time imagining: who would install all 
> tools but I guess it could have it's use...

regression testing?

> > The install target could implicitly include the build 
> > target.
> > 
> > With this scheme the user is up to less suprises.
> > 
> > All the above are only minor adjustments compared to what 
> > you already did. bt the consistency here is a gain (IMO).
> 
> ... but yeah, those make sense to me too, let's see what the 
> others think, Arnaldo, Ingo?

Well, if Sam and Michal are fine with it I'm a happy camper.

One question. Instead of:

  make tools/perf_install

Couldnt we beat kbuild into submission to allow the much more 
obvious:

  make tools/perf install

?

I don't think anyone would expect the *kernel* to be installed 
in such a circumstance - so it's only a question of making the 
Makefile understand it, right?

Thanks,

	Ingo
