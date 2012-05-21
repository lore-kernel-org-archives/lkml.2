Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab2EUUOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:14:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58843 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754093Ab2EUUOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:14:17 -0400
Message-ID: <1337631255.13812.36.camel@joe2Laptop>
Subject: Re: [PATCH] Staging: android: alarm: Renamed pr_alarm to alarm_dbg
From: Joe Perches <joe@perches.com>
To: Nasir Abed <nasirabed+kernel@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 21 May 2012 13:14:15 -0700
In-Reply-To: <1337629490-7446-1-git-send-email-nasirabed+kernel@gmail.com>
References: <1337629490-7446-1-git-send-email-nasirabed+kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-21 at 21:44 +0200, Nasir Abed wrote:
> I renamed a macro to make it explicit that it's for debugging and
> fixed a warning about a quoted string split across multiple lines.

Hi Nasir.

Welcome to linux-kernel developing.

It's generally pretty unnecessary to resubmit a variant of
a patch that someone else has already submitted.

Especially one like this that does less than the original.

It's also considered good form to cc the original patch
submitter.

If you want to get your 2nd patch in, that's great, but
please consider doing work that isn't just checkpatch
cleanups and isn't duplicative of work where you were cc'd.

Style comments below: (duplicates not shown)

> diff --git a/drivers/staging/android/alarm.c b/drivers/staging/android/alarm.c

Is this done against -next or some other -staging tree?

> @@ -97,11 +96,11 @@ static void update_timer_locked(struct alarm_queue *base, bool head_removed)
>  
>  	alarm = container_of(base->first, struct android_alarm, node);
>  
> -	pr_alarm(FLOW, "selected alarm, type %d, func %pF at %lld\n",
> +	alarm_dbg(FLOW, "selected alarm, type %d, func %pF at %lld\n",
>  		alarm->type, alarm->function, ktime_to_ns(alarm->expires));

It's generally nicer to align arguments to the open parenthesis.

>  	if (is_wakeup && suspended) {
> -		pr_alarm(FLOW, "changed alarm while suspened\n");
> +		alarm_dbg(FLOW, "changed alarm while suspened\n");

Please look for and fix spelling typos when submitting changes.

> @@ -292,18 +291,18 @@ int android_alarm_set_rtc(struct timespec new_time)
>  	}
>  	spin_unlock_irqrestore(&alarm_slock, flags);
>  	if (ret < 0) {
> -		pr_alarm(ERROR, "alarm_set_rtc: Failed to set time\n");
> +		alarm_dbg(ERROR, "alarm_set_rtc: Failed to set time\n");

Please use %s: and __func__ when a function name is embedded
into a message string.

> @@ -499,7 +498,7 @@ static int rtc_alarm_add_device(struct device *dev,
>  	if (err)
>  		goto err3;
>  	alarm_rtc_dev = rtc;
> -	pr_alarm(INIT_STATUS, "using rtc device, %s, for alarms", rtc->name);
> +	alarm_dbg(INIT_STATUS, "using rtc device, %s, for alarms", rtc->name);
>  	mutex_unlock(&alarm_setrtc_mutex);
>  
>  	return 0;

Please make sure messages are newline "\n" terminated.
It helps to avoid possible output interleaving.

