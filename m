Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab2DTWCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:02:41 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:49941 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab2DTWCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:02:24 -0400
Date: Fri, 20 Apr 2012 15:02:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Thomas Gleixner <tglx@linutronix.de>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 3/4] android-alarm: Rework alarm-dev.c to use upstreamed
 alarmtimers
Message-ID: <20120420220220.GA29084@kroah.com>
References: <1334950307-403-1-git-send-email-john.stultz@linaro.org>
 <1334950307-403-4-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1334950307-403-4-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 12:31:46PM -0700, John Stultz wrote:
> This reworks the alarm-dev.c to use the upstreamed alarmtimers
> interface.
> 
> CC: Colin Cross <ccross@android.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Android Kernel Team <kernel-team@android.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/staging/android/alarm-dev.c |  108 +++++++++++++++++++++++++++++++---
>  1 files changed, 98 insertions(+), 10 deletions(-)

After this patch, I get the following warnings:

  CC      drivers/staging/android/alarm-dev.o
drivers/staging/android/alarm-dev.c: In function ‘devalarm_start’:
drivers/staging/android/alarm-dev.c:93:3: warning: passing argument 1 of ‘alarm_start’ from incompatible pointer type [enabled by default]
include/linux/alarmtimer.h:46:6: note: expected ‘struct alarm *’ but argument is of type ‘struct android_alarm *’
drivers/staging/android/alarm-dev.c: In function ‘alarm_dev_init’:
drivers/staging/android/alarm-dev.c:354:2: warning: passing argument 3 of ‘android_alarm_init’ from incompatible pointer type [enabled by default]
drivers/staging/android/android_alarm.h:69:6: note: expected ‘void (*)(struct android_alarm *)’ but argument is of type ‘enum alarmtimer_restart (*)(struct android_alarm *, union ktime_t)’
drivers/staging/android/alarm-dev.c:358:2: warning: passing argument 3 of ‘android_alarm_init’ from incompatible pointer type [enabled by default]
drivers/staging/android/android_alarm.h:69:6: note: expected ‘void (*)(struct android_alarm *)’ but argument is of type ‘enum alarmtimer_restart (*)(struct android_alarm *, union ktime_t)’

Care to send a patch that fixes this up as well, as odds are, something just
went wrong...

thanks,

greg k-h
