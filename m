Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab1EZQyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:54:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932472Ab1EZQyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:54:15 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTik0Np23G3SjgZw3NYBG5DCFdmH+Rw@mail.gmail.com>
References: <1305807728.11267.25.camel@gandalf.stny.rr.com>
 <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com> <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
 <1306254027.18455.47.camel@twins> <20110524195435.GC27634@elte.hu>
 <alpine.LFD.2.02.1105242239230.3078@ionos> <20110525150153.GE29179@elte.hu>
 <alpine.LFD.2.02.1105251836030.3078@ionos> <20110525180100.GY19633@outflux.net>
 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com> <20110525191152.GC19633@outflux.net>
 <BANLkTimYs4rkgP+hmnG3atLhhCz+jQF=Dg@mail.gmail.com> <BANLkTinZYk8YPSxwhuRePo=TdmM45qkgKw@mail.gmail.com>
 <BANLkTi=s09aAqiOzgAJByqZvhQLaCmEErQ@mail.gmail.com> <BANLkTik0Np23G3SjgZw3NYBG5DCFdmH+Rw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 26 May 2011 09:46:38 -0700
Message-ID: <BANLkTi=VQEbB1CdS2w03q38d0YSc+_WYgg@mail.gmail.com>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call filtering
To: Will Drewry <wad@chromium.org>
Cc: Colin Walters <walters@verbum.org>, Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 9:33 AM, Will Drewry <wad@chromium.org> wrote:
>
> FWIW, none of the patches deal with privilege escalation via setuid
> files or file capabilities.

That is NOT AT ALL what I'm talking about.

I'm talking about the "setuid()" system call (and all its cousins:
setgit/setreuid etc). And the whole thread has been about filtering
system calls, no?

Do a google code search for setuid.

In good code, it will look something like

  uid = getuid();

  if (setuid(uid)) {
    fprintf(stderr, "Unable to drop provileges\n");
    exit(1);
  }

but I guarantee you that there are cases where people just blindly
drop privileges. google code search found me at least the "heirloom"
source code doing exactly that.

And if you filter system calls, it's entirely possible that you can
attack suid executables through such a vector. Your "limit system
calls for security" security suddenly turned into "avoid the system
call that made things secure"!

See what I'm saying?

                       Linus
