Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab2ARCWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 21:22:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57512 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab2ARCWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 21:22:19 -0500
Date: Wed, 18 Jan 2012 03:22:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: Andi Kleen <andi@firstfloor.org>, Indan Zupancic <indan@nul.nu>,
        Andrew Lutomirski <luto@mit.edu>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
Message-ID: <20120118022217.GS11715@one.firstfloor.org>
References: <20120116183730.GB21112@redhat.com> <CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com> <20120117164523.GA17070@redhat.com> <CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com> <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com> <20120117170512.GB17070@redhat.com> <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com> <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl> <20120118015013.GR11715@one.firstfloor.org> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm pretty sure this isn't about changing cs or far jumps

He's assuming that code can only run on two code segments and
not arbitarily switch between them which is a completely incorrect
assumption.

> I think Indan means code is running with 64-bit cs, but the kernel
> treats int $0x80 as a 32-bit syscall and sysenter as a 64-bit syscall,
> and there's no way for the ptracer to know which syscall the kernel
> will perform, even by looking at all registers.  It looks like a hole
> in ptrace which could be fixed.

Possibly, but anything that bases its security on ptrace is typically
unfixable racy (just think what happens with multiple threads 
and syscall arguments), so it's unlikely to do any good.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
