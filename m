Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab2AUBYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 20:24:22 -0500
Received: from mail2.shareable.org ([80.68.89.115]:50762 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab2AUBYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 20:24:16 -0500
Date: Sat, 21 Jan 2012 01:23:11 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Roland McGrath <mcgrathr@google.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Indan Zupancic <indan@nul.nu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Andrew Lutomirski <luto@mit.edu>,
        Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
Message-ID: <20120121012311.GW7180@jl-vm1.vm.bytemark.co.uk>
References: <20120116183730.GB21112@redhat.com>
 <4F19EDAF.2000109@zytor.com>
 <d8be1991e82ec686433c5c6e255c2bd9.squirrel@webmail.greenhost.nl>
 <201201210107.37250.vda.linux@googlemail.com>
 <CAB=4xhpKM5VwhKeoevzp+4VqvstV8siqjy68TJYBBir9F8hP1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=4xhpKM5VwhKeoevzp+4VqvstV8siqjy68TJYBBir9F8hP1g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> On Fri, Jan 20, 2012 at 4:07 PM, Denys Vlasenko
> <vda.linux@googlemail.com> wrote:
> >> Maybe a bit telling whether it is syscall entry or exit?
> >
> > Yes, this one too. This is one of longstanding annoyances
> > that this information is not exposed.
> 
> That is not really "state", it's just which event you want.
> That is much better addressed by replacing PTRACE_SYSCALL
> with PTRACE_O_TRACE_SYSCALL_{ENTRY,EXIT} and PTRACE_EVENT_SYSCALL_{ENTRY,EXIT}.
> Oleg can whip that up for you no problem.

I agree, that is so obviously the right thing to do and it's very easy
to do in the tracehook functions.

There is one slight problem that some archs don't use
tracehook yet. Probably that should be fixed anyway.

(Fwiw, two other issues with arch-independent ptrace have come up in this
thread, which ought to be fairly easy to fix:
   - If tracer dies, tracee is free to continue running.  For security
     tracers, and would be useful for strace as well, it would be good
     to have an option to SIGKILL the tracee if tracer dies.
   - Can't abort or change an unwanted syscall if the process receives
     SIGKILL as it's about to start a syscall (which will be its last).)

-- Jamie
