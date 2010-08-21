Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab0HUHk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 03:40:26 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:59221 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab0HUHkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 03:40:23 -0400
Date: Sat, 21 Aug 2010 09:40:21 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Tiago Maluta <tiago.maluta@gmail.com>, Michal Marek <mmarek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] fix compilation error with CROSS_COMPILE
Message-ID: <20100821074021.GA25099@merkur.ravnborg.org>
References: <20100821062133.GA809@localhost> <20100821072454.GA25054@merkur.ravnborg.org> <20100821072955.GA4950@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100821072955.GA4950@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 03:29:56PM +0800, Wu Fengguang wrote:
> On Sat, Aug 21, 2010 at 03:24:54PM +0800, Sam Ravnborg wrote:
> > On Sat, Aug 21, 2010 at 02:21:33PM +0800, Wu Fengguang wrote:
> > >         $ make CROSS_COMPILE=x86_64-linux-gnu-
> > >         ...
> > >         cc1: error: unrecognized command line option "-m64"
> > >         cc1: error: unrecognized command line option "-mno-red-zone"
> > >         cc1: error: unrecognized command line option "-mcmodel=kernel"
> > >         cc1: error: unrecognized command line option "-maccumulate-outgoing-args"
> > > 
> > > Cc: Tiago Maluta <tiago.maluta@gmail.com>
> > > Cc: Michal Marek <mmarek@suse.cz>
> > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > > ---
> > > 
> > > Andrew: the compile error only occurs in the -mm tree
> > > The bug is introduced by patch "Linux has an recent option to define
> > > CROSS_COMPILE in menuconfig.".
> > > 
> > > diff --git a/Makefile b/Makefile
> > > index d646d69..af8864e 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -190,7 +190,7 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
> > >  export KBUILD_BUILDHOST := $(SUBARCH)
> > >  ARCH		?= $(SUBARCH)
> > >  CROSS_COMPILE	?=
> > > -CROSS_COMPILE	:= $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)
> > > +CROSS_COMPILE	?= $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)
> > 
> > I cannot see how this would solve your problem.
> > Any variable assigned using := or ?= can be overrided by  variable
> > assigned on the command line like this:
> > 
> >    make VAR=values
> > 
> > Please note that there is a big difference between the above and this:
> > 
> >     VAR=value make
> 
> Ah yes I'm using that form indeed. Sorry for the confusion.
> 
> > In the latter case you pass in VAR using the enviroment and it
> > is just like any other environment variable as seen from make.
> > 
> > On top of that the upstream kernel does not have the first
> > assignmnet to CROSS_COMPILE - so you need to update
> > your sources (or Andrews --mm is not recent enough.
> > 
> > Please try again with upstream kernel and let us know what you
> > conclude.
> 
> Upstream kernel uses the ?= form and runs always OK.
> 
> The recent -mm kernels I tried all have the problem.

Good.
Then we can assume that next -mm has this fixed when he picks up
this change from upstream. Or maybe -mm has a patch in needs for revert.

Took a quick looks at -mm and only fould this:
kbuild-fix-config_cross_compile-issue-in-config.patch
And this is already upstream.


So I suggest you to fix it locally and check that
next -mm is correct.

	Sam
