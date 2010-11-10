Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab0KJXvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:51:21 -0500
Received: from smtp-out-135.synserver.de ([212.40.180.135]:1045 "EHLO
	smtp-out-133.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757322Ab0KJXvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:51:20 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 3497
Message-ID: <4CDB2FE2.2050203@metafoo.de>
Date: Thu, 11 Nov 2010 00:50:58 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Trilok Soni <tsoni@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-arm-msm@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [RFC v1 PATCH 3/6] led: pmic8058: Add PMIC8058 leds driver
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org> <1289393281-4459-4-git-send-email-tsoni@codeaurora.org> <4CDB0451.3090303@metafoo.de> <20101110232840.GA2121@core.coreip.homeip.net>
In-Reply-To: <20101110232840.GA2121@core.coreip.homeip.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Wed, Nov 10, 2010 at 09:45:05PM +0100, Lars-Peter Clausen wrote:
>> Trilok Soni wrote:
>>> +
>>> +static void led_kp_set(struct pmic8058_led_data *led, enum led_brightness value)
>>> +{
>>> +	int rc;
>>> +	u8 level;
>>> +	unsigned long flags;
>>> +
>>> +	spin_lock_irqsave(&led->value_lock, flags);
>> This function is only ever called from within the workqueue so there is no need for
>> locking.
>>
> 
> That is a common misconception, unfortunately. The same work may
> be executing on several CPUs at the same time if it was scheduled on
> multi-threaded work queue.
> 

Hm, right my fault.
Still the comment above is still valid, because the original workqueue handler was
locked by a mutex. But the comment regarding the mutex should have been:
 You can remove the mutex if you queue the work on the system_nrt_wq workqueue

> ...
> 
>>> +	schedule_work(&led->work);
> 
> And sure enough, keventd is such workqueue.
> 
> Now, whether having the same work run simultaneously is OK or not is a
> different question altogether...
> 

- Lars
