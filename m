Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab1BPOMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 09:12:06 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:56269 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755322Ab1BPOMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 09:12:03 -0500
X-Sasl-enc: IK5oYeDa+2JCqfGcAeXf0hBUU/rqe3rraF1CjgDIPEE/ 1297865522
Message-ID: <4D5BDB31.4090304@fastmail.fm>
Date: Wed, 16 Feb 2011 14:12:01 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>,
        =?UTF-8?B?QXJ2ZSBIasODwrhubmV2w4PCpWc=?= <arve@android.com>
Subject: Re: [PATCH 3/5] time: Extend get_xtime_and_monotonic_offset() to
 also return sleep
References: <1297830007-426-1-git-send-email-john.stultz@linaro.org> <1297830007-426-4-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1297830007-426-4-git-send-email-john.stultz@linaro.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/02/2011 04:20, John Stultz wrote:
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 5fbd9aa..29f75aa 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -1043,8 +1043,10 @@ void do_timer(unsigned long ticks)
>   * get_xtime_and_monotonic_offset() - get xtime and wall_to_monotonic

Can you update the function name in the comment as well.

>   * @xtim:	pointer to timespec to be set with xtime
>   * @wtom:	pointer to timespec to be set with wall_to_monotonic
> + * @sleep:	pointer to timespec to be set with time in suspend
>   */
> -void get_xtime_and_monotonic_offset(struct timespec *xtim, struct timespec *wtom)
> +void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
> +				struct timespec *wtom, struct timespec *sleep)
>  {
>  	unsigned long seq;
>  
> @@ -1052,6 +1054,7 @@ void get_xtime_and_monotonic_offset(struct timespec *xtim, struct timespec *wtom
>  		seq = read_seqbegin(&xtime_lock);
>  		*xtim = xtime;
>  		*wtom = wall_to_monotonic;
> +		*sleep = total_sleep_time;
>  	} while (read_seqretry(&xtime_lock, seq));
>  }
>  

Thanks,

Jack
