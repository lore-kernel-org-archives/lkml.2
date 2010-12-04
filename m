Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab0LDB4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 20:56:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34284 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab0LDB4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 20:56:12 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=_hCqAiHmeU0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=-8SMyCfHepKH0bHMcHIA:9 a=iHgAtDRt5Ced4STlB5oA:7 a=UXracc2vinYdeOx-eFQneFL-lg4A:4 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 13/15] small_traces: Add config option to shrink trace
 events.
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1291421609-14665-14-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
	 <1291421609-14665-14-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 03 Dec 2010 20:56:10 -0500
Message-ID: <1291427770.16223.15.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Frederic on Cc ]

I rather have this as a run time option than a compile time.

You could use two different trace event structures. The normal one and a
"compact" one. Add to the "trace_options" and when it is set the traces
are compact.

-- Steve


On Fri, 2010-12-03 at 16:13 -0800, David Sharp wrote:
> This option will remove several fields from trace events to reduce the
> payload size. Under heavy load, events can be produced faster than they
> can possibly be written to disk or sent on the network. Shrinking the
> payload size will enable fitting more traces in the ring buffer, which
> therefore enables tracing for longer periods, at the cost of losing some
> relatively unimportant details.
> 
> Google-Bug-Id: 3224547
> 
> Signed-off-by: David Sharp <dhsharp@google.com>
> ---
>  kernel/trace/Kconfig |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index ea37e2f..9c24fe5 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -403,6 +403,18 @@ config FUNCTION_PROFILER
>  
>  	  If in doubt, say N.
>  
> +config SMALL_TRACES
> +	bool "Shrink trace events"
> +	default n
> +	help
> +	  Minimize the size of trace events. Omits fields from trace event
> +	  header like preempt_count, and lock_depth. Chooses smaller
> +	  alternative event structures. Shrinking the payload size enables
> +	  fitting more traces in the ring buffer, which enables tracing for
> +	  longer periods when the buffer can not be read as fast as it is
> +	  filled, at the cost of losing some details.
> +
> +
>  config FTRACE_MCOUNT_RECORD
>  	def_bool y
>  	depends on DYNAMIC_FTRACE


