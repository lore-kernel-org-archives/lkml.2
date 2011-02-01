Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab1BADoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 22:44:09 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:38499 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab1BADoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 22:44:06 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Jamie Lokier <jamie@shareable.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH 0/2] Add CLOCK_BOOTTIME functionality
Date: Mon, 31 Jan 2011 19:43:54 -0800
Message-Id: <1296531837-12879-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset extends the hrtimers code to handle additional
clockids and then introduces CLOCK_BOOTTIME which is identical
to CLOCK_MONOTONIC, except it also includes any time spent in
suspend (currently as measured by read_persistent_clock()).

CC: Jamie Lokier <jamie@shareable.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alexander Shishkin <virtuoso@slind.org>
CC: Arve Hjønnevåg <arve@android.com>

John Stultz (2):
  [RFC] hrtimers: extend hrtimer base code to handle more then 2
    clockids
  [RFC] hrtimers: Add CLOCK_BOOTTIME clockid, hrtimerbase and posix
    interface

 include/linux/hrtimer.h   |    8 ++++-
 include/linux/time.h      |    4 ++
 kernel/hrtimer.c          |   71 ++++++++++++++++++++++++++++++++--------
 kernel/posix-timers.c     |   16 ++++++++-
 kernel/time/timekeeping.c |   79 ++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 160 insertions(+), 18 deletions(-)

-- 
1.7.3.2.146.gca209

