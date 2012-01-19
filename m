Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab2ASTiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 14:38:17 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64051 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab2ASTiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 14:38:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAObL_7Gigcvurpa5J9FHrrdFkBHw7GSrP=e6nT4FFweGZz4+fg@mail.gmail.com>
References: <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
 <20120118015013.GR11715@one.firstfloor.org> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
 <20120118022217.GS11715@one.firstfloor.org> <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
 <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
 <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
 <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
 <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
 <CAObL_7FsNQaPQg-3=AO9RuMNZZsRgDSJYPhPevDKERws9vQJWg@mail.gmail.com>
 <20120119160113.GN7180@jl-vm1.vm.bytemark.co.uk> <CA+55aFyZ-=4J1hVSAJiBiZKgpvuh-t54KPjLijRmU=cBtdi3-w@mail.gmail.com>
 <CAObL_7Gigcvurpa5J9FHrrdFkBHw7GSrP=e6nT4FFweGZz4+fg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Jan 2012 11:37:50 -0800
X-Google-Sender-Auth: Xt_HjK5W1w4_2x5g3eSft33z5sE
Message-ID: <CA+55aFyJoLMA_uJfRfy2obCfbqs=RVLkHch67h-fQ=0DCbrS0w@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
To: Andrew Lutomirski <luto@mit.edu>
Cc: Jamie Lokier <jamie@shareable.org>, Indan Zupancic <indan@nul.nu>,
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

On Thu, Jan 19, 2012 at 11:30 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>
> Unless you're writing a debugger and you want to disassemble the code
> that's being executed (i.e. normal code, not a system call).  I wonder
> how gdb guesses whether the cpu is in long mode.

Yes, if you need to disassemble user space you would need to figure
out the mode.

I would suggest looking at 'rip/rsp' first, though, and just say that
if it's >32-bit, it's flat mode. Only if both rsp and rip fit in 32
bits should you even bother start guessing.

Because technically I suspect you really do need to look it up in the
segment descriptors, and I don't think we have that kind of interface
(nor do I think we really want to expose one).

                          Linus
