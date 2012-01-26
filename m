Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab2AZKkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 05:40:36 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:39952 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab2AZKke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 05:40:34 -0500
MIME-Version: 1.0
In-Reply-To: <20120126103157.GE18613@jl-vm1.vm.bytemark.co.uk>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
 <20120125193635.GA30311@redhat.com> <201201260032.57937.vda.linux@googlemail.com>
 <ca17a86f7c88f8884e4ffc9bafbf2dff.squirrel@webmail.greenhost.nl>
 <20120126010858.GD18613@jl-vm1.vm.bytemark.co.uk> <88753c7d600bee39c06bbda32b08daae.squirrel@webmail.greenhost.nl>
 <20120126103157.GE18613@jl-vm1.vm.bytemark.co.uk>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 26 Jan 2012 11:40:12 +0100
Message-ID: <CAK1hOcPbamBW9KdnL8ORG4=u6R6ydvRX8tBJGB-pnXL6z1Y_sw@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
To: Jamie Lokier <jamie@shareable.org>
Cc: Indan Zupancic <indan@nul.nu>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Andrew Lutomirski <luto@mit.edu>,
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

On Thu, Jan 26, 2012 at 11:31 AM, Jamie Lokier <jamie@shareable.org> wrote:
> Indan Zupancic wrote:
>> On Thu, January 26, 2012 02:08, Jamie Lokier wrote:
>> > Is it disambiguated by PTRACE_EVENT_EXEC happening before the execve
>> > returns, and you knowing the TID always changes to the PID?  I haven't
>> > yet checked which TID gets the PTRACE_EVENT_EXEC event, but if it's
>> > not the old one, perhaps that could be changed.
>>
>> Please don't ever change the behaviour of PTRACE_EVENT_EXEC, it's
>> barely documented already, but if if ever changes it will be also
>> unreliable.
>>
>> It's still unclear if the PTRACE_EVENT_EXEC comes before or after
>> or instead of the post-execve ptrace event.

Denis <- confused.
Was ist das "post-execve ptrace event"? I know no such thing.
I know about PTRACE_EVENT_EXEC, and "post-execve SIGTRAP".


>> I guess before, but
>> can I count on that? If it is after then I get a stray weird
>> execve event that messes up the system call cadence.
>
> It should be *sent* before because the exec steps must finish before
> the execve() syscall "returns".
>
> I'm not sure if the events are guaranteed to be received in the same
> order as they are sent.

All ptrace stops (events and other stops) are synchronous.
Tracee stops, tracer notices it, tracer restarts tracee,
and only after this tracee can generate next event.
Therefore ptrace stops can't get reordered.

-- 
vda
