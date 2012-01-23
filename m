Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab2AWQzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:55:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab2AWQzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:55:53 -0500
Date: Mon, 23 Jan 2012 17:48:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Indan Zupancic <indan@nul.nu>
Cc: Jamie Lokier <jamie@shareable.org>, Roland McGrath <mcgrathr@google.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Andrew Lutomirski <luto@mit.edu>,
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
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
Message-ID: <20120123164815.GA13197@redhat.com>
References: <20120116183730.GB21112@redhat.com> <4F19EDAF.2000109@zytor.com> <d8be1991e82ec686433c5c6e255c2bd9.squirrel@webmail.greenhost.nl> <201201210107.37250.vda.linux@googlemail.com> <CAB=4xhpKM5VwhKeoevzp+4VqvstV8siqjy68TJYBBir9F8hP1g@mail.gmail.com> <20120121012311.GW7180@jl-vm1.vm.bytemark.co.uk> <beeb7e2f1e2c8774c44f60e65b100941.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <beeb7e2f1e2c8774c44f60e65b100941.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23, Indan Zupancic wrote:
>
> On Sat, January 21, 2012 02:23, Jamie Lokier wrote:
> >
> > (Fwiw, two other issues with arch-independent ptrace have come up in this
> > thread, which ought to be fairly easy to fix:
> >    - If tracer dies, tracee is free to continue running.  For security
> >      tracers, and would be useful for strace as well, it would be good
> >      to have an option to SIGKILL the tracee if tracer dies.
>
> It should be easy to add a PTRACE_O_SIGKILL_ON_DEATH option.

Yes, this looks simple.

> >    - Can't abort or change an unwanted syscall if the process receives
> >      SIGKILL as it's about to start a syscall (which will be its last).)
>
> This is very important for any syscall filtering/control via ptrace, otherwise
> SIGKILL becomes a security problem. Oleg had a patch for that:

OK, I'll send this patch after some testing. Although it looks trivial.

Oleg.

