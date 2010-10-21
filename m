Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890Ab0JUWzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 18:55:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753364Ab0JUWza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 18:55:30 -0400
Date: Thu, 21 Oct 2010 15:55:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Luca Barbieri <luca@luca-barbieri.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/atomic64_test: do not build on non-atomic64 systems
Message-Id: <20101021155528.b3d6d027.akpm@linux-foundation.org>
In-Reply-To: <201010211823.38287.vapier@gentoo.org>
References: <1287250035-30404-1-git-send-email-vapier@gentoo.org>
	<20101021150250.f6499506.akpm@linux-foundation.org>
	<201010211823.38287.vapier@gentoo.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010 18:23:37 -0400
Mike Frysinger <vapier@gentoo.org> wrote:

> On Thursday, October 21, 2010 18:02:50 Andrew Morton wrote:
> > On Sat, 16 Oct 2010 13:27:15 -0400 Mike Frysinger wrote:
> > > If the arch doesn't provide atomic64 functionality (there are quite a
> > > few), then don't bother trying to build this test.
> > 
> > I don't get it.  If the arch doesn't implement atomic64 then this file
> > will get zillions of build errors, won't it?
> 
> ... which is why i added the ifdef protection

So the changelog was poor.  Please write complete changelogs so I need
to have this sort of conversation less often?

Why doesn't this cause lots of you-broke-my-build complaints?  Nobody's
running allmodonfig?

> > > diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
> > > index 250ed11..0ac1a66 100644
> > > --- a/lib/atomic64_test.c
> > > +++ b/lib/atomic64_test.c
> > > @@ -12,6 +12,8 @@
> > > 
> > >  #include <linux/kernel.h>
> > >  #include <asm/atomic.h>
> > > 
> > > +#ifdef ATOMIC64_INIT
> > 
> > hm, that's a bit lazy.  It should really use a CONFIG_HAVE_ thing.  What
> > a pita.
> 
> ATOMIC64_INIT is required for atomic64 headers to provide, and having a 
> Kconfig knob doesnt gain anything else

I know that.  But the standard way for an architecture to indicate to
the core that it impements a feature is for it to define CONFIG_HAVE_*.
Picking some related #define which architectures happen to implement
is atypical and unexpected.

Will it cause problems?  Probably not, unless the arch goes and defines
ATOMIC64_INIT without actually implementing atomic64.  But it's
atypical and unexpected and, yes, lazy!
