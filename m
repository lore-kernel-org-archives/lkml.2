Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab3AJGyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 01:54:23 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:65352 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab3AJGyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 01:54:21 -0500
Message-ID: <6dff6dcdbfd7444f0b43d8b8bea6ca7c.squirrel@mail.sublimeip.com>
In-Reply-To: <20130109175203.GA32191@redhat.com>
References: <20121125225533.GA24905@redhat.com>
    <20121125234834.DAC34592076@miso.sublimeip.com>
    <20121202193058.GA4264@redhat.com>
    <841b7a319f9d22402d269eed23d03835.squirrel@mail.sublimeip.com>
    <20121204175933.GA11537@redhat.com> <50EC527C.5030800@redhat.com>
    <20130109175203.GA32191@redhat.com>
Date: Thu, 10 Jan 2013 17:54:19 +1100
Subject: Re: PTRACE_SYSCALL && vsyscall (Was: arch_check_bp_in_kernelspace:
 fix the range check)
From: u3557@miso.sublimeip.com
To: "Oleg Nesterov" <oleg@redhat.com>
Cc: "Pedro Alves" <palves@redhat.com>, u3557@miso.sublimeip.com,
        "Denys Vlasenko" <dvlasenk@redhat.com>,
        "Jan Kratochvil" <jan.kratochvil@redhat.com>,
        "Cyrill Gorcunov" <gorcunov@openvz.org>,
        "Pavel Emelyanov" <xemul@parallels.com>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
Reply-To: mosix@mosix.com.au
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Everyone,

> On 01/08, Pedro Alves wrote:
>>
>> On 12/04/2012 05:59 PM, Oleg Nesterov wrote:
>>
>> > But If we want to allow to trace vsyscall's, hw bp doesn't look very
>> > nice imo. HBP_NUM = 4 and you need to setup 3 bp's to trace them all.
>>
>> Irrespective of the whole syscall tracing issue, allowing HW bkpts in
>> the vsyscall just seems like a bug fix to me.
>
> And I never argued. I sent the patch iirc ;)

Exactly, it is a bug and I am still waiting for it to be fixed in the
Linux kernel.

Fully emulating PTRACE_SYSCALL could also provide a suitable way to
fix my problem, and it may also help others by saving them the need
to program and waste x86 debug registers, but it doesn't change the
fact that my problem is caused by a bug in the first place, which
should be fixed in any case.

Best Regards,
Amnon.


>
>> > That is why I think PTRACE_SYSCALL should "simply work" somehow. And
>> > so far I think that "just report syscall_exit with orig_ax = -1" is
>> > the best (and simple) solution.
>>
>> If you report exit alone, you'll confuse current GDB into mistaking
>> it for an enter,
>
> Sure. That is why I asked Jan.
>
>> > OK. We can do more. We can report both syscall_enter/exit and we can
>> > change orig_ax/ax temporary to "fool" the tracer, so that everything
>> > will look as a "normal" syscall. Like vsyscall_seccomp() does.
>> >
>> > But this needs much more changes.
>>
>> I'd just like to add, that if any new syscall related option is
>> to be added, can we please just go all the way and add
>> PTRACE_EVENT_SYSCALL_ENTER|PTRACE_EVENT_SYSCALL_EXIT instead?
>
> Oh yes, this was suggested many times.
>
> Oleg.
>
>


