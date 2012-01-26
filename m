Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab2AZOCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:02:46 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45333 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab2AZOCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:02:44 -0500
MIME-Version: 1.0
In-Reply-To: <20120126110149.GF18613@jl-vm1.vm.bytemark.co.uk>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
 <20120125193635.GA30311@redhat.com> <201201260032.57937.vda.linux@googlemail.com>
 <ca17a86f7c88f8884e4ffc9bafbf2dff.squirrel@webmail.greenhost.nl>
 <20120126010858.GD18613@jl-vm1.vm.bytemark.co.uk> <88753c7d600bee39c06bbda32b08daae.squirrel@webmail.greenhost.nl>
 <20120126103157.GE18613@jl-vm1.vm.bytemark.co.uk> <CAK1hOcPbamBW9KdnL8ORG4=u6R6ydvRX8tBJGB-pnXL6z1Y_sw@mail.gmail.com>
 <20120126110149.GF18613@jl-vm1.vm.bytemark.co.uk>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 26 Jan 2012 15:02:21 +0100
Message-ID: <CAK1hOcNvOFLero8Mw+j2chhY8WxFCxtx3ZQpYZLkLqNGtaSMrw@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 12:01 PM, Jamie Lokier <jamie@shareable.org> wrote:
> Denys Vlasenko wrote:
>> On Thu, Jan 26, 2012 at 11:31 AM, Jamie Lokier <jamie@shareable.org> wrote:
>> >> It's still unclear if the PTRACE_EVENT_EXEC comes before or after
>> >> or instead of the post-execve ptrace event.
>>
>> Denis <- confused.
>> Was ist das "post-execve ptrace event"? I know no such thing.
>> I know about PTRACE_EVENT_EXEC, and "post-execve SIGTRAP".
>
> Sorry, I meant to write execve-syscall-exit event.

PTRACE_EVENT_EXEC happens before syscall exit. syscall exit
is not lost. Basically, the sequence is:

tracer               tracee with tid N, tgid M
   <------------- syscall entry for execve, pid=N
PTRACE_SYSCALL--->
   <------------- PTRACE_EVENT_EXEC, pid=M
PTRACE_GETEVENTMSG-->
   <------------- returns N ("I used to be tid N")
PTRACE_SYSCALL--->
   <------------- syscall exit for execve, pid=M
...

-- 
vda
