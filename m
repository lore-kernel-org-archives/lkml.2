Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab1E2QwC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 12:52:02 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:48261 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab1E2QwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 12:52:00 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call filtering
In-Reply-To: <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
References: <20110517131902.GF21441@elte.hu> <BANLkTikBK3-KZ10eErQ6Eex_L6Qe2aZang@mail.gmail.com> <1305807728.11267.25.camel@gandalf.stny.rr.com> <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com> <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com> <1306254027.18455.47.camel@twins> <20110524195435.GC27634@elte.hu> <alpine.LFD.2.02.1105242239230.3078@ionos> <20110525150153.GE29179@elte.hu> <alpine.LFD.2.02.1105251836030.3078@ionos> <20110525180100.GY19633@outflux.net> <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
User-Agent: Notmuch/0.5-145-gb6862c7 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Sun, 29 May 2011 22:21:45 +0530
Message-ID: <8762otqwke.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011 11:42:44 -0700, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, May 25, 2011 at 11:01 AM, Kees Cook <kees.cook@canonical.com> wrote:
> >
> > Can we just go back to the original spec? A lot of people were excited
> > about the prctl() API as done in Will's earlier patchset, we don't lose the
> > extremely useful "enable_on_exec" feature, and we can get away from all
> > this disagreement.
> 
> .. and quite frankly, I'm not even convinced about the original simpler spec.
> 
> Security is a morass. People come up with cool ideas every day, and
> nobody actually uses them - or if they use them, they are just a
> maintenance nightmare.
> 
> Quite frankly, limiting pathname access by some prefix is "cool", but
> it's basically useless.
> 
> That's not where security problems are.
> 
> Security problems are in the odd corners - ioctl's, /proc files,
> random small interfaces that aren't just about file access.
> 
> And who would *use* this thing in real life? Nobody. In order to sell
> me on a new security interface, give me a real actual use case that is
> security-conscious and relevant to real users.
> 
> For things like web servers that actually want to limit filename
> lookup, we'd be <i>much</i> better off with a few new flags to
> pathname lookup that say "don't follow symlinks" and "don't follow
> '..'". Things like that can actually be beneficial to
> security-conscious programming, with very little overhead. Some of
> those things currently look up pathnames one component at a time,
> because they can't afford to not do so. That's a *much* better model
> for the whole "only limit to this subtree" case that was quoted
> sometime early in this thread.


The "make sure we don't follow symlinks at all" is a real problem in
VirtFS (http://wiki.qemu.org/Documentation/9psetup) that we are fixing
by adding a forked chrooted process to Qemu. If we are open to a new
open flag O_NOFOLLOW_PATH, which would fail with ELOOP if any of the
path component is a symbolic link, that would greatly simplify VirtFS.
Will such a new flag to open be acceptable ? 


-aneesh

