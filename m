Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab2ARCbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 21:31:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:11945 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531Ab2ARCbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 21:31:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="113420930"
Date: Tue, 17 Jan 2012 18:31:14 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jamie Lokier <jamie@shareable.org>, Andi Kleen <andi@firstfloor.org>,
        Indan Zupancic <indan@nul.nu>, Andrew Lutomirski <luto@mit.edu>,
        Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re:
 [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
Message-ID: <20120118023114.GA9643@alboin.amr.corp.intel.com>
References: <CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com>
 <20120117164523.GA17070@redhat.com>
 <CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com>
 <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com>
 <20120117170512.GB17070@redhat.com>
 <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
 <20120118015013.GR11715@one.firstfloor.org>
 <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
 <CA+55aFyVTh4SQjjcf3x9BSzULttNVcmG9FyaKzhok=2_804xWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFyVTh4SQjjcf3x9BSzULttNVcmG9FyaKzhok=2_804xWA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 06:27:19PM -0800, Linus Torvalds wrote:
> On Tue, Jan 17, 2012 at 6:04 PM, Jamie Lokier <jamie@shareable.org> wrote:
> >
> > I think Indan means code is running with 64-bit cs, but the kernel
> > treats int $0x80 as a 32-bit syscall and sysenter as a 64-bit syscall,
> > and there's no way for the ptracer to know which syscall the kernel
> > will perform, even by looking at all registers.  It looks like a hole
> > in ptrace which could be fixed.
> 
> We could possibly munge the "orig_ax" field to be different for the
> int80 vs syscall cases. That's really the only field that isn't direct
> x86 state. And it's 64 bits wide, but we really only care about the
> low 32 bits in the kernel. So a bit in the high bits that says "this
> was a int80 entry" would be possible.

That would be incompatible. However you could just add another virtual
register with such information (in fact I thought about that
when I did the compat code originally). However I don't think it'll salvage
the original broken by design ptrace jailer. And everyone else
so far has done fine without it.

-Andi
