Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab2GXTDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 15:03:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238Ab2GXTDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 15:03:10 -0400
Date: Tue, 24 Jul 2012 15:03:03 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, law@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] posix_types.h: make __NFDBITS compatible with glibc
 definition
Message-ID: <20120724190302.GE10534@zod.bos.redhat.com>
References: <20120724181209.GA10534@zod.bos.redhat.com>
 <CA+55aFw-=vY1eAubQAtbqL33nCrQ7mPgXTaHnEJfbKvFDVdHtw@mail.gmail.com>
 <20120724182409.GB10534@zod.bos.redhat.com>
 <20120724183230.GC10534@zod.bos.redhat.com>
 <CA+55aFwFcWoH=QB5tKgVjWcUH3SLCDVNqJY-oXRYy7AWOJfLPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwFcWoH=QB5tKgVjWcUH3SLCDVNqJY-oXRYy7AWOJfLPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 11:46:25AM -0700, Linus Torvalds wrote:
> On Tue, Jul 24, 2012 at 11:32 AM, Josh Boyer <jwboyer@redhat.com> wrote:
> > Recent glibc made a change to suppress sign-conversion warnings from FD_SET
> > (glibc commit ceb9e56b3d1).  That patch solved the particular error it was
> > aiming to, however applications that #include <linux/types.h> after
> > including <sys/select.h> can now hit a build failure if -Werror=sign-compare
> > and -D_FORTIFY_SOURCE=2 is passed to gcc.  This can be seen when building
> > this trivial application against a recent enough glibc:
> 
> Looking more at this, I now hate it for *another* reason.
> 
> Making __NFDBITS be a signed value turns __FDELT() and __FDMASK() into
> potentially pure and utter crap. Doing signed divisions (or modulus)
> is a disaster - suddenly it's not just a bit shift any more.
> 
> Guys, the glibc people really seem to not have thought their change
> through. Or maybe they fixed their __FDELT/__FDMASK at the same time?

Jeff can probably answer this better than I can, so likely best to wait
for him.

FWIW, the definitions of __FD_ELT/__FD_MASK in glibc are:

#define __FD_ELT(d)     ((d) / __NFDBITS)
#define __FD_MASK(d)    ((__fd_mask) 1 << ((d) % __NFDBITS))

where __fd_mask is 'typdef long int'.

__NFDBITS was changed to int type with glibc commit eb0b6cb6e in 2009,
and __FDELT/__FDMASK were basically renamed with glibc commit
e529793b508 in 2011.

josh
