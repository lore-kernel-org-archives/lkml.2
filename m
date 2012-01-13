Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab2AMBfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 20:35:33 -0500
Received: from mail2.shareable.org ([80.68.89.115]:44964 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab2AMBfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 20:35:30 -0500
Date: Fri, 13 Jan 2012 01:34:46 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Will Drewry <wad@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, luto@mit.edu, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
Message-ID: <20120113013446.GU7180@jl-vm1.vm.bytemark.co.uk>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
 <1326302710-9427-2-git-send-email-wad@chromium.org>
 <1326383015.7642.77.camel@gandalf.stny.rr.com>
 <CABqD9hbOUy1qO0f+JFitRXH6c5EgLTWOh5eGdo8dTxeXJ40h2g@mail.gmail.com>
 <20120112172241.GJ7180@jl-vm1.vm.bytemark.co.uk>
 <CABqD9hYza5BpOk-+n0svHVGuWem39M=asGTMPy0z1ke0rCv8hA@mail.gmail.com>
 <20120112175750.GN7180@jl-vm1.vm.bytemark.co.uk>
 <CABqD9hZUMpmS9yeJYfBZD8eTvS6MC6g8Cw+88SxDP520Jd0DNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABqD9hZUMpmS9yeJYfBZD8eTvS6MC6g8Cw+88SxDP520Jd0DNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Drewry wrote:
> >> > There's already a security model around who can use ptrace(); speeding
> >> > it up needn't break that.
> >> >
> >> > If we'd had BPF ptrace in the first place, SECCOMP wouldn't have been
> >> > needed as userspace could have done it, with exactly the restrictions
> >> > it wants.  Google's NaCl comes to mind as a potential user.
> >>
> >> That's not entirely true.  ptrace supervisors are subject to races and
> >> always fail open.  This makes them effective but not as robust as a
> >> seccomp solution can provide.
> >
> > What races do you know about?
> 
> I'm pretty sure that if you have two "isolated" processes, they could
> cause irregular behavior using signals.

Do you have an example?  I'm not aware of one and I've been studying
ptrace quite a bit lately.  If there's a race (other than temporary
kernel bugs with all the ptrace patching lately ;-), I would like to
know and maybe patch it.

The only signal confusion when ptracing syscalls I'm aware of is with
SIGTRAP, and that was fixed in 2.5.46, long, long ago (PTRACE_SETOPTIONS).

> > I'm not aware of any ptrace races if it's used properly.  I'm also not
> > sure what you mean by fail open/close here, unless you mean the target
> > process gets to carry on if the tracing process dies.
> 
> Exactly.  Security systems that, on failure, allow the action to
> proceed can't be relied on.

That's fair enough.  There are numerous occasions when ptracer death
should kill the tracee anyway regardless of security.  E.g. "strace
command..." and strace dies, you'd normally want the command to
be killed as well.  So that could be worth a ptrace option anyway.

Thanks,
-- Jamie
