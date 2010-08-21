Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab0HUHaR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 03:30:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:21725 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab0HUHaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 03:30:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,244,1280732400"; 
   d="scan'208";a="830380120"
Date: Sat, 21 Aug 2010 15:29:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Tiago Maluta <tiago.maluta@gmail.com>, Michal Marek <mmarek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] fix compilation error with CROSS_COMPILE
Message-ID: <20100821072955.GA4950@localhost>
References: <20100821062133.GA809@localhost>
 <20100821072454.GA25054@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100821072454.GA25054@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 03:24:54PM +0800, Sam Ravnborg wrote:
> On Sat, Aug 21, 2010 at 02:21:33PM +0800, Wu Fengguang wrote:
> >         $ make CROSS_COMPILE=x86_64-linux-gnu-
> >         ...
> >         cc1: error: unrecognized command line option "-m64"
> >         cc1: error: unrecognized command line option "-mno-red-zone"
> >         cc1: error: unrecognized command line option "-mcmodel=kernel"
> >         cc1: error: unrecognized command line option "-maccumulate-outgoing-args"
> > 
> > Cc: Tiago Maluta <tiago.maluta@gmail.com>
> > Cc: Michal Marek <mmarek@suse.cz>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> > 
> > Andrew: the compile error only occurs in the -mm tree
> > The bug is introduced by patch "Linux has an recent option to define
> > CROSS_COMPILE in menuconfig.".
> > 
> > diff --git a/Makefile b/Makefile
> > index d646d69..af8864e 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -190,7 +190,7 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
> >  export KBUILD_BUILDHOST := $(SUBARCH)
> >  ARCH		?= $(SUBARCH)
> >  CROSS_COMPILE	?=
> > -CROSS_COMPILE	:= $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)
> > +CROSS_COMPILE	?= $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)
> 
> I cannot see how this would solve your problem.
> Any variable assigned using := or ?= can be overrided by  variable
> assigned on the command line like this:
> 
>    make VAR=values
> 
> Please note that there is a big difference between the above and this:
> 
>     VAR=value make

Ah yes I'm using that form indeed. Sorry for the confusion.

> In the latter case you pass in VAR using the enviroment and it
> is just like any other environment variable as seen from make.
> 
> On top of that the upstream kernel does not have the first
> assignmnet to CROSS_COMPILE - so you need to update
> your sources (or Andrews --mm is not recent enough.
> 
> Please try again with upstream kernel and let us know what you
> conclude.

Upstream kernel uses the ?= form and runs always OK.

The recent -mm kernels I tried all have the problem.

Thanks,
Fengguang

