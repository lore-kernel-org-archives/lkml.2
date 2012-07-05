Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2GEI3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 04:29:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:52004 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab2GEI3N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 04:29:13 -0400
Message-ID: <1341476945.7709.1.camel@twins>
Subject: Re: [PATCH -rt] perf: make swevent hrtimer run in irq instead of
 softirq
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Thu, 05 Jul 2012 10:29:05 +0200
In-Reply-To: <1341476476-5666-1-git-send-email-yong.zhang0@gmail.com>
References: <1341476476-5666-1-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 16:21 +0800, Yong Zhang wrote:
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index fd126f8..451d452 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5403,6 +5403,7 @@ static void perf_swevent_init_hrtimer(struct perf_event *event)
>  
>         hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>         hwc->hrtimer.function = perf_swevent_hrtimer;
> +       hwc->hrtimer.irqsafe = 1;
>  
>         /*
>          * Since hrtimers have a fixed rate, we can do a static freq->period 

Yes this is correct.. curious we lost that. I'm sure I've done this
before.
