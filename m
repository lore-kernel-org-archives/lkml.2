Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab0GJJpv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 05:45:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52640 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab0GJJpt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 05:45:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=T4Lz1fDAc8ZBJe8zIUSOYhyvbUV/7yzJCuhZJ7k1vzyU2ITydl6z1BNgpe0ehM+2X5
         fwI1lkZRw8CpjN4clpBP1rpj/KKLkZmr+bMrYnSY5f3Wz0eEzXMFcDBldYlPvu4sOQ57
         BbF2CCIT+ad+JgflKHeeFcHglrY7AXOh/YfWg=
MIME-Version: 1.0
In-Reply-To: <1278721339.1537.166.camel@gandalf.stny.rr.com>
References: <1278705402.1537.157.camel@gandalf.stny.rr.com> 
	<20100709203301.GA13839@merkur.ravnborg.org> <AANLkTinWkfkXNVA2Sx-apVQMZa-5ehugtd7JQ36np7xM@mail.gmail.com> 
	<1278721339.1537.166.camel@gandalf.stny.rr.com>
From: Zeev Tarantov <zeev.tarantov@gmail.com>
Date: Sat, 10 Jul 2010 12:45:28 +0300
Message-ID: <AANLkTilPKU1a38Ml5ROg32NqAMvFH8D7LDHg-97HTT_9@mail.gmail.com>
Subject: Re: [PATCH][GIT PULL][for 2.6.35] tracing: Add alignment to syscall 
	metadata declarations
To: rostedt@goodmis.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Maciej@antispam.struernethosting.dk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 03:22, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2010-07-09 at 14:25 -0700, Linus Torvalds wrote:
>> On Fri, Jul 9, 2010 at 1:33 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> >
>> > Something like this:
>> > (whitespace damaged)
>> > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
>> > index 48c5299..64430d3 100644
>> > --- a/include/asm-generic/vmlinux.lds.h
>> > +++ b/include/asm-generic/vmlinux.lds.h
>> > @@ -133,7 +133,8 @@
>> >  #endif
>> >
>> >  #ifdef CONFIG_FTRACE_SYSCALLS
>> > -#define TRACE_SYSCALLS() VMLINUX_SYMBOL(__start_syscalls_metadata) = .;        \
>> > +#define TRACE_SYSCALLS() . = ALIGN(8);                                 \
>> > +                        VMLINUX_SYMBOL(__start_syscalls_metadata) = .; \
>> >                         *(__syscalls_metadata)                         \
>> >                         VMLINUX_SYMBOL(__stop_syscalls_metadata) = .;
>> >  #else
>>
>> If this is confirmed to fix it, then I would much prefer this version.
>
> Zeev,
>
> Can you try Sam's version and remove mine. I'd like to see if that fixes
> the issue too.
>
> Thanks,
>
> -- Steve
>
>
>

Clean kernel source from tarball with only this patch applied, with
copied over config file, compiled with my gcc 4.5.1 doesn't boot. Same
call stack.
The disassembly begins same way as for unpatched source (0x...38 , 0x...40).
Now trying the patch to "Align to a 32 byte boundary".

-Zeev
