Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab0CWQV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:21:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:53084 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039Ab0CWQV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:21:57 -0400
Date: Tue, 23 Mar 2010 16:21:38 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de
In-Reply-To: <1268968769-19209-1-git-send-email-johnstul@us.ibm.com>
References: <1268968769-19209-1-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] ntp: Make time_adjust static
Message-ID: <tip-e1292ba164742e3a236e407148e00300b7196906@git.kernel.org>
Git-Commit-ID: e1292ba164742e3a236e407148e00300b7196906
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 23 Mar 2010 16:21:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e1292ba164742e3a236e407148e00300b7196906
Gitweb:     http://git.kernel.org/tip/e1292ba164742e3a236e407148e00300b7196906
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Thu, 18 Mar 2010 20:19:27 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 23 Mar 2010 17:19:37 +0100

ntp: Make time_adjust static

Now that no arches are accessing time_adjust directly,
make it static.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <1268968769-19209-1-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
