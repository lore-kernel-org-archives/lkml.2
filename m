Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295Ab2ILSsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:48:54 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58895 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab2ILSsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:48:50 -0400
MIME-Version: 1.0
In-Reply-To: <1347421685.10751.34.camel@gandalf.local.home>
References: <1347417671-22998-1-git-send-email-dhsharp@google.com>
 <1347417671-22998-2-git-send-email-dhsharp@google.com> <1347421685.10751.34.camel@gandalf.local.home>
From: David Sharp <dhsharp@google.com>
Date: Wed, 12 Sep 2012 11:48:29 -0700
Message-ID: <CAJL_ekvGkVpK_v2ztZPoES_R+odjEJXbxuR7LZs6Q_dTNJJpfg@mail.gmail.com>
Subject: Re: [PATCH 1/3] tracing,x86: add a TSC trace_clock; reset buffer on
 clock change
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 8:48 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2012-09-11 at 19:41 -0700, David Sharp wrote:
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index 5c38c81..dc1f1fa 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -480,6 +480,9 @@ static struct {
>>       { trace_clock_local,    "local" },
>>       { trace_clock_global,   "global" },
>>       { trace_clock_counter,  "counter" },
>> +#ifdef CONFIG_X86_TSC
>> +     { trace_clock_tsc,      "tsc" },
>> +#endif
>>  };
>
> I really hate adding arch defs in generic code. Perhaps what we could do
> is add a define here. Something like:
>
> #ifndef ARCH_TRACE_CLOCKS
> # define ARCH_TRACE_CLOCKS
> #endif
>
> [...]
>         { trace_clock_counter, "counter" },
>         ARCH_TRACE_CLOCKS
> };
>
> and have ARCH_TRACE_CLOCKS defined somewhere in an arch specific header.
> Not sure what header we could use though :-/
>
> That is, in a header have:
>
> #define ARCH_TRACE_CLOCKS \
>         { trace_clock_x86_tsc,  "tsc" },
>
> and also define trace_clock_x86_tsc in arch/x86/kernel...

Good point. I'll figure out somewhere better to put it...
