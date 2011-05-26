Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab1EZSes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:34:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753523Ab1EZSer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:34:47 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTim44ziUsEbYVOjfLPvOLfhUgH9itw@mail.gmail.com>
References: <1305807728.11267.25.camel@gandalf.stny.rr.com>
 <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com> <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
 <1306254027.18455.47.camel@twins> <20110524195435.GC27634@elte.hu>
 <alpine.LFD.2.02.1105242239230.3078@ionos> <20110525150153.GE29179@elte.hu>
 <alpine.LFD.2.02.1105251836030.3078@ionos> <20110525180100.GY19633@outflux.net>
 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com> <20110525191152.GC19633@outflux.net>
 <BANLkTimYs4rkgP+hmnG3atLhhCz+jQF=Dg@mail.gmail.com> <BANLkTinZYk8YPSxwhuRePo=TdmM45qkgKw@mail.gmail.com>
 <BANLkTi=s09aAqiOzgAJByqZvhQLaCmEErQ@mail.gmail.com> <BANLkTik0Np23G3SjgZw3NYBG5DCFdmH+Rw@mail.gmail.com>
 <BANLkTi=VQEbB1CdS2w03q38d0YSc+_WYgg@mail.gmail.com> <BANLkTimZjwdepwS2mjysRyHytfhd2P7vSA@mail.gmail.com>
 <BANLkTi=UFB6PLfsSTVpFEQbveMs-W4MjUg@mail.gmail.com> <BANLkTim44ziUsEbYVOjfLPvOLfhUgH9itw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 26 May 2011 11:33:52 -0700
Message-ID: <BANLkTineHBZ-oHRsfc9R6bpcp_oyczL5pA@mail.gmail.com>
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

On Thu, May 26, 2011 at 10:38 AM, Will Drewry <wad@chromium.org> wrote:
>>
>> One option is to just not ever allow execve() from inside a restricted
>> environment.
>
> That'd certainly be fine with me.

So if it ends up being purely a "internal to the process" thing, then
I'm much happier about it - it not only limits the scope of things
sufficiently that I don't worry too much about security issues, but it
makes it very clear that it's about a process going into "lock-down"
mode on its own.

It also gets rid of all configuration - one of the things that makes
most security frameworks (look at selinux, but also just ACL's etc)
such a crazy rats nest is the whole "set up for other processes". If
it's designed very much to be about just the "self" process (after
initialization etc), then I think that avoids pretty much all the
serious issues.

A lot of server processes could probably use it as a way to say "Hey,
I guarantee that I will only open new files read-only, and will only
write to the socket that was already opened for me by the accept", and
explicitly limit their worker threads that way.

If that is really sufficient for some chrome sandboxing, then hey,
that's all fine.

Sometimes limiting yourself (rather than looking for some bigger
"generic" solution) is the right answer.

                         Linus
