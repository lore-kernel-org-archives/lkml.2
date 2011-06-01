Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab1FAGH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 02:07:59 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44843 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab1FAGHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 02:07:55 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC][PATCH 0/2] Avoid accumulating drift in suspend/resume
Date: Tue, 31 May 2011 23:07:47 -0700
Message-Id: <1306908469-15275-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arve Hjønnevåg noted that in the suspend/resume path, we're likely to see
half-second errors from each read of the RTC. If a system is frequently
suspended, these errors will accumulate quickly.

Arve's solution was to compare the time delta between the system time
and the RTC, for each suspend. If the difference is small, use the same
delta for each suspend. This consistency avoids the error from accumulating.

This patch set implements Arve's suggestion for both the RTC and persistent
clock suspend paths.

Initial tests show that this improves time accuracy over many repeated
suspends. So while testing continues, I just wanted to send this out for
review and feedback.

thanks
-john

CC: Arve Hjønnevåg <arve@android.com>
CC: Thomas Gleixner <tglx@linutronix.de>

John Stultz (2):
  time: Avoid accumulating time drift in suspend/resume
  rtc: Avoid accumulating time drift in suspend/resume

 drivers/rtc/class.c       |   65 +++++++++++++++++++++++++++++++++------------
 kernel/time/timekeeping.c |   22 +++++++++++++++
 2 files changed, 70 insertions(+), 17 deletions(-)

-- 
1.7.3.2.146.gca209

