Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab2LMQeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:34:19 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:59067 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497Ab2LMQeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:34:15 -0500
MIME-Version: 1.0
In-Reply-To: <50CA0134.2090608@gmail.com>
References: <20121211090910.GA22985@gmail.com> <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com>
 <50C94A9C.2050900@gmail.com> <CA+55aFxpLJ=gVUSiu04sTzDDrR75B89pzE35MyEyj3pVi5UbiQ@mail.gmail.com>
 <50C94ECD.6020504@gmail.com> <CA+55aFzmsEbKCg=Qp0LGxQb-D+ZfBAELEa4HyUkuxkj6Z0-agA@mail.gmail.com>
 <50C95A21.1010101@gmail.com> <20121213073056.GA13156@gmail.com>
 <50C9E692.9070506@gmail.com> <CA+55aFzmDooC3tYzvP1YGv9g4ej1hBUQBPV6R+ukrfxuEELBaQ@mail.gmail.com>
 <50CA0134.2090608@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Dec 2012 08:33:54 -0800
X-Google-Sender-Auth: Oz-6wdU-Ixsfngbo3zCeAJ09ci0
Message-ID: <CA+55aFyZ2kAQPmZSv_sfHDAR1gusOxO22TRX-kqSim-cZrMscw@mail.gmail.com>
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

On Thu, Dec 13, 2012 at 8:24 AM, David Ahern <dsahern@gmail.com> wrote:
>
> Without the kernel side restriction existing perf binaries will crash all
> running VMs.

..and they apparently always did, and we had that situation for years
without anybody ever even noticing.

And no, it's not a security fix, since you can just add the 'H' flag
and it will *still* crash according to the thread I saw (ie there is
some race condition in PEBS handling at VM entry, possibly at a
hardware level).

So the real security fix has to either fix the root cause or the
actual crash (which apparently is unknown), or to make perf be
root-only at least in the presense of virtualization.

The "return EOPNOTSUPP" thing does nothing but annoy people.

> I could write the patch to completely invert the exclude_guest
> logic -- make it include_guest. That breaks all existing perf binaries as
> well - just a different syntax that gets broken. That regression is
> acceptable?

It's not a regression since THAT CODE NEVER WORKED, for chissake! The
case of people actually profiling into virtual machines crashes the
running VMs, as you say. There's no way in hell we can call it a
regression to say "you now have to use a flag if you profile a load
with virtualization", since there wasn't any working case to begin
with.

                Linus
