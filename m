Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab1FCOmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:42:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:49217 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab1FCOmF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:42:05 -0400
Subject: Re: [PATCH v1 1/5] perf: add context parameter to perf_event
 overflow handler
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <1305129333-7456-2-git-send-email-avi@redhat.com>
References: <1305129333-7456-1-git-send-email-avi@redhat.com>
	 <1305129333-7456-2-git-send-email-avi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Jun 2011 16:41:55 +0200
Message-ID: <1307112115.2353.3392.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 11:55 -0400, Avi Kivity wrote:
> +++ b/include/linux/perf_event.h
> @@ -709,7 +709,9 @@ struct perf_buffer {
>  
>  struct perf_sample_data;
>  
> -typedef void (*perf_overflow_handler_t)(struct perf_event *, int,
> +typedef void (*perf_overflow_handler_t)(void *context,
> +                                       struct perf_event *event,
> +                                       int,
>                                         struct perf_sample_data *,
>                                         struct pt_regs *regs);
>  
> @@ -855,6 +857,7 @@ struct perf_event {
>         u64                             id;
>  
>         perf_overflow_handler_t         overflow_handler;
> +       void                            *overflow_handler_context;
>  
>  #ifdef CONFIG_EVENT_TRACING
>         struct ftrace_event_call        *tp_event; 

If you're adding a pointer here, then why pass it along in the callback
thing if it already has the perf_event *?

It seems to me the callback can easily do
event->overflow_handler_context if it needs the thing.
