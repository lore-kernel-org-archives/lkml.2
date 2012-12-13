Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab2LMEqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 23:46:48 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44345 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2LMEqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 23:46:47 -0500
MIME-Version: 1.0
In-Reply-To: <50C95A21.1010101@gmail.com>
References: <20121211090910.GA22985@gmail.com> <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com>
 <50C94A9C.2050900@gmail.com> <CA+55aFxpLJ=gVUSiu04sTzDDrR75B89pzE35MyEyj3pVi5UbiQ@mail.gmail.com>
 <50C94ECD.6020504@gmail.com> <CA+55aFzmsEbKCg=Qp0LGxQb-D+ZfBAELEa4HyUkuxkj6Z0-agA@mail.gmail.com>
 <50C95A21.1010101@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Dec 2012 20:46:26 -0800
X-Google-Sender-Auth: CXdMsrCIm9gRVHw1X9lNJRufK4A
Message-ID: <CA+55aFz0aW8sA_51x8RxLd=bR=0izMJtRJm68bKqueJU9OKQsA@mail.gmail.com>
Subject: Re: [GIT PULL] perf changes for v3.8
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 8:31 PM, David Ahern <dsahern@gmail.com> wrote:
>
>
> See commit 26a4f3c0. But that was not enough.

Why? Make the people who run virtualization do the extra work. Things
never worked for them anyway, so forcing *them* to set a flag to get a
working thing is sane.

Forcing everybody else to set a flag is insane. See?

Your "that was not enough" is insane. It's purely about which *default
convention* you choose. The "if (!event->attr.exclude_guest)" test is
the wrong default convention, and it *should* have been "if
(event->attr.include_guest)" with the virtualization people forced to
use "cycles:ppV".

Claiming that there is some hardware overrun is silly, since that's
totally *independent* of the choice of which way the flag works!

> Requiring exclude_guest was
> another required piece. If you want to see the discussion:
> https://lkml.org/lkml/2012/7/9/264

The only thing that discussion shows is that people were *AWARE* that
this was a stupid change. I see Peter pointing out that this breaks
peoples existing working setups.

You broke the WORKING case for old binaries in order to give an error
return in a case that NEVER EVEN WORKED with those binaries. Don't you
see how insane that is?

The 'H' flag is totally the wrong way around.  Exactly because it only
"fixes" a case that was already working, and makes a case that never
worked anyway now return an error value. That's not sane. Since the
old broken case never worked, nobody can have depended on it. See why
I'm saying that it's the people who use virtualization who should be
forced to use the new flag, not the other way around?

                   Linus
