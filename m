Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935125Ab0GPAsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 20:48:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62176 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935075Ab0GPAsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 20:48:12 -0400
Message-ID: <4C3FAD44.1050900@cn.fujitsu.com>
Date: Fri, 16 Jul 2010 08:52:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Soeren Sandmann <sandmann@daimi.au.dk>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 2/2] tracing: Remove special traces
References: <1279237003-31354-1-git-send-regression-fweisbec@gmail.com> <1279237003-31354-3-git-send-regression-fweisbec@gmail.com>
In-Reply-To: <1279237003-31354-3-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 2114b4c..2f8619b 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -22,7 +22,6 @@ enum trace_type {
>  	TRACE_STACK,
>  	TRACE_PRINT,
>  	TRACE_BPRINT,
> -	TRACE_SPECIAL,
>  	TRACE_MMIO_RW,
>  	TRACE_MMIO_MAP,
>  	TRACE_BRANCH,
> @@ -332,11 +331,6 @@ void tracing_sched_wakeup_trace(struct trace_array *tr,
>  				struct task_struct *wakee,
>  				struct task_struct *cur,
>  				unsigned long flags, int pc);
> -void trace_special(struct trace_array *tr,
> -		   struct trace_array_cpu *data,
> -		   unsigned long arg1,
> -		   unsigned long arg2,
> -		   unsigned long arg3, int pc);
>  void trace_function(struct trace_array *tr,
>  		    unsigned long ip,
>  		    unsigned long parent_ip,

You forgot to delete this:

                IF_ASSIGN(var, ent, struct special_entry, 0);           \
