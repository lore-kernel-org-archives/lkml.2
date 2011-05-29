Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab1E2RDD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 13:03:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841Ab1E2RDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 13:03:01 -0400
MIME-Version: 1.0
In-Reply-To: <8762otqwke.fsf@linux.vnet.ibm.com>
References: <20110517131902.GF21441@elte.hu> <BANLkTikBK3-KZ10eErQ6Eex_L6Qe2aZang@mail.gmail.com>
 <1305807728.11267.25.camel@gandalf.stny.rr.com> <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com>
 <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com> <1306254027.18455.47.camel@twins>
 <20110524195435.GC27634@elte.hu> <alpine.LFD.2.02.1105242239230.3078@ionos>
 <20110525150153.GE29179@elte.hu> <alpine.LFD.2.02.1105251836030.3078@ionos>
 <20110525180100.GY19633@outflux.net> <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
 <8762otqwke.fsf@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 29 May 2011 10:02:06 -0700
Message-ID: <BANLkTimuixiwGS0VkWBiB63pzMov8ZB62Q@mail.gmail.com>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call filtering
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 9:51 AM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
>
> The "make sure we don't follow symlinks at all" is a real problem in
> VirtFS (http://wiki.qemu.org/Documentation/9psetup) that we are fixing
> by adding a forked chrooted process to Qemu. If we are open to a new
> open flag O_NOFOLLOW_PATH, which would fail with ELOOP if any of the
> path component is a symbolic link, that would greatly simplify VirtFS.
> Will such a new flag to open be acceptable ?

Such a flag should be something like 3 lines of actual code (and then
the header file changes to actually add the mask itself, which is apt
to be th ebulk of the patch just because we have to have different
values for different architectures).

And yes, it is absolutely acceptable. The only questions in my mind are

 - why haven't we done this long ago?

 - do we have the flag space?

 - should we do a O_NOMNT_PATH flag to do the same for mount-points?

  Some people worry about being confused by bind mounts etc.

 - do we think ".." is worthy of a flag too?

   or is that a "user space can damn well check that itself, even if
it would be absolutely trivial to check in the kernel too"?

Whatever. I think the NOFOLLOW_PATH one is pretty much a no-brainer.
It's not like symlink worries are unusual.

                    Linus
