Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab2ETU26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 16:28:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58770 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2ETU25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 16:28:57 -0400
Date: Sun, 20 May 2012 13:28:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nasir Abed <nasirabed@gmail.com>
cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, swetland@google.com,
        Nasir Abed <nasirabed+kernel@gmail.com>
Subject: Re: [PATCH] Staging: android: alarm: fixed quoted string split across
 lines
In-Reply-To: <1337507659-14740-1-git-send-email-nasirabed+kernel@gmail.com>
Message-ID: <alpine.DEB.2.00.1205201328170.10189@chino.kir.corp.google.com>
References: <1337507659-14740-1-git-send-email-nasirabed+kernel@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2012, Nasir Abed wrote:

> diff --git a/drivers/staging/android/alarm.c b/drivers/staging/android/alarm.c
> index c68950b..4ea07bb 100644
> --- a/drivers/staging/android/alarm.c
> +++ b/drivers/staging/android/alarm.c
> @@ -302,8 +302,8 @@ int android_alarm_set_rtc(struct timespec new_time)
>  	}
>  	ret = rtc_set_time(alarm_rtc_dev, &rtc_new_rtc_time);
>  	if (ret < 0)
> -		pr_alarm(ERROR, "alarm_set_rtc: "
> -			"Failed to set RTC, time will be lost on reboot\n");
> +		pr_alarm(ERROR,
> +			 "alarm_set_rtc: Failed to set RTC, time will be lost on reboot\n");
>  err:
>  	wake_unlock(&alarm_rtc_wake_lock);
>  	mutex_unlock(&alarm_setrtc_mutex);

Looks like this would benefit from using __func__ since it already doesn't 
represent the correct function name.
