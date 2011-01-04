Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab1ADXy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:54:28 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46392 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab1ADXy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:54:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R0GAU4Kbn7bX2TRaJMGY3m4IXeluCs+8kiGwXQUG2/1Nrx1gONOlpGa2te0rLHtgL6
         tXxS8kuSDm6FEAmOEkCsb/MNjGL3cZ0qYMRtc5h1SJo4nkfY19uNhRH/nyU+s9hfbv09
         O2EdhfOSto/TjgEm+0s3FuSXr5dcUwKfWspA0=
Date: Wed, 5 Jan 2011 00:54:21 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC patch 2/5] trace event skb fix unassigned field
Message-ID: <20110104235418.GD2911@nowhere>
References: <E1PaGZY-0001EI-BD@smtp.tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1PaGZY-0001EI-BD@smtp.tuxdriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 06:46:06PM -0500, nhorman@tuxdriver.com wrote:
> Acked- by: Neil Horman <nhorman@tuxdriver.com>
> 
> 
> Sent from my Verizon Wireless Phone
> 
> ----- Reply message -----
> From: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Date: Tue, Jan 4, 2011 6:16 pm
> Subject: [RFC patch 2/5] trace event skb fix unassigned field
> To: "LKML" <linux-kernel@vger.kernel.org>
> Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Steven Rostedt" <rostedt@goodmis.org>, "Frederic Weisbecker" <fweisbec@gmail.com>, "Ingo Molnar" <mingo@elte.hu>, "Neil Horman" <nhorman@tuxdriver.com>, "Thomas Gleixner" <tglx@linutronix.de>
> 
> 
> The field "protocol" in event kfree_skb is left unassigned if skb is NULL,
> leaving its trace output as garbage. Assign the value to 0 when skb is NULL
> instead.

Hm, if the skb is already null, we probably shouldn't send any trace.

What about using TP_CONDITION() ?

> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Neil Horman <nhorman@tuxdriver.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/trace/events/skb.h |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> Index: linux-2.6-lttng/include/trace/events/skb.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/trace/events/skb.h
> +++ linux-2.6-lttng/include/trace/events/skb.h
> @@ -25,9 +25,7 @@ TRACE_EVENT(kfree_skb,
>  
>  	TP_fast_assign(
>  		__entry->skbaddr = skb;
> -		if (skb) {
> -			__entry->protocol = ntohs(skb->protocol);
> -		}
> +		__entry->protocol = skb ? ntohs(skb->protocol) : 0;
>  		__entry->location = location;
>  	),
>  
> 
> 
