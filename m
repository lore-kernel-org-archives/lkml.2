Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab2BKTzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 14:55:39 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:50168 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab2BKTzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 14:55:38 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alok N Kataria <akataria@vmware.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH] time: remove no_sync_cmos_clock
Date: Sat, 11 Feb 2012 17:54:59 -0200
Message-Id: <1328990099-6428-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9863c90f682fba34cdc26c3437e8c00da6c83fa4 (x86, vmware: Remove
deprecated VMI kernel support) removed the only place which set
no_sync_cmos_clock. Since that commit, this variable is never set.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 include/linux/time.h |    1 -
 kernel/time/ntp.c    |    6 +-----
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index b306178..97734e9 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -116,7 +116,6 @@ static inline struct timespec timespec_sub(struct timespec lhs,
 extern void read_persistent_clock(struct timespec *ts);
 extern void read_boot_clock(struct timespec *ts);
 extern int update_persistent_clock(struct timespec now);
-extern int no_sync_cmos_clock __read_mostly;
 void timekeeping_init(void);
 extern int timekeeping_suspended;
 
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index f6117a4..20bff28 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -444,9 +444,6 @@ void second_overflow(void)
 
 #ifdef CONFIG_GENERIC_CMOS_UPDATE
 
-/* Disable the cmos update - used by virtualization and embedded */
-int no_sync_cmos_clock  __read_mostly;
-
 static void sync_cmos_clock(struct work_struct *work);
 
 static DECLARE_DELAYED_WORK(sync_cmos_work, sync_cmos_clock);
@@ -493,8 +490,7 @@ static void sync_cmos_clock(struct work_struct *work)
 
 static void notify_cmos_timer(void)
 {
-	if (!no_sync_cmos_clock)
-		schedule_delayed_work(&sync_cmos_work, 0);
+	schedule_delayed_work(&sync_cmos_work, 0);
 }
 
 #else
-- 
1.7.7.6

