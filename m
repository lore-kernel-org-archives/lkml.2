Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab1HJXnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 19:43:53 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60382 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab1HJXnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 19:43:52 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/3] Alarmtimer fixes for 3.1
Date: Wed, 10 Aug 2011 16:43:33 -0700
Message-Id: <1313019816-32519-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,

In reviewing the alarmtimer code, I ran across a few bugs that should be
fixed for 3.1 and backported to 3.0-stable.

These are also available in the git repository at:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.1/tip/timers/alarmtimers


The last of these is a pretty terrible hack, but I've got a more invasive
fix (along with other cleanups) queued on top of these for 3.2 that should
resolve it. Feel free to take a peek at those changes here:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.2/tip/timers/alarmtimers

Let me know if you have any thoughts or feedback!

thanks
-john

CC: Thomas Gleixner <tglx@linutronix.de>

John Stultz (3):
  alarmtimers: Avoid possible null pointer traversal
  alarmtimers: Memset itimerspec passed into alarm_timer_get
  alarmtimers: Avoid possible denial of service with high freq periodic
    timers

 kernel/time/alarmtimer.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

-- 
1.7.3.2.146.gca209

