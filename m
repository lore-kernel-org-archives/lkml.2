Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab0JOOiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:38:52 -0400
Received: from canuck.infradead.org ([134.117.69.58]:49832 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab0JOOiv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:38:51 -0400
Subject: Re: [PATCH 5/8] x86: Add IRQ_TIME_ACCOUNTING in x86 -v4
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <1286237003-12406-6-git-send-email-venki@google.com>
References: <1286237003-12406-1-git-send-email-venki@google.com>
	 <1286237003-12406-6-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 16:38:31 +0200
Message-ID: <1287153511.29097.1522.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-04 at 17:03 -0700, Venkatesh Pallipadi wrote:
> @@ -801,6 +805,7 @@ void mark_tsc_unstable(char *reason)
>         if (!tsc_unstable) {
>                 tsc_unstable = 1;
>                 sched_clock_stable = 0;
> +               disable_sched_clock_irqtime();
>                 printk(KERN_INFO "Marking TSC unstable due to %s\n", reason);
>                 /* Change only the rating, when not registered */
>                 if (clocksource_tsc.mult) 

I think we can be less strict that this and keep it enabled for
everything with constant tsc and nonstop tsc.

Since we're using it strictly per-cpu the cross-cpu sync isn't really
important, all we need it to know the per-cpu value doesn't go all
screwy on us.


