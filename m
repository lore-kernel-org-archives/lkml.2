Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab1AYQvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 11:51:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:43582 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab1AYQvW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 11:51:22 -0500
Subject: Re: [PATCH 01/18] move do_timer() from kernel/timer.c into
 kernel/time/timekeeping.c
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>, Torben Hohn <torbenh@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>, hch@infradead.org,
        yong.zhang0@gmail.com
In-Reply-To: <1295951677.28776.489.camel@laptop>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
	 <1295651224-29823-2-git-send-email-torbenh@gmx.de>
	 <1295901169.4845.29.camel@work-vm>
	 <alpine.LFD.2.00.1101242254420.31804@localhost6.localdomain6>
	 <1295907672.2274.44.camel@twins>
	 <alpine.LFD.2.00.1101242344090.31804@localhost6.localdomain6>
	 <1295946514.28776.476.camel@laptop>  <1295951677.28776.489.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 Jan 2011 17:51:59 +0100
Message-ID: <1295974319.28776.1070.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 11:34 +0100, Peter Zijlstra wrote:

> Something like the (completely untested) below would do I guess:

> @@ -8172,6 +8180,8 @@ void __init sched_init(void)
>  	init_idle(current, smp_processor_id());
>  
>  	calc_load_update = jiffies + LOAD_FREQ;
> +	global_load_timer.slack = 0;
> +	mod_timer(&global_load_timer, calc_load_update + 10);
>  
>  	/*
>  	 * During early bootup we pretend to be a normal task:

OK, so calling mod_timer() before init_timers() is _not_ a good idea ;-)
