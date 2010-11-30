Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab0K3Sdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 13:33:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab0K3Sdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 13:33:43 -0500
Date: Tue, 30 Nov 2010 16:33:25 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch 2/9] perf: Use appropriate pointer type instead of
	silly typecasting
Message-ID: <20101130183325.GB11102@ghostprotocols.net>
References: <20101130163735.217366493@linutronix.de> <20101130163819.969462809@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130163819.969462809@linutronix.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 30, 2010 at 05:49:35PM -0000, Thomas Gleixner escreveu:
> There is no reason to use a struct sample_event pointer in struct sample_queue
> and type cast it when flushing the queue.
 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

I touched that code in a branch I'm working on, same change :-\ Well,
testing the other patches, thanks!

- Arnaldo

>  tools/perf/util/session.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6-tip/tools/perf/util/session.c
> ===================================================================
> --- linux-2.6-tip.orig/tools/perf/util/session.c
> +++ linux-2.6-tip/tools/perf/util/session.c
> @@ -386,7 +386,7 @@ static event__swap_op event__swap_ops[] 
>  
>  struct sample_queue {
>  	u64			timestamp;
> -	struct sample_event	*event;
> +	event_t			*event;
>  	struct list_head	list;
>  };
>  
> @@ -406,7 +406,7 @@ static void flush_sample_queue(struct pe
>  		if (iter->timestamp > limit)
>  			break;
>  
> -		ops->sample((event_t *)iter->event, s);
> +		ops->sample(iter->event, s);
>  
>  		os->last_flush = iter->timestamp;
>  		list_del(&iter->list);
> 
