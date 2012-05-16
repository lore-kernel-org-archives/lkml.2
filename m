Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965548Ab2EPUEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:04:44 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58913 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760081Ab2EPUEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:04:43 -0400
MIME-Version: 1.0
In-Reply-To: <1337198404.6724.81.camel@gandalf.stny.rr.com>
References: <1337175871.6724.46.camel@gandalf.stny.rr.com> <CA+55aFzVngkixn-t0mK8QqgnPhCzN2AsUtzfZ3BkLiJAcjNOzQ@mail.gmail.com>
 <1337198404.6724.81.camel@gandalf.stny.rr.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 May 2012 13:04:22 -0700
X-Google-Sender-Auth: rRcLTpGZrxEGOljUWf3qR5dKop4
Message-ID: <CA+55aFyKiNBRv=z8JjPTu=yFFvyWHhkGDxjWLm=R4HpwXzEw4g@mail.gmail.com>
Subject: Re: [RFC][PATCH] tracing: Remove useless 4 bytes of padding from
 every event
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 1:00 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Seriously though. What's your take on changing the kernel that will
> break an older distro. Obviously, this change is too early to apply. But
> because an old distro has one app that will break if we make a change in
> the kernel, is that enough to keep that change out?

I suspect that powertop is enough of a developer thing that if that's
the only thing that breaks, we don't have to worry too much.

I don't want to break *everybody*, so new distro's should be
up-to-date. But breaking something like a F14-15 timeframe distro or
something staid like a SLES (or "Debian Stale" or whatever they call
that thing that only takes crazy-old binaries)? It's fine. We don't
want to *rush* into it, but no, if those distros are basically not
updating, we can't care about them forever for something like
powertop.

Things that break *normal* applications are different. There the rule
really must be "never".

                   Linus
