Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab2AWWXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 17:23:22 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:45392 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603Ab2AWWXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 17:23:20 -0500
MIME-Version: 1.0
In-Reply-To: <20120123165644.GB13197@redhat.com>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
	<49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
	<20120118015013.GR11715@one.firstfloor.org>
	<20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
	<20120118022217.GS11715@one.firstfloor.org>
	<fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
	<CAMnK33UzmQ-PdgAovmX9Q9JB5gKxw0mmLt0TZwK7xnWPWCqUzA@mail.gmail.com>
	<20120118170006.GA16835@redhat.com>
	<20120118171210.GB16835@redhat.com>
	<CAMnK33VcHEP4sMkzk09VEZL=h2eUqvHHF99jmF0qzDj_6SzVOw@mail.gmail.com>
	<20120123165644.GB13197@redhat.com>
Date: Mon, 23 Jan 2012 14:23:18 -0800
Message-ID: <CAMnK33Xy0hGh=PoKs+JtPqftaPOhWAOHxbOGpsbHgGYgnauu4g@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re:
 [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
From: Chris Evans <scarybeasts@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Indan Zupancic <indan@nul.nu>, Andi Kleen <andi@firstfloor.org>,
        Jamie Lokier <jamie@shareable.org>, Andrew Lutomirski <luto@mit.edu>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 8:56 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/18, Chris Evans wrote:
>>
>> Thanks, Oleg. Seems like this would be a nice change to have. As we
>> can see, people do use ptrace() as a security technology.
>
> OK, I'll send it.
>
>> With this in place, you can also (where possible) set up the tracee
>> with PR_SET_PDEATHSIG==SIGKILL. And then, you have defences again
>> either of the tracer or tracee dying from a stray SIGKILL.
>
> This can only help if the tracer is the natural parent, is it enough?
>
> Indan suggested PTRACE_O_SIGKILL_ON_DEATH, perhaps it makes sense.

Yeah, this takes care of all cases.

One caveat I can think of with the implementation: in the parent
exit() path, the child's SIGKILL needs to be delivered _before_ the
tracer is detached. Otherwise it might feasible wake up and run for a
bit :)


Cheers
Chris

>
> Oleg.
>
