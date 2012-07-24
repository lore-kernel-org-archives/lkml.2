Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab2GXUAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:00:04 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40362 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab2GXUAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:00:02 -0400
MIME-Version: 1.0
In-Reply-To: <20120724194124.GF10534@zod.bos.redhat.com>
References: <20120724181209.GA10534@zod.bos.redhat.com> <CA+55aFw-=vY1eAubQAtbqL33nCrQ7mPgXTaHnEJfbKvFDVdHtw@mail.gmail.com>
 <20120724182409.GB10534@zod.bos.redhat.com> <500EF541.50009@redhat.com>
 <CA+55aFwSHae5rgFP_b_+r9Agz9JfM9QdoNbZTq7u+5G-xrr8RQ@mail.gmail.com> <20120724194124.GF10534@zod.bos.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Jul 2012 12:59:40 -0700
X-Google-Sender-Auth: vOHsanRGWCgkdJXV_rk__Z5Nrgg
Message-ID: <CA+55aFxYe64cNUNc5Xsz3R34nLynhWri=7konGGgM9iNHFVuFg@mail.gmail.com>
Subject: Re: [PATCH] posix_types.h: make __NFDBITS match glibc definition
To: Josh Boyer <jwboyer@redhat.com>
Cc: Jeff Law <law@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 12:41 PM, Josh Boyer <jwboyer@redhat.com> wrote:
>
> I'd be happy to come up with a patch that drops them, but since they're
> in a user visible header file I was concerned somebody might be using
> them explicitly from posix_types.h.  People do weird crap like not use
> glibc all the time.

Yeah, I agree that somebody could possibly use them.

But the odd thing is, we don't actually export anything *useful*. It's
not like we export the define for __FD_ISSET() etc, which would be
something somebody really wants. No, that kernel header only exports
the (unused by the kernel) building blocks for creating __FD_ISSET().

And I suspect (but it must be before even the old bitkeeper tree) that
we *used* to implement __FD_ISSET() long ago. We removed it, and
nobody used it, so nobody even noticed that we removed it - but left
some now unused stuff behind.

                      Linus
