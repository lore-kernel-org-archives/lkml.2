Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab2B1IRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:17:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55555 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600Ab2B1IRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:17:13 -0500
Date: Tue, 28 Feb 2012 09:16:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 5/7] time: Shadow cycle_last in timekeeper structure
Message-ID: <20120228081659.GF21106@elte.hu>
References: <1330388974-27793-1-git-send-email-john.stultz@linaro.org>
 <1330388974-27793-6-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330388974-27793-6-git-send-email-john.stultz@linaro.org>
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

> @@ -184,7 +186,7 @@ static inline s64 timekeeping_get_ns(void)
>  	cycle_now = clock->read(clock);
>  
>  	/* calculate the delta since the last update_wall_time: */
> -	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> +	cycle_delta = (cycle_now - timekeeper.cycle_last) & clock->mask;

Just a general code design observation: the way how the global 
'timekeeper' structure is accessed is rather ugly.

The standard method is to pass it in to timekeeping_get_ns() 
(and other methods) as a parameter, with the highest level 
taking the address via &timekeeping.

That will also make the code shorter and more obvious: the 
familar tk->cycle_last pattern instead of the current mixed uses 
of timekeeping.cycle_last and tk->cycle_last.

There's many similar patterns throughout this code, they need to 
be fixed as well.

Thanks,

	Ingo
