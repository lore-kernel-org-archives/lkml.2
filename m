Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab2ATAGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 19:06:12 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42683 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2ATAGK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 19:06:10 -0500
MIME-Version: 1.0
In-Reply-To: <20120119235446.GR7180@jl-vm1.vm.bytemark.co.uk>
References: <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
 <20120118022217.GS11715@one.firstfloor.org> <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
 <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
 <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
 <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
 <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
 <CAObL_7FsNQaPQg-3=AO9RuMNZZsRgDSJYPhPevDKERws9vQJWg@mail.gmail.com>
 <20120119160113.GN7180@jl-vm1.vm.bytemark.co.uk> <CA+55aFyZ-=4J1hVSAJiBiZKgpvuh-t54KPjLijRmU=cBtdi3-w@mail.gmail.com>
 <20120119235446.GR7180@jl-vm1.vm.bytemark.co.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Jan 2012 16:05:47 -0800
X-Google-Sender-Auth: kmX7zqsGTBEbB-CsAb4DtANUCVE
Message-ID: <CA+55aFyh=u0UFkSTmn4r6Kt3D2gSbTsd0RTHwgp7ZVMhcSXhzg@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
To: Jamie Lokier <jamie@shareable.org>
Cc: Andrew Lutomirski <luto@mit.edu>, Indan Zupancic <indan@nul.nu>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 3:54 PM, Jamie Lokier <jamie@shareable.org> wrote:
>
> Mine was: strace currently checks the CS value and may have a bug on
> existing/older kernels if Xen is involved when using the *normal*
> syscall entry point (not int $0x80).  Can we patch strace to solve
> that on those kernels in a generic way, or does the fix need to
> hard-code knowledge of Xen's CS values (and any similar PV hypervisors
> if there are any).
>
> No amount of patching newer kernels will fix that, but it would be
> nice if newer kernels made it unambiguous.

Ok.  So yeah, I think the heuristics for strace could possibly be
improved when running under Xen, I agree. See my suggestion for taking
other register contents into account (%rsp in particular - the code
segment tends to be mapped low in 64-bit mode, but the stack is almost
always high unless you are doing something really odd).

So heuristics improvements could be a good idea. Very few real
programs will use "int 0x80" in long mode, since it's slow and limited
to 32 bit.

               Linus
