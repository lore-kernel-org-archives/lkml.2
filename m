Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762682Ab2FVSH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 14:07:26 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50275 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab2FVSHW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 14:07:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120622133650.GA24136@gmail.com>
References: <20120622133650.GA24136@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 22 Jun 2012 11:07:01 -0700
X-Google-Sender-Auth: GdzmkJKr2E3NKeGWbz27Eyudl7A
Message-ID: <CA+55aFySaZ4huXgPM0yGPezAhnE9zT81tucC9WnDs5Ps+7+hGA@mail.gmail.com>
Subject: Re: [GIT PULL] perf fixes
To: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 6:36 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Steven Rostedt (1):
>      ftrace: Make all inline tags also include notrace

Btw, this is something I've been wondering about: function call
tracing and inlining seems to be fundamentally incompatible.

And gcc can (and does, depending on version and details) inline pretty
much any static function, whether we mark it inline or not.

Now, there's no question that we don't want inlined functions to be
traced, but that actually means that the *logical* thing would be to
try to somehow tell gcc to not ever do the whole stupid mcount thing
for functions that *might* be inlined - and at least be consistent
about it.

IOW, is there some way to get the mcount thing to only happen for
functions that either have their address taken, or have external
visibility?

Because that mcount thing is expensive as hell, if people haven't
noticed (and I'm not talking about just the call instruction that I
think we can stub out - it changes code generation in other ways too).
And it looks like distros enable it by default, which annoys my
performance-optimizing soul deeply.

So doing it a bit less would be lovely.

                      Linus
