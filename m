Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab2ARTkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 14:40:06 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39976 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2ARTkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 14:40:04 -0500
MIME-Version: 1.0
In-Reply-To: <20120118193602.GV11715@one.firstfloor.org>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
 <20120118015013.GR11715@one.firstfloor.org> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
 <20120118022217.GS11715@one.firstfloor.org> <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
 <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
 <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
 <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
 <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com> <20120118193602.GV11715@one.firstfloor.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Jan 2012 11:39:41 -0800
X-Google-Sender-Auth: ZOMy86d4kWFIDy6K8-9F_PxkRUk
Message-ID: <CA+55aFz+NNf3SrAdno72EEVbhM-tgBcwjz0ao3TLiOSJR-yJoQ@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
To: Andi Kleen <andi@firstfloor.org>
Cc: Indan Zupancic <indan@nul.nu>, Jamie Lokier <jamie@shareable.org>,
        Andrew Lutomirski <luto@mit.edu>, Oleg Nesterov <oleg@redhat.com>,
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

On Wed, Jan 18, 2012 at 11:36 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> The real fix is really to use a LSM for custom jails.  Trying to make
> ptrace secure is trying to make a sieve wather tight by plugging the individual
> holes one by one. It's simply not suitable for this.

Umm. But the exact same is true of "LSM for custom jail". It's a
f*&^ing disaster, and it's a whole lot more complicated than ptrace.

Plus it can't even do what ptrace does, so what's the point?  There's
a lot of system calls that don't have any kind of lsm hooks, and
shouldn't. Exactly because THAT is a "plugging individual holes one by
one" approach.

                     Linus
