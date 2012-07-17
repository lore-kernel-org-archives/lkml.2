Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab2GQDmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 23:42:05 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35097 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752330Ab2GQDmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 23:42:03 -0400
Message-ID: <1342496521.8377.105.camel@joe2Laptop>
Subject: Re: [PATCH] ftrace: using pr_fmt for better printk output
From: Joe Perches <joe@perches.com>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: rostedt@goodmis.org,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 16 Jul 2012 20:42:01 -0700
In-Reply-To: <CACV3sb+CkmMtBSRe=bp4EcN3xXD+XqBKy+o_-Cr7e6bapYQftw@mail.gmail.com>
References: <CACV3sb+CkmMtBSRe=bp4EcN3xXD+XqBKy+o_-Cr7e6bapYQftw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 09:15 +0800, Jovi Zhang wrote:
> >From fe42b2f29e5968482b3129c71f81a58a0559cf04 Mon Sep 17 00:00:00 2001
[]
> There don't have subsystem name output in front ot ftrace related log entry,
> so use pr_fmt to enable better printk output, for output subsystem name in
> log entry.

Hi Jovi.  A few things:

Your patch has 80 column wrapping issues and doesn't
apply cleanly.

This sort of patch, because it's trivial and not really
important to apply this close to an actual release, should
be done against linux-next not current mainline.

The #define pr_fmt(fmt) should probably use KBUILD_MODNAME.
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Please coalesce formats even though they then may exceed
80 columns and compress multiple lines that fit in 80 too.

> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
[]
> @@ -13,6 +13,8 @@
>   *  Copyright (C) 2004 William Lee Irwin III
>   */
> 
> +#define pr_fmt(fmt) "ftrace: " fmt

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

[]
> @@ -2187,12 +2189,12 @@ static int __init
> ftrace_dyn_table_alloc(unsigned long num_to_init)

wrapped

>  	int cnt;
> 
>  	if (!num_to_init) {
> -		pr_info("ftrace: No functions to be traced?\n");
> +		pr_info("No functions to be traced?\n");
>  		return -1;
>  	}
> 
>  	cnt = num_to_init / ENTRIES_PER_PAGE;
> -	pr_info("ftrace: allocating %ld entries in %d pages\n",
> +	pr_info("allocating %ld entries in %d pages\n",
>  		num_to_init, cnt + 1);

Single line:

	pr_info("allocating %ld entries in %d pages\n", num_to_init, cnt + 1);

> @@ -4495,7 +4497,7 @@ static int start_graph_tracing(void)
>  	if (!ret) {
>  		ret = register_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
>  		if (ret)
> -			pr_info("ftrace_graph: Couldn't activate tracepoint"
> +			pr_info("Couldn't activate tracepoint"
>  				" probe to kernel_sched_switch\n");

Coalesce format:

			pr_info("Couldn't activate tracepoint probe to kernel_sched_switch\n");

etc...

cheers, Joe

