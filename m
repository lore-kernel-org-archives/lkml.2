Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab2GXTh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 15:37:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44724 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab2GXTh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 15:37:57 -0400
MIME-Version: 1.0
In-Reply-To: <500EF541.50009@redhat.com>
References: <20120724181209.GA10534@zod.bos.redhat.com> <CA+55aFw-=vY1eAubQAtbqL33nCrQ7mPgXTaHnEJfbKvFDVdHtw@mail.gmail.com>
 <20120724182409.GB10534@zod.bos.redhat.com> <500EF541.50009@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Jul 2012 12:37:36 -0700
X-Google-Sender-Auth: 281soFKg6-0pJjf3gGSXDR7MOcs
Message-ID: <CA+55aFwSHae5rgFP_b_+r9Agz9JfM9QdoNbZTq7u+5G-xrr8RQ@mail.gmail.com>
Subject: Re: [PATCH] posix_types.h: make __NFDBITS match glibc definition
To: Jeff Law <law@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 12:19 PM, Jeff Law <law@redhat.com> wrote:
>
> All that's strictly necessary is that cast to (int).  That avoids the
> problem.

.. and it causes other problems instead, namely the crap code generation for __.

Apparently glibc fixed it totally differently, and the kernel actually
doesn't care at all. We'd probably be best off just removing those
#defines entirely. Especially since the kernel doesn't even *use*
those things.

The kernel _does_ have these odd #define's in <linux/time.h>:

  #define NFDBITS                 __NFDBITS

  #define FD_SETSIZE              __FD_SETSIZE
  #define FD_SET(fd,fdsetp)       __FD_SET(fd,fdsetp)
  #define FD_CLR(fd,fdsetp)       __FD_CLR(fd,fdsetp)
  #define FD_ISSET(fd,fdsetp)     __FD_ISSET(fd,fdsetp)
  #define FD_ZERO(fdsetp)         __FD_ZERO(fdsetp)

but apart from __NFDBITS and __FD_SETSIZE, the kernel doesn't even
seem to define those __FD_xyx macros at all (although possibly they
are hiding in some odd auto-generated headers, I didn't check). I
think this is all silly left-overs that nobody really wants any more.
glibc clearly doesn't.

             Linus
