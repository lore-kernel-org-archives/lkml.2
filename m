Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab2B1IJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:09:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53932 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600Ab2B1IJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:09:05 -0500
Date: Tue, 28 Feb 2012 09:08:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 3/7] time: Split timekeeper lock into separate
 reader/writer locks
Message-ID: <20120228080851.GD21106@elte.hu>
References: <1330388974-27793-1-git-send-email-john.stultz@linaro.org>
 <1330388974-27793-4-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330388974-27793-4-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -71,8 +71,9 @@ struct timekeeper {
>  	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
>  	struct timespec raw_time;
>  
> -	/* Seqlock for all timekeeper values */
> -	seqlock_t lock;
> +	/* locks for timekeeper structure */
> +	seqcount_t rlock;   /* This seqcount serializes readers from updates */
> +	spinlock_t wlock;	/* This spinlock serializes updaters */

Vertical spacing broken again - not just of the fields but of 
the comments as well.

> @@ -576,11 +583,11 @@ u64 timekeeping_max_deferment(void)
>  	unsigned long seq;
>  	u64 ret;
>  	do {

sigh.

Thanks,

	Ingo
