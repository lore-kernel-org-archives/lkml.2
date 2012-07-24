Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab2GXSYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 14:24:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab2GXSYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 14:24:15 -0400
Date: Tue, 24 Jul 2012 14:24:09 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, law@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix_types.h: make __NFDBITS match glibc definition
Message-ID: <20120724182409.GB10534@zod.bos.redhat.com>
References: <20120724181209.GA10534@zod.bos.redhat.com>
 <CA+55aFw-=vY1eAubQAtbqL33nCrQ7mPgXTaHnEJfbKvFDVdHtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw-=vY1eAubQAtbqL33nCrQ7mPgXTaHnEJfbKvFDVdHtw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 11:20:11AM -0700, Linus Torvalds wrote:
> On Tue, Jul 24, 2012 at 11:12 AM, Josh Boyer <jwboyer@redhat.com> wrote:
> >
> > +#define __NFDBITS      (8 * (int) sizeof(long int))
> 
> I don't know if the type change is needed, but who the hell uses "long int"?

Not strictly, no.  I believe in my brief tests, just the int cast was
sufficient.  I can respin if you'd like.  I probably need to anyway to
CC stable on this.

> Somebody is confused. Grepping the kernel sources, I am saddened to
> see any of these at all. I certainly would never want to add one.

Thoughtless copying on my part.  Glibc actually uses sizeof(__fd_mask),
but that is a typedef long int.  I'm pretty sure that varianet doesn't
make things better.

josh
