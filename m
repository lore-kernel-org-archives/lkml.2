Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab1EZRSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:18:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754891Ab1EZRSA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:18:00 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimZjwdepwS2mjysRyHytfhd2P7vSA@mail.gmail.com>
References: <1305807728.11267.25.camel@gandalf.stny.rr.com>
 <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com> <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
 <1306254027.18455.47.camel@twins> <20110524195435.GC27634@elte.hu>
 <alpine.LFD.2.02.1105242239230.3078@ionos> <20110525150153.GE29179@elte.hu>
 <alpine.LFD.2.02.1105251836030.3078@ionos> <20110525180100.GY19633@outflux.net>
 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com> <20110525191152.GC19633@outflux.net>
 <BANLkTimYs4rkgP+hmnG3atLhhCz+jQF=Dg@mail.gmail.com> <BANLkTinZYk8YPSxwhuRePo=TdmM45qkgKw@mail.gmail.com>
 <BANLkTi=s09aAqiOzgAJByqZvhQLaCmEErQ@mail.gmail.com> <BANLkTik0Np23G3SjgZw3NYBG5DCFdmH+Rw@mail.gmail.com>
 <BANLkTi=VQEbB1CdS2w03q38d0YSc+_WYgg@mail.gmail.com> <BANLkTimZjwdepwS2mjysRyHytfhd2P7vSA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 26 May 2011 10:17:09 -0700
Message-ID: <BANLkTi=UFB6PLfsSTVpFEQbveMs-W4MjUg@mail.gmail.com>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call filtering
To: Will Drewry <wad@chromium.org>
Cc: Colin Walters <walters@verbum.org>, Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 10:02 AM, Will Drewry <wad@chromium.org> wrote:
>
> Absolutely - that was what I meant :/  The patches do not currently
> check creds at creation or again at use, which would lead to
> unprivileged filters being used in a privileged context.  Right now,
> though, if setuid() is not allowed by the seccomp-filter, the process
> will be immediately killed with do_exit(SIGKILL) on call -- thus
> avoiding a silent failure.

Umm.

You do realize that there is a reason we don't allow random kill()
system calls to succeed without privileges either?

So no, "we kill it with sigkill" is not safe *either*. It now is
potentially a way to kill privileged processes that you didn't have
permission to kill.

My point is that it all sounds designed for well-behaved processes.
"kill it if it does something bad" sounds like a *wonderful* idea if
you're doing a sandbox.

But it is suddenly potentially deadly if that capability is used by a
malicious user for a process that isn't ready for it.

One option is to just not ever allow execve() from inside a restricted
environment.

                       Linus
