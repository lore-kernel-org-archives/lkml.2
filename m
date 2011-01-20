Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab1ATQLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 11:11:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51284 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab1ATQLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:11:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uISS0xmG/zPTWAi+D8zSAOkFBx5xoBe4dh3g0XUowo9+SAq4D0GHkMj86GBf4EqY+E
         31tpGEW4PGyndfQA4P8xFvyd7Cd6EljEx42omilN1g8ozGueJaGPVFxGt05sVW6UV5tq
         lsIegzX1NgKwUOpmXpk4prlEPceKEM7Nn24Ms=
Date: Thu, 20 Jan 2011 17:11:06 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        rostedt@goodmis.org, amit.kucheria@linaro.org
Subject: Re: [PATCH V2] tracing, perf : add cpu hotplug trace events
Message-ID: <20110120161101.GA17218@nowhere>
References: <AANLkTinNoYbDe5huY4_Q6YidbWxqXqVWbVP2_7o-=P3W@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinNoYbDe5huY4_Q6YidbWxqXqVWbVP2_7o-=P3W@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 09:25:54AM +0100, Vincent Guittot wrote:
> Please find below a new proposal for adding trace events for cpu hotplug.
> The goal is to measure the latency of each part (kernel, architecture)
> and also to trace the cpu hotplug activity with other power events. I
> have tested these traces events on an arm platform.
> 
> Changes since previous version:
> -Use cpu_hotplug for trace name
> -Define traces for kernel core and arch parts only
> -Use DECLARE_EVENT_CLASS and DEFINE_EVENT
> -Use proper indentation
> 
> Subject: [PATCH] cpu hotplug tracepoint
> 
> this patch adds new events for cpu hotplug tracing
>  * plug/unplug sequence
>  * core and architecture latency measurements
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.com>
> ---
>  include/trace/events/cpu_hotplug.h |  117 ++++++++++++++++++++++++++++++++++++

Note we can't apply new tracepoints if they are not inserted in the code.

> +DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_wait_die_start,
> +
> +	TP_PROTO(unsigned int cpuid),
> +
> +	TP_ARGS(cpuid)
> +);
> +
> +DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_wait_die_end,
> +
> +	TP_PROTO(unsigned int cpuid),
> +
> +	TP_ARGS(cpuid)
> +);

What is wait die, compared to die for example?

We need those tracepoints to be applied to get that reviewable in practice.

Thanks.
