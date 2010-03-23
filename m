Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab0CWCCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 22:02:05 -0400
Received: from www.tglx.de ([62.245.132.106]:44352 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074Ab0CWCCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 22:02:03 -0400
Date: Tue, 23 Mar 2010 03:01:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kara <jack@suse.cz>
cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 12/18] timer: Provide config option for enabling timer
 tracepoints
In-Reply-To: <1269304340-25372-13-git-send-email-jack@suse.cz>
Message-ID: <alpine.LFD.2.00.1003230300480.3147@localhost.localdomain>
References: <1269304340-25372-1-git-send-email-jack@suse.cz> <1269304340-25372-13-git-send-email-jack@suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Mar 2010, Jan Kara wrote:

> CC: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

Steven, can you pick that up please ?

> ---
>  include/trace/events/timer.h |    2 ++
>  kernel/trace/Kconfig         |    9 +++++++++
>  2 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
> index 9496b96..2737598 100644
> --- a/include/trace/events/timer.h
> +++ b/include/trace/events/timer.h
> @@ -1,5 +1,7 @@
>  #undef TRACE_SYSTEM
> +#undef TRACE_CONFIG
>  #define TRACE_SYSTEM timer
> +#define TRACE_CONFIG CONFIG_TIMER_TRACER
>  
>  #if !defined(_TRACE_TIMER_H) || defined(TRACE_HEADER_MULTI_READ)
>  #define _TRACE_TIMER_H
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index a9d7e33..787f52e 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -421,6 +421,15 @@ config MODULE_TRACER
>  
>  	  If unsure, say N
>  
> +config TIMER_TRACER
> +	bool "Trace timer actions"
> +	select GENERIC_TRACER
> +	help
> +	  Provide trace points for timer initialization, starting, expiring,
> +	  and canceling.
> +
> +	  If unsure, say N
> +
>  config WORKQUEUE_TRACER
>  	bool "Trace workqueues"
>  	select GENERIC_TRACER
> -- 
> 1.6.4.2
> 
