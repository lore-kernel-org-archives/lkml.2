Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab1FUXxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 19:53:12 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:58496 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab1FUXxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 19:53:07 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Meelis Roos <mroos@ut.ee>,
        =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/2] Alarmtimer fixes for 3.0
Date: Tue, 21 Jun 2011 16:52:51 -0700
Message-Id: <1308700373-18415-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	Here are two alarmtimer fixes that should go in for 3.0.
The first is a fix to check for rtc devices on demand, to better
handle late rtc device driver loading. And the second makes sure
we report an error to apps using alarmtiemrs if there is no backing
RTC device.

Let me know if you have any issues with these.

Both of these patches are available in the git repository at:

  git://git.linaro.org/people/jstultz/linux.git fortglx/3.0/tip/timers/alarmtimers

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Meelis Roos <mroos@ut.ee>
CC: Toralf Förster <toralf.foerster@gmx.de>
CC: Richard Weinberger <richard@nod.at
CC: Peter Zijlstra <peterz@infradead.org>
John Stultz (2):
  alarmtimers: Handle late rtc module loading
  alarmtimers: Return -ENOTSUPP if no RTC device is present

 kernel/time/alarmtimer.c |  158 +++++++++++++++++++++++++--------------------
 1 files changed, 88 insertions(+), 70 deletions(-)

-- 
1.7.3.2.146.gca209

