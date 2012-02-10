Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498Ab2BJBKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 20:10:33 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:33268 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab2BJBKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 20:10:30 -0500
Message-ID: <b3f79ce8b30e2985723eec1a3337317e.squirrel@webmail.greenhost.nl>
In-Reply-To: <CAMe9rOrf-DrgdwsnpX7pa=h1p9qSpqa9fwJAQJvjSzgR9MAB_w@mail.gmail.com>
References: <20120116183730.GB21112@redhat.com>
    <20120118015013.GR11715@one.firstfloor.org>
    <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
    <20120118022217.GS11715@one.firstfloor.org>
    <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
    <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
    <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
    <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
    <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
    <CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com>
    <dac05d1da093cb86e2f654fbfe66dfce.squirrel@webmail.greenhost.nl>
    <4F3007AD.50307@zytor.com>
    <c85c91a49cc62132ad1ddb97748c26b9.squirrel@webmail.greenhost.nl>
    <4F33110D.3050904@zytor.com>
    <13c2c571244c71c2ba87451987805eed.squirrel@webmail.greenhost.nl>
    <4F334B8C.2050005@zytor.com>
    <CAMe9rOrf-DrgdwsnpX7pa=h1p9qSpqa9fwJAQJvjSzgR9MAB_w@mail.gmail.com>
Date: Fri, 10 Feb 2012 02:09:59 +0100
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
From: "Indan Zupancic" <indan@nul.nu>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>,
        "Jamie Lokier" <jamie@shareable.org>,
        "Andrew Lutomirski" <luto@mit.edu>, "Oleg Nesterov" <oleg@redhat.com>,
        "Will Drewry" <wad@chromium.org>, linux-kernel@vger.kernel.org,
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
        "Roland McGrath" <mcgrathr@chromium.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 1.4
X-Scan-Signature: 4052b6d1c9976086d5ab5ce040fcf5b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, February 9, 2012 17:00, H.J. Lu wrote:
> GDB uses CS value to tell ia32 process from x86-64 process.

Are there any cases when this doesn't work? Someone said Xen can
have different CS values, but looking at the source it seems it's
using the same ones, at least with a Linux hypervisor. So perhaps
it was KVM. Looking at the header it seems paravirtualisation uses
different cs values. On the upside, it seems we can just use that
user_64bit_mode() to know whether it is 32 or 64 bit mode, so
adding a bit telling the process mode is easier than I thought.

Currently there is a need to tell if the 32 or 64-bit syscall
path is being taken, which is independent of the process mode.

> At minimum, we need a bit in CS for GDB.  But any changes
> will break old GDB.

Would adding bits to the upper 32-bit of rflags break GDB?

Do you also need a way to know whether the kernel was entered via
int 0x80, SYSCALL32/64 or SYSENTER?

Greetings,

Indan


