Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab2GXTlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 15:41:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135Ab2GXTla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 15:41:30 -0400
Date: Tue, 24 Jul 2012 15:41:24 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Law <law@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix_types.h: make __NFDBITS match glibc definition
Message-ID: <20120724194124.GF10534@zod.bos.redhat.com>
References: <20120724181209.GA10534@zod.bos.redhat.com>
 <CA+55aFw-=vY1eAubQAtbqL33nCrQ7mPgXTaHnEJfbKvFDVdHtw@mail.gmail.com>
 <20120724182409.GB10534@zod.bos.redhat.com>
 <500EF541.50009@redhat.com>
 <CA+55aFwSHae5rgFP_b_+r9Agz9JfM9QdoNbZTq7u+5G-xrr8RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwSHae5rgFP_b_+r9Agz9JfM9QdoNbZTq7u+5G-xrr8RQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 12:37:36PM -0700, Linus Torvalds wrote:
> On Tue, Jul 24, 2012 at 12:19 PM, Jeff Law <law@redhat.com> wrote:
> >
> > All that's strictly necessary is that cast to (int).  That avoids the
> > problem.
> 
> .. and it causes other problems instead, namely the crap code generation for __.
> 
> Apparently glibc fixed it totally differently, and the kernel actually
> doesn't care at all. We'd probably be best off just removing those
> #defines entirely. Especially since the kernel doesn't even *use*
> those things.
> 
> The kernel _does_ have these odd #define's in <linux/time.h>:
> 
>   #define NFDBITS                 __NFDBITS
> 
>   #define FD_SETSIZE              __FD_SETSIZE
>   #define FD_SET(fd,fdsetp)       __FD_SET(fd,fdsetp)
>   #define FD_CLR(fd,fdsetp)       __FD_CLR(fd,fdsetp)
>   #define FD_ISSET(fd,fdsetp)     __FD_ISSET(fd,fdsetp)
>   #define FD_ZERO(fdsetp)         __FD_ZERO(fdsetp)
> 
> but apart from __NFDBITS and __FD_SETSIZE, the kernel doesn't even
> seem to define those __FD_xyx macros at all (although possibly they
> are hiding in some odd auto-generated headers, I didn't check). I
> think this is all silly left-overs that nobody really wants any more.
> glibc clearly doesn't.

I'd be happy to come up with a patch that drops them, but since they're
in a user visible header file I was concerned somebody might be using
them explicitly from posix_types.h.  People do weird crap like not use
glibc all the time.

josh
