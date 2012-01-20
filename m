Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab2ATCCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 21:02:34 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:49234 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab2ATCC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 21:02:28 -0500
Message-ID: <f8e85a6bf8890b1e9c5d3e61e1ffde23.squirrel@webmail.greenhost.nl>
In-Reply-To: <CA+55aFyo1L81svwpWB-AVBaOOPUuvb3j+U0qDjL=NDVDj9ccYg@mail.gmail.com>
References: <20120117170512.GB17070@redhat.com>
    <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
    <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
    <20120118015013.GR11715@one.firstfloor.org>
    <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
    <CA+55aFyVTh4SQjjcf3x9BSzULttNVcmG9FyaKzhok=2_804xWA@mail.gmail.com>
    <20120118023114.GA9643@alboin.amr.corp.intel.com>
    <CA+55aFyEde=PLkgsx+FECRrX-dSsOSQkeY_by5=+hnkQhj5hFw@mail.gmail.com>
    <mj+md-20120118.134958.22774.nikam@ucw.cz>
    <20120118182411.GT11715@one.firstfloor.org>
    <20120119160429.GO7180@jl-vm1.vm.bytemark.co.uk>
    <930b350b8504fa9e1272f93bf21dde49.squirrel@webmail.greenhost.nl>
    <CA+55aFyo1L81svwpWB-AVBaOOPUuvb3j+U0qDjL=NDVDj9ccYg@mail.gmail.com>
Date: Fri, 20 Jan 2012 03:02:03 +0100
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re:
 [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
From: "Indan Zupancic" <indan@nul.nu>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Jamie Lokier" <jamie@shareable.org>, "Andi Kleen" <andi@firstfloor.org>,
        "Martin Mares" <mj@ucw.cz>, "Andi Kleen" <ak@linux.intel.com>,
        "Andrew Lutomirski" <luto@mit.edu>, "Oleg Nesterov" <oleg@redhat.com>,
        "Will Drewry" <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com,
        "Roland McGrath" <mcgrathr@chromium.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 1.4
X-Scan-Signature: 258bd43c1b7c380ff6f1b27dffaa1ebc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, January 20, 2012 01:53, Linus Torvalds wrote:
> On Thu, Jan 19, 2012 at 4:21 PM, Indan Zupancic <indan@nul.nu> wrote:
>>
>> With current ptrace you can do exactly that. It's just very slow, because
>> you have to copy the data word by word via PTRACE_PEEKDATA. But if Linux
>> would support something like BSD's PT_IO ptrace request, then it could be
>> limited to one extra ptrace command. (PTRACE_STRNCPY would be handy.)
>
> Actually, you could use the new "process_vm_readv/writev()" system
> calls. No need to do the crazy slow ptrace stuff.

Oh wow, that's great! I tried pread on /proc/$PID/mem before, but that
didn't work for some reason and would eat many fd's if there were a lot
of prisoners.

When did it got merged?

> I dunno. It got merged through Andrew, and the code looks sane, but
> I've never actually seen anybody *use* it. So maybe there is something
> wrong there. And no, it doesn't have a "strncpy" interface, I'm
> afraid.

My main problem is that I don't know beforehand how much I have to read,
and if I always reada fixed amount it may go across a page border and
error out. So if process_vm_readv() reads the accessible data only and
doesn't give up halfway, it's perfect. That seems to be the behaviour,
but the manpage is fuzzy enough that it may not be true. I'll take a
look at the source later.

Thanks,

Indan


