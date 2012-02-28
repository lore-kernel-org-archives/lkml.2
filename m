Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab2B1OKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 09:10:53 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43268 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299Ab2B1OKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 09:10:48 -0500
Message-ID: <1330438245.2822.114.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH v2] parisc: dont unconditionally override CROSS_COMPILE
 for 64 bit.
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "kyle@mcmartin.ca" <kyle@mcmartin.ca>, "deller@gmx.de" <deller@gmx.de>,
        "dave.anglin@bell.net" <dave.anglin@bell.net>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Date: Tue, 28 Feb 2012 08:10:45 -0600
In-Reply-To: <201202280106.23643.vapier@gentoo.org>
References: <1330298813-17262-1-git-send-email-paul.gortmaker@windriver.com>
	 <201202272004.55187.vapier@gentoo.org>
	 <1330399020.2822.106.camel@dabdike.int.hansenpartnership.com>
	 <201202280106.23643.vapier@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-28 at 01:06 -0500, Mike Frysinger wrote:
> On Monday 27 February 2012 22:17:01 James Bottomley wrote:
> > On Mon, 2012-02-27 at 20:04 -0500, Mike Frysinger wrote:
> > > On Monday 27 February 2012 17:03:10 James Bottomley wrote:
> > > > --- a/arch/parisc/Makefile
> > > > +++ b/arch/parisc/Makefile
> > > > 
> > > > -CROSS_COMPILE	:= hppa64-linux-gnu-
> > > > +
> > > > +# if no default set, try to find the corresponding 64 bit compiler
> > > > +ifeq ($(CROSS_COMPILE),)
> > > > +CROSS_COMPILE	:= $(shell $(CC) -dumpmachine | sed
> > > > s/hppa-\\\(.*\\\)/hppa64-\\1-/) +endif
> > > 
> > > fails when using "hppa2.0-xxx".  perhaps:

Is that a valid prefix?  I was thinking hppa32 might be, but hppa2.0 is
supposed to be hppa-xxx with -mpa-risc-2-0.

But anyway, I think being clever and removing unused stuff is likely
orthogonal to the first patch which is just making it all work.

> > > CROSS_COMPILE ?= $(shell $(CC) -dumpmachine | sed
> > > 's/^hppa[^-]*-/hppa64-/')
> > > 
> > > don't even need the ifeq check then
> > 
> > How is that different from Carlos' suggestion?
> 
> sorry, but i'm not seeing any e-mails from Carlos in this thread.  what is his 
> suggestion ?

Actually, I misspoke, it was your suggestion in the first thread.

> > The reason it doesn't work is the same ... CROSS_COMPILE is defined to be
> > empty.
> 
> my suggestion was purely an incremental improvement on the patch you posted.  
> it improves two things:
> 	- detection when the default tuple is hppa2.0-xxx rather than hppa-xxx
> 	- one line for set-variable-only-when-its-unset rather than three lines
> -mike

It can't be done ... defined but empty is different from not defined in
makefiles (ifdef or ?= only checks for not defined).  CROSS_COMPILE gets
automatically defined by the top level Makefile ... that's why we need a
check for empty not a check for not defined.

James


