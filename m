Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab1CIAXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:23:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55636 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab1CIAXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:23:14 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=_hCqAiHmeU0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=x3E1kkhSYPxLioQU5EoA:9 a=9mNfTuyRNuQDEJZNQO4A:7 a=0FTZyzEvq42p2r-ZTPl90HNZSagA:4 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
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
Date: Tue, 08 Mar 2011 19:23:13 -0500
Message-ID: <1299630193.20306.112.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-03 at 16:13 -0800, David Sharp wrote:
> This option will remove several fields from trace events to reduce the
> payload size. Under heavy load, events can be produced faster than they
> can possibly be written to disk or sent on the network. Shrinking the
> payload size will enable fitting more traces in the ring buffer, which
> therefore enables tracing for longer periods, at the cost of losing some
> relatively unimportant details.
> 

OK, I'm trying to get all your patches in for 2.6.39 except the last 3.
As this may break user interfaces. I would like a way to dynamically
shrink the payload, but we need to figure out how to do that.

For example, currently trace-cmd looks at the event files know what data
to record. Sure we could force it with a config option, but that is not
a good solution for mainline. What we would want is something more
dymanic. But then tools like trace-cmd, and I suspect perf will need to
have a way to know how to parse the data. Especially perf which is user
specific (where as trace-cmd is global). The change in events needs to
be atomic per user. So one user changing what gets recorded in an event
does not affect another user.

Perhaps in the future we can figure something out. But for now, patches
1-12 look good (with the exception of patch 3).

-- Steve


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


