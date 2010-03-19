Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab0CSDTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 23:19:34 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56699 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab0CSDTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 23:19:32 -0400
From: John Stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] ntp: Make time_adjust static
Date: Thu, 18 Mar 2010 20:19:27 -0700
Message-Id: <1268968769-19209-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that no arches are accessing time_adjust directly,
make it static.

CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 include/linux/timex.h |    1 -
 kernel/time/ntp.c     |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/timex.h b/include/linux/timex.h
index 7a082b3..e2de51e 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -238,7 +238,6 @@ extern int tickadj;			/* amount of adjustment per tick */
  * phase-lock loop variables
  */
 extern int time_status;		/* clock synchronization status bits */
-extern long time_adjust;	/* The amount of adjtime left */
 
 extern void ntp_init(void);
 extern void ntp_clear(void);
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 7c0f180..c631168 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -69,7 +69,7 @@ static s64			time_freq;
 /* time at last adjustment (secs):					*/
 static long			time_reftime;
 
-long				time_adjust;
+static long			time_adjust;
 
 /* constant (boot-param configurable) NTP tick adjustment (upscaled)	*/
 static s64			ntp_tick_adj;
-- 
1.6.0.4

