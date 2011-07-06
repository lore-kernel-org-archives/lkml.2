Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab1GFRio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:38:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42899 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab1GFRin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:38:43 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=mIKt6_09prkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=6rqHouBjAAAA:8 a=ZTJNS6ZiUYxpSe1Ip64A:9 a=R7KnAeaUH18KFrmWJUsA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=TAmEwCHjoHMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH -tip/perf/core] perf, x86: P4 PMU - Drop redundant
 WARN_ON_ONCE
From: Steven Rostedt <rostedt@goodmis.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110706172454.GJ5485@sun>
References: <20110706172454.GJ5485@sun>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 06 Jul 2011 13:38:41 -0400
Message-ID: <1309973921.26417.188.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-06 at 21:24 +0400, Cyrill Gorcunov wrote:
> This WARN_ON_ONCE triggers a false alarm on SMP because
> nmi-watchdog uses a single global 'wd_hw_attr' variable
> to serve perf event attributes and once p4_hw_watchdog_set_attr
> has modified it subsequent calls on the rest cpus trigger
> the warning.
> 
> It is safe to simply drop it since we know the caller may
> pass already altered type and config.
> 
> Repoted-by: Steven Rostedt <rostedt@goodmis.org>

Repoted? Hmm, maybe symbolically I put this code in a different pot.

Reported-and-tested-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  arch/x86/kernel/cpu/perf_event_p4.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -726,9 +726,6 @@ static void p4_hw_watchdog_set_attr(stru
>  	 * that named "non-sleeping" ticks as recommended
>  	 * by Intel SDM Vol3b.
>  	 */
> -	WARN_ON_ONCE(wd_attr->type	!= PERF_TYPE_HARDWARE ||
> -		     wd_attr->config	!= PERF_COUNT_HW_CPU_CYCLES);
> -
>  	wd_attr->type	= PERF_TYPE_RAW;
>  	wd_attr->config	=
>  		p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_EXECUTION_EVENT)		|


