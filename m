Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2ALRpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:45:05 -0500
Received: from mail2.shareable.org ([80.68.89.115]:54644 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab2ALRpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:45:03 -0500
Date: Thu, 12 Jan 2012 17:44:33 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, luto@mit.edu,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
Message-ID: <20120112174433.GM7180@jl-vm1.vm.bytemark.co.uk>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
 <1326302710-9427-2-git-send-email-wad@chromium.org>
 <1326383015.7642.77.camel@gandalf.stny.rr.com>
 <20120112161418.GA22360@redhat.com>
 <1326386324.7642.96.camel@gandalf.stny.rr.com>
 <20120112173048.GK7180@jl-vm1.vm.bytemark.co.uk>
 <1326390006.7642.114.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326390006.7642.114.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 2012-01-12 at 17:30 +0000, Jamie Lokier wrote:
> 
> > You can do this now, using ptrace().  It's horrible, but half of the
> > horribleness is needing to understand machine-dependent registers,
> > which this new patch doesn't address.  (The other half is a ton of
> > undocumented but important ptrace() behaviours on Linux.)
> 
> Yeah I know the horrid use of ptrace, I've implemented programs that use
> it :-p

That warm fuzzy feeling :-)

> I guess ptrace can capture the execv and determine if it is OK or not to
> run it. But again, this doesn't stop the possible attacks that could
> happen, with having the execv on a symlink file, having the ptrace check
> say its OK, and then switching the symlink to a setuid file.
>
> When the new execv executed, the parent process would lose all control
> over it. The idea is to prevent this.

fexecve() exists to solve the problem.
Also known as execve("/proc/self/fd/...") on Linux.

> I like Alan's suggestion. Have userspace decide to allow execv or not,
> and even let it decide if it should allow setuid execv's or not, but
> still allow non-setuid execvs. If you allow the setuid execv, once that
> happens, the same behavior will occur as with ptrace. A setuid execv
> will lose all its filtering.

I like the idea of letting the tracer decide what it wants.

-- Jamie
