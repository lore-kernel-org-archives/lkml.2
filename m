Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512Ab0HDXal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 19:30:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759492Ab0HDXae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 19:30:34 -0400
Date: Wed, 4 Aug 2010 16:29:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCHv3 13/16] pps: capture MONOTONIC_RAW timestamps as well
Message-Id: <20100804162907.5c4e6345.akpm@linux-foundation.org>
In-Reply-To: <7e78eaffb92829465df0237fa7e4d1b183a1a511.1280952801.git.lasaine@lvk.cs.msu.su>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
	<7e78eaffb92829465df0237fa7e4d1b183a1a511.1280952801.git.lasaine@lvk.cs.msu.su>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Aug 2010 01:06:50 +0400
Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:

> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -286,6 +286,40 @@ void ktime_get_ts(struct timespec *ts)
>  EXPORT_SYMBOL_GPL(ktime_get_ts);
>  
>  /**
> + * getnstime_raw_and_real - Returns both the time of day an raw
> + * monotonic time in a timespec format
> + * @ts_mono_raw:	pointer to the timespec to be set to raw
> + *			monotonic time
> + * @ts_real:		pointer to the timespec to be set to the time
> + *			of day
> + */
> +void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
> +{
> +	unsigned long seq;
> +	s64 nsecs_raw, nsecs_real;
> +
> +	WARN_ON(timekeeping_suspended);

I suspect that if this warning ever triggers, it'll trigger at some
high frequency making a complete mess all over the floor.

WARN_ON_ONCE, perhaps?  Or just remove it?
