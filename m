Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab2CWO2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 10:28:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33700 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab2CWO2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 10:28:18 -0400
X-Authority-Analysis: v=2.0 cv=Z8Fu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=hkKkbzRNYrQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Nl0ru5l6gPP0KfZKCS0A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332512896.23924.66.camel@gandalf.stny.rr.com>
Subject: Re: Not able to use HIGH_RES_TIMERS on ARM
From: Steven Rostedt <rostedt@goodmis.org>
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Date: Fri, 23 Mar 2012 10:28:16 -0400
In-Reply-To: <CAB4K4y4DvUb+908P4NJoyJbDa35R2jP5cHqnoNWr9HRZJYyj4w@mail.gmail.com>
References: <CAB4K4y7ticNGWv1XWtqLatBG69yM2gv31ayt5DqWSSOUWTZrGg@mail.gmail.com>
	 <20120319130445.GN15988@n2100.arm.linux.org.uk>
	 <CAB4K4y4Sw4dyT7vX_YzgbYBK42LZuS96=6X3MtVdN-mBqOKr-Q@mail.gmail.com>
	 <20120319132623.GO15988@n2100.arm.linux.org.uk>
	 <4F696011.7080409@linaro.org>
	 <CAB4K4y5ZkGY3pe3ty5fbaVTj626dAS3HuodX6HfDvym8g0qyZQ@mail.gmail.com>
	 <CAB4K4y5phDP=4Ab1S2XwS+Oa25B5Pxe3p5D2ZO3G=2W=cMKm=w@mail.gmail.com>
	 <20120322100236.GS15988@n2100.arm.linux.org.uk>
	 <CAB4K4y5rOFbPm1XjeHxUFtc29tFAQ1besKLy5fz4MHq6UV0fdA@mail.gmail.com>
	 <4F6BECA7.7030007@linaro.org>
	 <CAB4K4y4DvUb+908P4NJoyJbDa35R2jP5cHqnoNWr9HRZJYyj4w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-23 at 14:40 +0530, Ajeet Yadav wrote:

> linux-3.0.20/kernel/trace/Kconfig
> linux-3.0.20-dirty/kernel/trace/Kconfig
> --- linux-3.0.20/kernel/trace/Kconfig   2012-02-06 23:01:45.000000000 +0530
> +++ linux-3.0.20-dirty/kernel/trace/Kconfig     2012-03-19
> 18:21:41.000000000 +0530
> @@ -173,7 +173,6 @@ config IRQSOFF_TRACER
>        bool "Interrupts-off Latency Tracer"
>        default n
>        depends on TRACE_IRQFLAGS_SUPPORT
> -       depends on !ARCH_USES_GETTIMEOFFSET
>        select TRACE_IRQFLAGS
>        select GENERIC_TRACER
>        select TRACER_MAX_TRACE
> @@ -195,7 +194,6 @@ config IRQSOFF_TRACER
>  config PREEMPT_TRACER
>        bool "Preemption-off Latency Tracer"
>        default n
> -       depends on !ARCH_USES_GETTIMEOFFSET
>        depends on PREEMPT
>        select GENERIC_TRACER
>        select TRACER_MAX_TRACE

A little history here.

When I converted the irqsoff/preemptoff latency tracers from the
original -rt patch (written by Ingo), these options originally had
"depends on GENERIC_TIME". I just checked, and this goes at least back
to 2.6.22.1-rt9 (long before ftrace).

When I ported these to ftrace, I kept the dependencies. They probably
are not needed and are only there for historical reasons.

If this patch works fine for you, and that you are my only test case for
this patch. I'd just say:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


