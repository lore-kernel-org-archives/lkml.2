Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab2LMQEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:04:21 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62314 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab2LMQET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:04:19 -0500
MIME-Version: 1.0
In-Reply-To: <50C9E692.9070506@gmail.com>
References: <20121211090910.GA22985@gmail.com> <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com>
 <50C94A9C.2050900@gmail.com> <CA+55aFxpLJ=gVUSiu04sTzDDrR75B89pzE35MyEyj3pVi5UbiQ@mail.gmail.com>
 <50C94ECD.6020504@gmail.com> <CA+55aFzmsEbKCg=Qp0LGxQb-D+ZfBAELEa4HyUkuxkj6Z0-agA@mail.gmail.com>
 <50C95A21.1010101@gmail.com> <20121213073056.GA13156@gmail.com> <50C9E692.9070506@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Dec 2012 08:03:58 -0800
X-Google-Sender-Auth: VEi9X5y76WyDlG5Plz1xZ541f7g
Message-ID: <CA+55aFzmDooC3tYzvP1YGv9g4ej1hBUQBPV6R+ukrfxuEELBaQ@mail.gmail.com>
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

On Thu, Dec 13, 2012 at 6:30 AM, David Ahern <dsahern@gmail.com> wrote:
>
> One of the problems is that existing binaries set the exclude_guest flag
> (https://lkml.org/lkml/2012/7/9/292).

[ to zero ]

Yeah. And it apparently *never* worked. So it's not a regression.

> So, requesting users to update their binaries if they want to use precise
> sampling is not acceptable. A 100% catastrophic failure of all running VMs
> is acceptable? All VMs will crash and there is no direct causal
> relationship.

So instead, you expect everybody else - for whom things *used* to work
- to upgrade their binary, or their scripts, or just start using an
insane command line flag that makes no sense for them? Forcing
non-virtualization users to use a "only trace the host" flag is crazy.

Either way, somebody will be unhappy. No question about that. But our
rule in the kernel is "no regressions".

Now, I do agree that for "perf", it's fairly easy to say "just
recompile". I can do it in seconds, and it would presumably solve my
problem by just making the "host only" case the default, and I don't
need the "H" any more.

But that whole "no regressions" really is important. I can work around
things very easily, but the "no regressions" rule really means that I
should never *need* to work around things.

So when I see a regression, I consider it a major bug, even if the
workaround is trivial.

                     Linus
