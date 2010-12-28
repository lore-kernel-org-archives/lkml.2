Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab0L1MFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 07:05:24 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37278 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab0L1MFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 07:05:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=NlsrAG/jKjJtggkQhJU3q5uVPZZE+QEBpvStScDkMU9usiefrtpGMYrsKzHUIF/AwT
         x/FzWTB8jD1elY8rpPxQWWWjaC2abJay28S77XO9yknUU6LPfkyOyL1d+SOSAVBv0OhS
         a0F9gA7AGQPgg/uq7G7UBJuGlNrLnOZdMmtOI=
MIME-Version: 1.0
Date: Tue, 28 Dec 2010 17:35:22 +0530
Message-ID: <AANLkTim4zbBvTyc4hNurCmPN7GisXe1mmzR6P4aj3xzA@mail.gmail.com>
Subject: Drift when measuring time using add_timer
From: Mohan V <mohanvforum@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

I am testing the timers on a OMAP4 based board. I am seeing a drift or
the time difference between the timer value and when the function callback
happens. This drift is around 1000ms or 1s for a expiry value of >=5mins.
Is the time drift expected? Is this way of measuring right or is there
any other way?

OMAP4 as you may know is a multi-core processor and CONFIG_SMP is enabled
along with the following:
CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS

My kernel configurations:
kernel: 2.6.37-rc7 (commit id: ffc96d)
config: omap2plus_defconfig

My driver does the following:

struct timeval tv;
test_timer_proc_write()
{
           del_timer_sync(&my_timer);
           period = 300000; /* 5min */
           my_timer.expires = jiffies + msecs_to_jiffies(period);
           my_timer.function = func_timeout; /* Call back function*/
           /* Save the current time in global variable */
           do_gettimeofday(&timeval);
           /* add timer with an expiry value of 5mins*/
           add_timer(&my_timer);
}

/* Get the current time and print the difference between the two values */
func_timeout()
{
           struct timeval tv1;
           do_gettimeofday(&tv);
           /* take the difference between current time and saved time */
           ms = (tv.tv_sec - tv1.tv_sec) * 1000 + \
                   (tv.tv_usec - tv1.tv_usec) / 1000;
           printk("Interval = %d\n", ms);
}

Thanks for your time.

Regards,
Mohan
