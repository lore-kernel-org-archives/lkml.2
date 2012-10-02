Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab2JBAdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:33:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43054 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2JBAdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:33:35 -0400
MIME-Version: 1.0
In-Reply-To: <1348888554.22822.108.camel@gandalf.local.home>
References: <1348148044.13080.59.camel@gandalf.local.home> <1348181550-21931-1-git-send-email-dhsharp@google.com>
 <1348888554.22822.108.camel@gandalf.local.home>
From: David Sharp <dhsharp@google.com>
Date: Mon, 1 Oct 2012 17:33:12 -0700
Message-ID: <CAJL_ekt5WZV_P71dwgJ3hYh4V08tJ41QJZCETq0P7EOo+uyN-Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] tracing,x86: add a TSC trace_clock
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 8:15 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2012-09-20 at 15:52 -0700, David Sharp wrote:
>
>> diff --git a/include/asm-generic/trace_clock.h b/include/asm-generic/trace_clock.h
>> new file mode 100644
>> index 0000000..6726f1b
>> --- /dev/null
>> +++ b/include/asm-generic/trace_clock.h
>> @@ -0,0 +1,16 @@
>> +#ifndef _ASM_GENERIC_TRACE_CLOCK_H
>> +#define _ASM_GENERIC_TRACE_CLOCK_H
>> +/*
>> + * Arch-specific trace clocks.
>> + */
>> +
>> +/*
>> + * Additional trace clocks added to the trace_clocks
>> + * array in kernel/trace/trace.c
>> + * None if the architecture has not defined it.
>> + */
>> +#ifndef ARCH_TRACE_CLOCKS
>> +# define ARCH_TRACE_CLOCKS
>> +#endif
>> +
>> +#endif  /* _ASM_GENERIC_TRACE_CLOCK_H */
>
> Unfortunately this isn't enough. You need to add a stub in all
> arch/*/include/asm/ directories. That has:

Oh really? Okay. Sorry, I really don't know the mechanics of the arch
trees. I'll work on that now, and then send you a new series since I
forgot to send out my last update.

>
> --- trace_clock.h:
> #ifndef _ASM_TRACE_CLOCK_H
> #define _ASM_TRACE_CLOCK_H
>
> #include <asm-generic/trace_clock.h>
>
> #endif
> ---
>
>
> Because running this against my cross-compile test, failed on all archs
> but x86.
>
> -- Steve
>
>
