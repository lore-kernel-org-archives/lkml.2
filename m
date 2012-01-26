Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab2AZTT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 14:19:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab2AZTT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 14:19:56 -0500
Date: Thu, 26 Jan 2012 19:44:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Indan Zupancic <indan@nul.nu>, Andi Kleen <andi@firstfloor.org>,
        Jamie Lokier <jamie@shareable.org>, Andrew Lutomirski <luto@mit.edu>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
Message-ID: <20120126184438.GA25629@redhat.com>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com> <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com> <20120125193635.GA30311@redhat.com> <201201260032.57937.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201260032.57937.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26, Denys Vlasenko wrote:
>
> On Wednesday 25 January 2012 20:36, Oleg Nesterov wrote:
> >
> > We can add the new events,
> >
> > 	PTRACE_EVENT_SYSCALL_ENTRY
> > 	PTRACE_EVENT_SYSCALL_COMPAT_ENTRY
> > 	PTRACE_EVENT_SYSCALL_EXIT
> > 	PTRACE_EVENT_SYSCALL_COMPAT_EXIT
>
> We can get away with just the first one.
> (1) It's unlikely people would want to get native sysentry events but not compat ones,
> thus first two options can be combined into one;

Confused... Sure, we need the single option, or we could even report
this unconditionally if PT_SEIZED.

I meant the different PTRACE_EVENT_* codes only.

> (2) syscall exit compat-ness is known from entry type - no need to indicate it; and
> (3) if we would flag syscall entry with an event value in wait status, then syscall
> exit will be already distinquisable.

Well, if we add _ENTRY then it looks more consistent to report _EXIT
as well even if it is not that useful.

Doesn't matter. Nobody seem to like this, and afaics Linus has the
good arguments against the arch-independent "consolidation".

Oleg.

