Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288Ab0EEAdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 20:33:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55628 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab0EEAdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 20:33:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YmGHWxAg8v4R2WVCZ+pbtP7S7vUliaZOpJwJ+AhJR4oH4IYsIR4EU2PwlSKSrnrYC7
         vToXgrUU52dq8tdL7ItG+N2FHzG8vdnW57Dk8kph6BAGUQawqXMEoPOHQGwdeO/1WERj
         NjYRTmNISZY04HbfeL1Nbxw9DjDd5LtGFrYXM=
Message-ID: <4BE0BCC3.1090101@lwfinger.net>
Date: Tue, 04 May 2010 19:33:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.11 Thunderbird/3.0.4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: How to write marker info in MMIO trace from kernel
References: <4BE06933.9080202@lwfinger.net>	 <1272998579.9739.235.camel@gandalf.stny.rr.com>	 <4BE09F42.9070909@lwfinger.net> <1273013889.22438.8.camel@gandalf.stny.rr.com>
In-Reply-To: <1273013889.22438.8.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2010 05:58 PM, Steven Rostedt wrote:
> On Tue, 2010-05-04 at 17:27 -0500, Larry Finger wrote:
> 
>> Thanks for the info. One other question - when I write only mmiotrace to
>> the current_tracer, the trace_printk() stuff does not end up in the
>> buffer. I can get it by using the "sysprof" tracer, but that has a lot
>> of stuff I do not want. Did I miss some configuration? My list of
>> available tracers is "blk kmemtrace mmiotrace wakeup_rt wakeup function
>> sysprof sched_switch nop".
> 
> Ug, that's because the mmiotrace handles its own prints and ignores
> anything it does not know about. Here, try this patch:
> 
> -- Steve
> 
> diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
> index 017fa37..8652f28 100644
> --- a/kernel/trace/trace_mmiotrace.c
> +++ b/kernel/trace/trace_mmiotrace.c
> @@ -282,7 +282,7 @@ static enum print_line_t mmio_print_line(struct trace_iterator *iter)
>  	case TRACE_PRINT:
>  		return mmio_print_mark(iter);
>  	default:
> -		return TRACE_TYPE_HANDLED; /* ignore unknown entries */
> +		return TRACE_TYPE_UNHANDLED;
>  	}
>  }

That did the trick.

Thanks a lot,

Larry
