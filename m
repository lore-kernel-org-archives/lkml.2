Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab2GXSqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 14:46:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47740 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab2GXSqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 14:46:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120724183230.GC10534@zod.bos.redhat.com>
References: <20120724181209.GA10534@zod.bos.redhat.com> <CA+55aFw-=vY1eAubQAtbqL33nCrQ7mPgXTaHnEJfbKvFDVdHtw@mail.gmail.com>
 <20120724182409.GB10534@zod.bos.redhat.com> <20120724183230.GC10534@zod.bos.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Jul 2012 11:46:25 -0700
X-Google-Sender-Auth: f4IVr_prZM1yBoUrntfkDzGgtdQ
Message-ID: <CA+55aFwFcWoH=QB5tKgVjWcUH3SLCDVNqJY-oXRYy7AWOJfLPA@mail.gmail.com>
Subject: Re: [PATCH v2] posix_types.h: make __NFDBITS compatible with glibc definition
To: Josh Boyer <jwboyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, law@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 11:32 AM, Josh Boyer <jwboyer@redhat.com> wrote:
> Recent glibc made a change to suppress sign-conversion warnings from FD_SET
> (glibc commit ceb9e56b3d1).  That patch solved the particular error it was
> aiming to, however applications that #include <linux/types.h> after
> including <sys/select.h> can now hit a build failure if -Werror=sign-compare
> and -D_FORTIFY_SOURCE=2 is passed to gcc.  This can be seen when building
> this trivial application against a recent enough glibc:

Looking more at this, I now hate it for *another* reason.

Making __NFDBITS be a signed value turns __FDELT() and __FDMASK() into
potentially pure and utter crap. Doing signed divisions (or modulus)
is a disaster - suddenly it's not just a bit shift any more.

Guys, the glibc people really seem to not have thought their change
through. Or maybe they fixed their __FDELT/__FDMASK at the same time?

                    Linus
