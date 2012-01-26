Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab2AZLUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:20:24 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:42880 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab2AZLUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:20:18 -0500
Message-ID: <29acd271cd920259e9703c438295d7b3.squirrel@webmail.greenhost.nl>
In-Reply-To: <CAK1hOcPbamBW9KdnL8ORG4=u6R6ydvRX8tBJGB-pnXL6z1Y_sw@mail.gmail.com>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
    <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
    <20120125193635.GA30311@redhat.com>
    <201201260032.57937.vda.linux@googlemail.com>
    <ca17a86f7c88f8884e4ffc9bafbf2dff.squirrel@webmail.greenhost.nl>
    <20120126010858.GD18613@jl-vm1.vm.bytemark.co.uk>
    <88753c7d600bee39c06bbda32b08daae.squirrel@webmail.greenhost.nl>
    <20120126103157.GE18613@jl-vm1.vm.bytemark.co.uk>
    <CAK1hOcPbamBW9KdnL8ORG4=u6R6ydvRX8tBJGB-pnXL6z1Y_sw@mail.gmail.com>
Date: Thu, 26 Jan 2012 12:19:42 +0100
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
From: "Indan Zupancic" <indan@nul.nu>
To: "Denys Vlasenko" <vda.linux@googlemail.com>
Cc: "Jamie Lokier" <jamie@shareable.org>, "Oleg Nesterov" <oleg@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>, "Andrew Lutomirski" <luto@mit.edu>,
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
X-Scan-Signature: dfea3049d3b923820beb462d65569822
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, January 26, 2012 11:40, Denys Vlasenko wrote:
> On Thu, Jan 26, 2012 at 11:31 AM, Jamie Lokier <jamie@shareable.org> wrote:
>> Indan Zupancic wrote:
>>> On Thu, January 26, 2012 02:08, Jamie Lokier wrote:
>>> > Is it disambiguated by PTRACE_EVENT_EXEC happening before the execve
>>> > returns, and you knowing the TID always changes to the PID? �I haven't
>>> > yet checked which TID gets the PTRACE_EVENT_EXEC event, but if it's
>>> > not the old one, perhaps that could be changed.
>>>
>>> Please don't ever change the behaviour of PTRACE_EVENT_EXEC, it's
>>> barely documented already, but if if ever changes it will be also
>>> unreliable.
>>>
>>> It's still unclear if the PTRACE_EVENT_EXEC comes before or after
>>> or instead of the post-execve ptrace event.
>
> Denis <- confused.
> Was ist das "post-execve ptrace event"? I know no such thing.
> I know about PTRACE_EVENT_EXEC, and "post-execve SIGTRAP".

I mean the second SIGTRAP | 0x80 event, the syscall return of execve.

> All ptrace stops (events and other stops) are synchronous.
> Tracee stops, tracer notices it, tracer restarts tracee,
> and only after this tracee can generate next event.
> Therefore ptrace stops can't get reordered.

That's good to know and what I expected.

Since which kernel version does the PTRACE_GETEVENTMSG work and
is there a way to find out before it returns zero?

Greetings,

Indan


