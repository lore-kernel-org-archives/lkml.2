Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761339Ab2EIXvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:51:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11097 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759116Ab2EIXu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:50:57 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=AzP6bWsyHLsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=n8i27M1mAAAA:8 a=20ZDprn7YYlbl7U8IH8A:9 a=PUjeQqilurYA:10 a=rXZLD9m7qZoA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336607454.14207.221.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] trace: power: add trace_clock_set_parent
From: Steven Rostedt <rostedt@goodmis.org>
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jesper Juhl <jj@chaosbits.net>,
        Jiri Kosina <jkosina@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>
Date: Wed, 09 May 2012 19:50:54 -0400
In-Reply-To: <1336605692-14509-1-git-send-email-ccross@android.com>
References: <1336605692-14509-1-git-send-email-ccross@android.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 16:21 -0700, Colin Cross wrote:
> Adds a new trace event to be called from clk_set_parent.  Some
> cpufreq drivers, including Tegra, reparent the cpu clock to a
> slower clock while the main pll is relocking, tracing
> clk_set_parent allows traces to show how for long the cpu is
> running slower.
> 
> Uses a separate TRACE_EVENT instead of the clock event class to
> allow the event to contain string names for the child and the
> parent.
> 
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  include/trace/events/power.h |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/include/trace/events/power.h b/include/trace/events/power.h
> index cae9a94..2b81df6 100644
> --- a/include/trace/events/power.h
> +++ b/include/trace/events/power.h
> @@ -204,6 +204,25 @@ enum {
>  	TP_ARGS(name, state, cpu_id)
>  );
>  
> +TRACE_EVENT(clock_set_parent,
> +
> +	TP_PROTO(const char *name, const char *parent_name),
> +
> +	TP_ARGS(name, parent_name),
> +
> +	TP_STRUCT__entry(
> +		__string(       name,           name            )
> +		__string(       parent_name,    parent_name     )
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(name, name);
> +		__assign_str(name, parent_name);

Don't you mean: __assign_str(parent_name, parent_name); ?

-- Steve

> +	),
> +
> +	TP_printk("%s parent=%s", __get_str(name), __get_str(parent_name))
> +);
> +
>  /*
>   * The power domain events are used for power domains transitions
>   */


