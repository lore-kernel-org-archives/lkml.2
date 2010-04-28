Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab0D1Ujo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 16:39:44 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:42005 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752093Ab0D1Ujn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 16:39:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHs22EtGGNqG/2dsb2JhbACceXK+UIUOBA
Date: Wed, 28 Apr 2010 16:39:39 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/10][RFC] tracing: Convert TRACE_EVENT() to use the
	DECLARE_TRACE_DATA()
Message-ID: <20100428203939.GD8591@Krystal>
References: <20100426195024.256424113@goodmis.org> <20100426200241.938003192@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100426200241.938003192@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:38:34 up 21 days,  6:32,  4 users,  load average: 0.50, 0.20,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Switch the TRACE_EVENT() macros to use DECLARE_TRACE_DATA(). This
> patch is done to prove that the DATA macros work. If any regressions
> were to surface, then this patch would help a git bisect to localize
> the area.
> 
> Once again this patch increases the size of the kernel.
> 

As recommended in the earlier email:

It would make sense to just add the extra "callback_data" argument
directly to DECLARE_TRACE(), modify the user (TRACE_EVENT) accordingly.
And possibly create a TRACE_EVENT_NOARG() variant.

Thanks,

Mathieu

>    text	   data	    bss	    dec	    hex	filename
> 5788186	1337252	9351592	16477030	 fb6b66	vmlinux.orig
> 5792282	1333796	9351592	16477670	 fb6de6	vmlinux.class
> 5793448	1333780	9351592	16478820	 fb7264	vmlinux.tracepoint
> 5796926	1337748	9351592	16486266	 fb8f7a	vmlinux.data
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/tracepoint.h |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 4649bdb..c04988a 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -355,14 +355,14 @@ static inline void tracepoint_synchronize_unregister(void)
>  
>  #define DECLARE_EVENT_CLASS(name, proto, args, tstruct, assign, print)
>  #define DEFINE_EVENT(template, name, proto, args)		\
> -	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
> +	DECLARE_TRACE_DATA(name, PARAMS(proto), PARAMS(args))
>  #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
> -	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
> +	DECLARE_TRACE_DATA(name, PARAMS(proto), PARAMS(args))
>  
>  #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
> -	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
> +	DECLARE_TRACE_DATA(name, PARAMS(proto), PARAMS(args))
>  #define TRACE_EVENT_FN(name, proto, args, struct,		\
>  		assign, print, reg, unreg)			\
> -	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
> +	DECLARE_TRACE_DATA(name, PARAMS(proto), PARAMS(args))
>  
>  #endif /* ifdef TRACE_EVENT (see note above) */
> -- 
> 1.7.0
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
