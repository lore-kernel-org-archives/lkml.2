Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab2AZBVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 20:21:42 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57581 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab2AZBVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 20:21:39 -0500
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Jamie Lokier <jamie@shareable.org>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
Date: Thu, 26 Jan 2012 02:21:33 +0100
User-Agent: KMail/1.8.2
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Indan Zupancic <indan@nul.nu>, Andi Kleen <andi@firstfloor.org>,
        Andrew Lutomirski <luto@mit.edu>, Will Drewry <wad@chromium.org>,
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
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com> <201201260032.57937.vda.linux@googlemail.com> <20120126005901.GC18613@jl-vm1.vm.bytemark.co.uk>
In-Reply-To: <20120126005901.GC18613@jl-vm1.vm.bytemark.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201201260221.33224.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 January 2012 01:59, Jamie Lokier wrote:
> Denys Vlasenko wrote:
> > (2) syscall exit compat-ness is known from entry type - no need to indicate it; and
> > (3) if we would flag syscall entry with an event value in wait status, then syscall
> > exit will be already distinquisable.
> >
> > Thus, minimally we need one new option, PTRACE_O_TRACE_SYSENTRY -
> > "on syscall entry ptrace stop, set a nonzero event value in wait status"
> > , and two event values: PTRACE_EVENT_SYSCALL_ENTRY (for native entry),
> > PTRACE_EVENT_SYSCALL_ENTRY1 for compat one.
> 
> PTRACE_EVENT_SYSCALL_EXIT would cleanly indicate that the new option
> is actually working without the tracer needing to do a fork+test, if
> PTRACE_ATTACH is used and for some reason the tracer sees a syscall
> exit first.

Can't happen. After PTRACE_ATTACH, you can only see tracee dying, or
getting a signal delivery (usually a SIGSTOP). Anything else
would be a kernel bug.

-- 
vda
