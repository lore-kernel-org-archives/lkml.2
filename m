Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab2BFUj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 15:39:56 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:56321 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab2BFUjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 15:39:55 -0500
MIME-Version: 1.0
In-Reply-To: <4F30387A.9040209@zytor.com>
References: <20120116183730.GB21112@redhat.com> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
 <20120118022217.GS11715@one.firstfloor.org> <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
 <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
 <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
 <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
 <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
 <CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com>
 <4F1731C1.4050007@zytor.com> <4F1733DF.7040905@zytor.com> <4F1737C9.3070905@zytor.com>
 <CAB=4xhqW8RK2UpU5PPjSQo3nZYt8oZkaBf1VEhX37tbMVrAigg@mail.gmail.com>
 <4F173F48.2070604@zytor.com> <CA+55aFw3kv_JRsSCQEf6fQd0gX939MuoevDxFtcXkPY+bmyjtA@mail.gmail.com>
 <4F176605.5020101@zytor.com> <CAK1hOcManWsEvjS2xxtfGTKx=JLPvO2sBkWU-xQP+medV=rbAA@mail.gmail.com>
 <CAB=4xhqFYdU3s_NQkgdzVVG1r3vGDb=qPewPRFTrJ1B_eiEVDA@mail.gmail.com> <4F30387A.9040209@zytor.com>
From: Roland McGrath <mcgrathr@google.com>
Date: Mon, 6 Feb 2012 12:39:28 -0800
Message-ID: <CAB=4xhrGqGi-XoG9xG=XrOkdSJeshxQ2WKw7TRO1XeKBuz+J4A@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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

On Mon, Feb 6, 2012 at 12:30 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> What is needed to make a regset variable-sized?  Just declaring that it
> may change in size in the future, or does one need a length field at the
> top (I would personally have expected that both notes and ptrace would
> have out-of-band methods for getting the size?)

ELF notes do have a size field, so core files are self-explanatory.  There
is no ptrace interface to directly interrogate the regset details (one
could be added).  But the PTRACE_GETREGSET interface is to accept an upper
bound and yield the actual size filled in (which might be less than the
regset's size if the user-supplied buffer was smaller).  So in practice, a
caller can just use a buffer that's sure to be large enough, and then look
at iov_len for the actual size delivered.  (And nobody has yet complained
about this for xstate, though that might just be that nobody is really
using it.)


Thanks,
Roland
