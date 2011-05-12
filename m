Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab1ELDUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 23:20:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45752 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab1ELDU3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 23:20:29 -0400
MIME-Version: 1.0
In-Reply-To: <20110505131406.GA24235@mail.hallyn.com>
References: <20110429131845.GA1768@nowhere>
	<BANLkTimhWZURqgAXG45=3CG-bNhv+g-Ftg@mail.gmail.com>
	<20110503012857.GA8399@nowhere>
	<BANLkTimhugGCnMQ4f2T2HOvwVLrGTREPkg@mail.gmail.com>
	<BANLkTimPFHwJfqXHShnOt7mBp84NQQNWDw@mail.gmail.com>
	<20110504175229.GB1804@nowhere>
	<1304533382.25414.2447.camel@gandalf.stny.rr.com>
	<20110504183052.GD1804@nowhere>
	<1304534785.25414.2452.camel@gandalf.stny.rr.com>
	<BANLkTin2ZS8DCLGZXxV7EN+S-aNRK=B8Sw@mail.gmail.com>
	<20110505131406.GA24235@mail.hallyn.com>
Date: Wed, 11 May 2011 20:20:27 -0700
Message-ID: <BANLkTi=NJgDx3v9QZuAC=TgwnBCQDOK3sQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is and
 how it works.
From: Will Drewry <wad@chromium.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Eric Paris <eparis@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        agl@chromium.org, jmorris@namei.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 5, 2011 at 6:14 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Will Drewry (wad@chromium.org):
>> In particular, if the userspace code wants to stage some filters and
>> apply them all at once, when ready, I'm not sure that it makes sense
>> to me to put that complexity in the kernel itself.  For instance,
>
> Hi Will,
>
> just one note - in my original comment I wasn't actually suggesting
> disabling setting of filters through a writeable file - I was only
> suggesting restricting writing to one's own filters file.
>
> All the better if it is possible to get a nice prctl-only
> interface, but if it ends up limiting rule expressiveness (or taking
> years to define an interface) then perhaps we should stick with
> prctl for setting seccomp mode, and a more expressive file interface
> for defining filters.

Didn't want you to think I missed this -- thanks for clarifying!  I've
attempted to pull together a prctl interface that balances the
directions proposed by Eric, Steven, Frederic, and co.  Upon
reflection of the /proc interface, it seems to have similar
challenges, but if the new patchset tanks and a /proc interface would
have more flexibility, I'll definitely explore that route.  I'd
certainly like to avoid spending years defining this, especially
upfront, and I'll take any guidance as to how to best reach a
reasonable starting place!  (Of course, I'd appreciate feedback on
this round of patches too :)

Thanks!
will
