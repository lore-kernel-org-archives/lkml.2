Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab2AWREX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 12:04:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab2AWREV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 12:04:21 -0500
Date: Mon, 23 Jan 2012 17:56:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Chris Evans <scarybeasts@gmail.com>
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
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re:
	[RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
Message-ID: <20120123165644.GB13197@redhat.com>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com> <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl> <20120118015013.GR11715@one.firstfloor.org> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk> <20120118022217.GS11715@one.firstfloor.org> <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl> <CAMnK33UzmQ-PdgAovmX9Q9JB5gKxw0mmLt0TZwK7xnWPWCqUzA@mail.gmail.com> <20120118170006.GA16835@redhat.com> <20120118171210.GB16835@redhat.com> <CAMnK33VcHEP4sMkzk09VEZL=h2eUqvHHF99jmF0qzDj_6SzVOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMnK33VcHEP4sMkzk09VEZL=h2eUqvHHF99jmF0qzDj_6SzVOw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18, Chris Evans wrote:
>
> Thanks, Oleg. Seems like this would be a nice change to have. As we
> can see, people do use ptrace() as a security technology.

OK, I'll send it.

> With this in place, you can also (where possible) set up the tracee
> with PR_SET_PDEATHSIG==SIGKILL. And then, you have defences again
> either of the tracer or tracee dying from a stray SIGKILL.

This can only help if the tracer is the natural parent, is it enough?

Indan suggested PTRACE_O_SIGKILL_ON_DEATH, perhaps it makes sense.

Oleg.

