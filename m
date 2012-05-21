Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447Ab2EUSBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:01:20 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34986 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758174Ab2EUSBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:01:10 -0400
Message-ID: <4FBA82DF.9060009@linaro.org>
Date: Mon, 21 May 2012 11:01:03 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V2 4/6] time: introduce leap second functional interface
References: <cover.1337348892.git.richardcochran@gmail.com> <eee0b50afdea829c727d6210afb8299a4cf30981.1337348892.git.richardcochran@gmail.com>
In-Reply-To: <eee0b50afdea829c727d6210afb8299a4cf30981.1337348892.git.richardcochran@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052118-1780-0000-0000-000005C32EEB
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000276; HX=3.00000188; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00141158; UDB=6.00032625; UTC=2012-05-21
 18:01:08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 07:09 AM, Richard Cochran wrote:
> This patch adds a new private leap second interface for use by the NTP
> code. In addition to methods for starting and ending leap seconds, the
> interface provides a way to get the correct UTC time of day even during
> a leap second.
>
> Signed-off-by: Richard Cochran<richardcochran@gmail.com>
> ---
>   kernel/time/leap-seconds.h |   21 +++++++
>   kernel/time/timekeeping.c  |  129 ++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 150 insertions(+), 0 deletions(-)
>   create mode 100644 kernel/time/leap-seconds.h
>
> diff --git a/kernel/time/leap-seconds.h b/kernel/time/leap-seconds.h
> new file mode 100644
> index 0000000..3dea7b0
> --- /dev/null
> +++ b/kernel/time/leap-seconds.h
> @@ -0,0 +1,21 @@
> +/*
> + * linux/kernel/time/leap-seconds.h
> + *
> + * Functional interface to the timekeeper code,
> + * for use by the NTP code.
> + *
> + */
> +#ifndef __LINUX_KERNEL_TIME_LEAP_SECONDS_H
> +#define __LINUX_KERNEL_TIME_LEAP_SECONDS_H
> +
> +#include<linux/time.h>
> +
> +int timekeeping_gettod_status(struct timespec *ts, time_t *offset);
> +
> +void timekeeping_delete_leap_second(void);
> +
> +void timekeeping_finish_leap_second(void);
> +
> +void timekeeping_insert_leap_second(void);
> +
> +#endif

Why not just add these to time.h?

thanks
-john

