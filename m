Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab2ARVvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 16:51:40 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52483 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab2ARVvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 16:51:39 -0500
MIME-Version: 1.0
In-Reply-To: <4F1737C9.3070905@zytor.com>
References: <20120116183730.GB21112@redhat.com> <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com>
 <20120117170512.GB17070@redhat.com> <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
 <20120118015013.GR11715@one.firstfloor.org> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
 <20120118022217.GS11715@one.firstfloor.org> <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
 <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
 <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
 <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
 <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
 <CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com>
 <4F1731C1.4050007@zytor.com> <4F1733DF.7040905@zytor.com> <4F1737C9.3070905@zytor.com>
From: Roland McGrath <mcgrathr@google.com>
Date: Wed, 18 Jan 2012 13:51:12 -0800
Message-ID: <CAB=4xhqW8RK2UpU5PPjSQo3nZYt8oZkaBf1VEhX37tbMVrAigg@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Indan Zupancic <indan@nul.nu>, Andi Kleen <andi@firstfloor.org>,
        Jamie Lokier <jamie@shareable.org>, Andrew Lutomirski <luto@mit.edu>,
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
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 1:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Roland, could you refresh my memory what your objection to this was?

Sorry, I don't really recall.  I could dig through old email archives, but
they'd be archives of messages I sent to you, so you should have them too.

The only principle in this area I recall having an opinion about is that
we should not mix up things that are bona fide user-visible state with
things that aren't.  (By "user-visible" I mean things that the task in
question can see or affect by just doing normal instructions, as opposed
to things only controlled via ptrace, such as the debug registers.)  But
that principle is not really being violated here.

I recall that you and I discussed making the path-of-entry visible somehow
and I was in favor of doing that.  As I recall it, we just never bothered
to follow through.

There are all the concerns about obscure ABI compatibility with
expectations of existing debuggers and so forth, which Linus has mentioned.
For that I can accept his point that things today so mishandle the
int80-from-64 case that something like a new meaning for high bits of
orig_ax or whatnot in just that case would not be actually problematic.
When you and I were discussing a more general feature of distinguishing
int80 from sysenter from syscall from traps from asynchronous interrupts,
that was of more concern.

I do feel strongly that any new means of exposing bona fide user state
ought to be done via the user_regset mechanism.  (i.e., either overloading
some existing user_regs_struct bits if that truly is harmless to
compatibility, or adding a new regset flavor.)  That way it is
automatically recorded in core files, accessible with PTRACE_GETREGSET,
etc.  (But I'm not really working on this stuff any more, so I'm out of the
business of arguing strenuously about such opinions.)


Thanks,
Roland
