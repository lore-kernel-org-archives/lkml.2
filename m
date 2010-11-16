Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082Ab0KPX2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 18:28:22 -0500
Received: from smtp-out.google.com ([216.239.44.51]:12802 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab0KPX2V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 18:28:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=XTNRvCiSB84BKhocUSDfhZjkSkJmWK8wabqd80J50V4pnRJgA93+/vy501/JO6tOPV
         /hZM1ZDPVhK7Or8J9+eA==
MIME-Version: 1.0
In-Reply-To: <1287013830.3673.224.camel@frodo>
References: <AANLkTikfYy-kYb1=KbsYwHd0_vcf20d2nPSfFynugz8z@mail.gmail.com>
 <AANLkTikKwx6okpX4pxVzTvrVNm=KhUvLQGs0_ziwo6fX@mail.gmail.com>
 <AANLkTimnjun98phJ_KmwFG_ce3YGpmVGf5rufqPStWR-@mail.gmail.com> <1287013830.3673.224.camel@frodo>
From: David Sharp <dhsharp@google.com>
Date: Tue, 16 Nov 2010 15:27:58 -0800
Message-ID: <AANLkTi=Y2X5EuqiCncPeNefgHs6vvGmnZpsyyddRR2g_@mail.gmail.com>
Subject: Re: Benchmarks of kernel tracing options (ftrace and ktrace)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 4:50 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2010-10-13 at 16:19 -0700, David Sharp wrote:
>> Google uses kernel tracing aggressively in the its data centers. We
>
> Thanks!
>
>> wrote our own kernel tracer, ktrace. However ftrace, perf and LTTng
>> all have a better feature set than ktrace, so we are abandoning that
>> code.
>
> Cool!
>
>>
>> We see several implementations of tracing aimed at the mainline kernel
>> and wanted a fair comparison of each of them to make sure they will
>> not significantly impact performance. A tracing toolkit that is too
>> expensive is not usable in our environment.
>>
>
> [ snip for now (I'm traveling) ]
>
>> This first set of benchmark results compares ftrace to ktrace. The
>> numbers below are the "on" result minus the "off" result for each
>> configuration.
>>
>> ktrace: 200ns  (tracepoint: kernel_getuid)
>> ftrace: 224ns   (tracepoint: timer:sys_getuid)
>> ftrace: 587ns   (tracepoint: syscalls:sys_enter_getuid)
>
>
>> The last result shows that the syscall tracing is about twice as
>> expensive as a normal tracepoint, which is interesting.
>
> Argh, the syscall tracing has a lot of overhead. There is only one
> tracepoint that is hooked into the ptrace code, and will save all
> registers before calling the functions. It enables tracing on all
> syscalls and there's a table that decides whether or not to trace the
> syscall.
>
> So I'm not surprised with the result that the syscall trace point is so
> slow (note, perf uses the same infrastructure).
>
> -- Steve

Steve, Mike told me that you may have some patches to improve overhead
of syscall tracing. I'd be interested in testing them. Can you send
them my way?

Thanks,
d#
