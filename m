Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab0IWAen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 20:34:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62457 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab0IWAem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 20:34:42 -0400
X-Authority-Analysis: v=1.1 cv=GglhOq9PVtWDmzXFaQc2b9ix+3dKCE90LyQFAZ1FxMQ= c=1 sm=0 a=0cKYrd99z0gA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=tHz9FfFoAAAA:8 a=r6-SKtqzC2bJfbI9CGQA:9 a=TQpnoB7An9eLTNgw6FTIMbKG2SYA:4 a=PUjeQqilurYA:10 a=6O0IECtVFhoA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] x86: don't use mcount in pvclock.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>
In-Reply-To: <4C9A9A3F.4040201@goop.org>
References: <4C9A9A3F.4040201@goop.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 22 Sep 2010 20:34:39 -0400
Message-ID: <1285202079.26872.424.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Crap!

I fixed this back on 7/1/2010 from a RHEL bugzilla report, and forgot to
push it mainline. This also requires kvmclock.o to have the -pg as well.

I'll add your patch and add the kvmclock.o too.

Thanks,

-- Steve


On Wed, 2010-09-22 at 17:07 -0700, Jeremy Fitzhardinge wrote:
> 
> When using a paravirt clock, pvclock.c can be used by sched_clock(),
> which in turn is used by the tracing mechanism for timestamps,
> which leads to infinite recursion.
> 
> Disable mcount/tracing for pvclock.o.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index f3477bb..35b447c 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -11,6 +11,7 @@ ifdef CONFIG_FUNCTION_TRACER
>  CFLAGS_REMOVE_tsc.o = -pg
>  CFLAGS_REMOVE_rtc.o = -pg
>  CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
> +CFLAGS_REMOVE_pvclock.o = -pg
>  CFLAGS_REMOVE_ftrace.o = -pg
>  CFLAGS_REMOVE_early_printk.o = -pg
>  endif
> 


