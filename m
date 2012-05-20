Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2ETUiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 16:38:09 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37303 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752453Ab2ETUiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 16:38:08 -0400
Message-ID: <1337546284.31503.5.camel@joe2Laptop>
Subject: Re: [PATCH] Staging: android: alarm: fixed quoted string split
 across lines
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Nasir Abed <nasirabed@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        swetland@google.com, Nasir Abed <nasirabed+kernel@gmail.com>
Date: Sun, 20 May 2012 13:38:04 -0700
In-Reply-To: <alpine.DEB.2.00.1205201328170.10189@chino.kir.corp.google.com>
References: <1337507659-14740-1-git-send-email-nasirabed+kernel@gmail.com>
	 <alpine.DEB.2.00.1205201328170.10189@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-05-20 at 13:28 -0700, David Rientjes wrote:
> On Sun, 20 May 2012, Nasir Abed wrote:
> 
> > diff --git a/drivers/staging/android/alarm.c b/drivers/staging/android/alarm.c
> > index c68950b..4ea07bb 100644
> > --- a/drivers/staging/android/alarm.c
> > +++ b/drivers/staging/android/alarm.c
> > @@ -302,8 +302,8 @@ int android_alarm_set_rtc(struct timespec new_time)
> >  	}
> >  	ret = rtc_set_time(alarm_rtc_dev, &rtc_new_rtc_time);
> >  	if (ret < 0)
> > -		pr_alarm(ERROR, "alarm_set_rtc: "
> > -			"Failed to set RTC, time will be lost on reboot\n");
> > +		pr_alarm(ERROR,
> > +			 "alarm_set_rtc: Failed to set RTC, time will be lost on reboot\n");
> >  err:
> >  	wake_unlock(&alarm_rtc_wake_lock);
> >  	mutex_unlock(&alarm_setrtc_mutex);
> 
> Looks like this would benefit from using __func__ since it already doesn't 
> represent the correct function name.

true.

Somewhat related, pr_alarm is a poor name choice.
It should probably called alarm_dbg.

o it's a duplicated #define
  it should be in some common #include
o it's a debug test that emits at KERN_INFO


