Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0EGISq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:18:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54100 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753018Ab0EGISo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:18:44 -0400
Message-ID: <4BE3CD51.4050406@cn.fujitsu.com>
Date: Fri, 07 May 2010 16:20:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/9 - v2][RFC] tracing: Remove per event trace registering
References: <20100504034045.085822814@goodmis.org> <20100504034202.282030521@goodmis.org>
In-Reply-To: <20100504034202.282030521@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -935,11 +947,11 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
>  		return -1;
>  	}
>  
> -	if (call->regfunc)
> +	if (call->class->probe || call->class->reg)
>  		trace_create_file("enable", 0644, call->dir, call,
>  				  enable);
>  
> -	if (call->id && call->perf_event_enable)
> +	if (call->id && (call->class->perf_probe || call->class->reg))
>  		trace_create_file("id", 0444, call->dir, call,
>  		 		  id);
>  

Accessing of ->perf_probe needs to be guarded with CONFIG_PERF_EVENTS,
otherwise it won't pass compile.

The original code is fine, because ->perf_event_enable is always there
regardless of CONFIG_PERF_EVENTS.
