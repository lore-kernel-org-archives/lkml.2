Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab2IOBGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 21:06:07 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52060 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab2IOBGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 21:06:02 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/3] jiffies: Kill unused TICK_USEC_TO_NSEC
Date: Fri, 14 Sep 2012 21:05:28 -0400
Message-Id: <1347671130-22095-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347671130-22095-1-git-send-email-john.stultz@linaro.org>
References: <1347671130-22095-1-git-send-email-john.stultz@linaro.org>
x-cbid: 12091501-5806-0000-0000-000019A2CEE4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one is using TICK_USEC_TO_NSEC, so kill it.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/jiffies.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 8268054..4a7e386 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -70,12 +70,6 @@
 /* TICK_USEC is the time between ticks in usec assuming fake USER_HZ */
 #define TICK_USEC ((1000000UL + USER_HZ/2) / USER_HZ)
 
-/*
- * TICK_USEC_TO_NSEC is the time between ticks in nsec assuming SHIFTED_HZ and
- * a value TUSEC for TICK_USEC (can be set bij adjtimex)
- */
-#define TICK_USEC_TO_NSEC(TUSEC) (SH_DIV(TUSEC * USER_HZ * 1000, SHIFTED_HZ, 8))
-
 /* some arch's have a small-data section that can be accessed register-relative
  * but that can only take up to, say, 4-byte variables. jiffies being part of
  * an 8-byte variable may not be correctly accessed unless we force the issue
-- 
1.7.9.5

