Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab2ATAx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 19:53:27 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57638 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab2ATAxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 19:53:24 -0500
MIME-Version: 1.0
In-Reply-To: <930b350b8504fa9e1272f93bf21dde49.squirrel@webmail.greenhost.nl>
References: <20120117170512.GB17070@redhat.com> <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
 <20120118015013.GR11715@one.firstfloor.org> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
 <CA+55aFyVTh4SQjjcf3x9BSzULttNVcmG9FyaKzhok=2_804xWA@mail.gmail.com>
 <20120118023114.GA9643@alboin.amr.corp.intel.com> <CA+55aFyEde=PLkgsx+FECRrX-dSsOSQkeY_by5=+hnkQhj5hFw@mail.gmail.com>
 <mj+md-20120118.134958.22774.nikam@ucw.cz> <20120118182411.GT11715@one.firstfloor.org>
 <20120119160429.GO7180@jl-vm1.vm.bytemark.co.uk> <930b350b8504fa9e1272f93bf21dde49.squirrel@webmail.greenhost.nl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Jan 2012 16:53:01 -0800
X-Google-Sender-Auth: _6xtwSovvhdk1GrtGGtbdRm8KIA
Message-ID: <CA+55aFyo1L81svwpWB-AVBaOOPUuvb3j+U0qDjL=NDVDj9ccYg@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re:
 [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
To: Indan Zupancic <indan@nul.nu>
Cc: Jamie Lokier <jamie@shareable.org>, Andi Kleen <andi@firstfloor.org>,
        Martin Mares <mj@ucw.cz>, Andi Kleen <ak@linux.intel.com>,
        Andrew Lutomirski <luto@mit.edu>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
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
        Roland McGrath <mcgrathr@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 4:21 PM, Indan Zupancic <indan@nul.nu> wrote:
>
> With current ptrace you can do exactly that. It's just very slow, because
> you have to copy the data word by word via PTRACE_PEEKDATA. But if Linux
> would support something like BSD's PT_IO ptrace request, then it could be
> limited to one extra ptrace command. (PTRACE_STRNCPY would be handy.)

Actually, you could use the new "process_vm_readv/writev()" system
calls. No need to do the crazy slow ptrace stuff.

I dunno. It got merged through Andrew, and the code looks sane, but
I've never actually seen anybody *use* it. So maybe there is something
wrong there. And no, it doesn't have a "strncpy" interface, I'm
afraid.

                   Linus
