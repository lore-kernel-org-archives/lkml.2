Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab2ECSy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 14:54:57 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57055 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab2ECSyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 14:54:55 -0400
Message-ID: <4FA2D46C.2040404@linaro.org>
Date: Thu, 03 May 2012 11:54:36 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] ntp: advertise correct TAI offset during leap second
References: <cover.1335442155.git.richardcochran@gmail.com> <7af92d6eabef55ddce07007ea515eda2e1474c52.1335442155.git.richardcochran@gmail.com>
In-Reply-To: <7af92d6eabef55ddce07007ea515eda2e1474c52.1335442155.git.richardcochran@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050318-2398-0000-0000-000006550D90
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 05:11 AM, Richard Cochran wrote:
> When repeating a UTC time value during a leap second (when the UTC
> time should be 23:59:60), the TAI timescale should not stop. The kernel
> NTP code increments the TAI offset one second too late. This patch fixes
> the issue by incrementing the offset during the leap second itself.

Got a chance to look at this closer and I agree its the right fix.  So 
its queued.
thanks
-john

> Signed-off-by: Richard Cochran<richardcochran@gmail.com>
> ---
>   kernel/time/ntp.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
> index f03fd83..e8c8671 100644
> --- a/kernel/time/ntp.c
> +++ b/kernel/time/ntp.c
> @@ -412,6 +412,7 @@ int second_overflow(unsigned long secs)
>   		if (secs % 86400 == 0) {
>   			leap = -1;
>   			time_state = TIME_OOP;
> +			time_tai++;
>   			printk(KERN_NOTICE
>   				"Clock: inserting leap second 23:59:60 UTC\n");
>   		}
> @@ -426,7 +427,6 @@ int second_overflow(unsigned long secs)
>   		}
>   		break;
>   	case TIME_OOP:
> -		time_tai++;
>   		time_state = TIME_WAIT;
>   		break;
>

