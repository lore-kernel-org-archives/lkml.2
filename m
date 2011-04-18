Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab1DRQ0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:26:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55316 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475Ab1DRQ0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:26:33 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=JTjb3um6TXYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=iu0ztstRCHuiI7ohK2cA:9 a=DXEUTjIy7eY9GSspxkQA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 3/7] lockdep: Annotate read/write states
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110417095507.026186002@chello.nl>
References: <20110417094505.865828233@chello.nl>
	 <20110417095507.026186002@chello.nl>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 18 Apr 2011 12:26:31 -0400
Message-ID: <1303143991.7181.38.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-17 at 11:45 +0200, Peter Zijlstra wrote:

> Currently the read/write status of a lock while it's acquired is denoted by a
> monotonically increasing variable where:
> 
>  0 - WRITE
>  1 - READ
>  2 - RECURSIVE READ
> 
> In this patch, we propose to modify this distinction from a monotonically
> increasing variable to a bit mask where:
> 
>  0x1 - WRITE
>  0x2 - READ
>  0x4 - RECURSIVE READ
> 


>  /*
> @@ -286,6 +287,15 @@ extern void lockdep_init_map(struct lock
>  
>  #define lockdep_set_novalidate_class(lock) \
>  	lockdep_set_class(lock, &__lockdep_no_validate__)
> +
> +/* lock_state bits */
> +#define _W_		0
> +#define _R_		(_W_ + 1)
> +#define _RR_		(_W_ + 2)
> +#define _FIRST_RR_	(_W_ + 3)

Eek!!! Please comment these. I hate trying to figure out what RR means.
If I did not read the change log, my first thought was "Round Robin".

Adding something like:

/*
 * lock_state bits:
 *   WRITE
 *   READ
 *   RECURSIVE_READ
 *   FIRST RECURSIVE_READ
 */

Above that would help tremendously. This code is obfuscated enough, we
need many more comments. (I plan on sending out patches to do this too).



