Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab0L0XlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 18:41:04 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46578 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab0L0XlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 18:41:02 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/3] Cleanup ADJ_SETOFFSET patch
Date: Mon, 27 Dec 2010 15:40:41 -0800
Message-Id: <1293493244-17583-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking to queue Richard's ADJ_SETOFFSET patch to see
if it could be merged into -tip for 2.6.38, but on second 
glance I noticed the ugly local_irq_disable bits as well
as the fact that adding the offset uses a gettime/add/settime
pattern which will also add a small error as the action isn't
atomic.

So I implemented a timekeeping function to add a fixed offset:
timekeeping_inject_offset(), and reworked Richard's code to
make use of it.

Richard: Any objection here? Mind testing this with the rest
of your patch queue?

Thomas: Any comments? Does this seem reasonable for 2.6.38? 
Should I fold my cleanups into Richard's patch?

thanks
-john


CC: Richard Cochran <richard.cochran@omicron.at>
CC: Thomas Gleixner <tglx@linutronix.de>

John Stultz (2):
  time: Introduce timekeeping_inject_offset
  ntp: Change ADJ_SETOFFSET implementation to use
    timekeeping_inject_offset

Richard Cochran (1):
  ntp: add ADJ_SETOFFSET mode bit

 include/linux/time.h      |    1 +
 include/linux/timex.h     |    3 ++-
 kernel/time/ntp.c         |   13 +++++++++++++
 kernel/time/timekeeping.c |   36 ++++++++++++++++++++++++++++++++++++
 4 files changed, 52 insertions(+), 1 deletions(-)

-- 
1.7.3.2.146.gca209

