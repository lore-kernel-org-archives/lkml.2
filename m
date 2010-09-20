Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab0ITRih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 13:38:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:33673 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab0ITRih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 13:38:37 -0400
Subject: Re: [PATCH 4/6] sched: Do not account irq time to current task
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>
In-Reply-To: <AANLkTimgQf=SO0rRotuzNsvN9xYrc2jJ5eDVZb2FxJRK@mail.gmail.com>
References: <1284688596-6731-1-git-send-email-venki@google.com>
	 <1284688596-6731-5-git-send-email-venki@google.com>
	 <1284895730.2275.625.camel@laptop>
	 <AANLkTimgQf=SO0rRotuzNsvN9xYrc2jJ5eDVZb2FxJRK@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Sep 2010 19:38:26 +0200
Message-ID: <1285004306.2275.764.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-20 at 10:33 -0700, Venkatesh Pallipadi wrote:
> Yes. I like your idea of having separate rq->clock and rq->clock_task.
> That will clean up this code a bit.
> We will still need to keep track of "last accounted irq time" at the
> task or rq level to account sched_rt_avg_update correctly. But, I dont
> have to play with cfs_rq and rt_rq as in this patch though. 

Ah, indeed. Ok so have rq->clock, rq->clock_task and have a
irq_time_stamp to fold stuff into sched_rt_avg_update(), then I think
you can isolate all the clock bits to update_rq_clock() and then use
->clock_task in update_curr{,_rt}().


