Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab0JPNMZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 09:12:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54535 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571Ab0JPNMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 09:12:24 -0400
Date: Sat, 16 Oct 2010 15:11:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] kernel: trace: trace_kprobe.c: removed duplicated
 #include
Message-ID: <20101016131154.GC8751@elte.hu>
References: <1287170842-20279-1-git-send-email-andrea.gelmini@gelma.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287170842-20279-1-git-send-email-andrea.gelmini@gelma.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0074]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrea Gelmini <andrea.gelmini@gelma.net> wrote:

> Removed linux/uaccess.h
> 
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> ---
>  kernel/trace/trace_kprobe.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 544301d..c5fb747 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -18,7 +18,6 @@
>   */
>  
>  #include <linux/module.h>
> -#include <linux/uaccess.h>
>  #include <linux/kprobes.h>
>  #include <linux/seq_file.h>
>  #include <linux/slab.h>
> @@ -479,7 +478,7 @@ struct probe_arg {
>  struct trace_probe {
>  	struct list_head	list;
>  	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
> -	unsigned long 		nhit;
> +	unsigned long		nhit;
>  	unsigned int		flags;	/* For TP_FLAG_* */
>  	const char		*symbol;	/* symbol name */
>  	struct ftrace_event_class	class;

If you look at the actual code there's also other problems with the 
vertical spacing of this and other structures (fetch_param, fetch_type, 
trace_kprobe, etc.) defined here. Would be nice if you could check the 
whole file and fix those too.

Thanks,

	Ingo
