Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab1AZS0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:26:46 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59481 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab1AZS0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:26:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bMFCAXYX1IMb2sWll0YCE5XHCo4WYiAUjZOX7Ypu+LmQsEbs0TOUMLXOvg+MhfkAQ9
         C5ikSS6KnjzK8mwZbAem0I4iegQ8U2+desua1+FzbB86AArkAn1VVQ5W5DwwoFs9TBci
         G01Di7NWG2y482ZbI70okrvvcLXQXhd1BG39s=
Date: Wed, 26 Jan 2011 18:19:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] compile time initialization for event flags value
Message-ID: <20110126171939.GC1757@nowhere>
References: <4D3FDFFC.6030304@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3FDFFC.6030304@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 04:49:00PM +0800, Lai Jiangshan wrote:
> compile time initialization is better than runtime initialization.
> 
> impact: remove many early_initcall()s and many trace_init_flags_##name()s.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 18cd068..ff074c8 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -135,8 +135,8 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>  		.class			= &event_class_syscall_enter,	\
>  		.event.funcs            = &enter_syscall_print_funcs,	\
>  		.data			= (void *)&__syscall_meta_##sname,\
> -	};								\
> -	__TRACE_EVENT_FLAGS(enter_##sname, TRACE_EVENT_FL_CAP_ANY)
> +		.flags			= TRACE_EVENT_FL_CAP_ANY,	\
> +	};
>  
>  #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
>  	static struct syscall_metadata					\
> @@ -149,8 +149,8 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>  		.class			= &event_class_syscall_exit,	\
>  		.event.funcs		= &exit_syscall_print_funcs,	\
>  		.data			= (void *)&__syscall_meta_##sname,\
> -	};								\
> -	__TRACE_EVENT_FLAGS(exit_##sname, TRACE_EVENT_FL_CAP_ANY)
> +		.flags			= TRACE_EVENT_FL_CAP_ANY,	\
> +	};
>  
>  #define SYSCALL_METADATA(sname, nb)				\
>  	SYSCALL_TRACE_ENTER_EVENT(sname);			\

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
