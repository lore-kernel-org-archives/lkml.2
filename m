Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab0KHWEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:04:08 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:46094
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755822Ab0KHWDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:03:02 -0500
From: Haiyang Zhang <haiyangz@linuxonhyperv.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 06/10] staging: hv: Convert camel cased local variables in osd.c to lower cases
Date: Mon,  8 Nov 2010 14:04:43 -0800
Message-Id: <1289253887-2596-6-git-send-email-haiyangz@linuxonhyperv.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1289253887-2596-5-git-send-email-haiyangz@linuxonhyperv.com>
References: <1289253887-2596-1-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-2-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-3-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-4-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-5-git-send-email-haiyangz@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

staging: hv: Convert camel cased local variables in osd.c to lower cases

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/osd.c |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/hv/osd.c b/drivers/staging/hv/osd.c
index 8c3eb27..b39ec25 100644
--- a/drivers/staging/hv/osd.c
+++ b/drivers/staging/hv/osd.c
@@ -130,9 +130,9 @@ EXPORT_SYMBOL_GPL(osd_WaitEventCreate);
 
 /**
  * osd_WaitEventSet() - Wake up the process
- * @waitEvent: Structure to event to be woken up
+ * @wait_event: Structure to event to be woken up
  *
- * @waitevent is of type &struct osd_waitevent
+ * @wait_event is of type &struct osd_waitevent
  *
  * Wake up the sleeping process so it can do some work.
  * And set condition indicator in &struct osd_waitevent to indicate
@@ -140,18 +140,18 @@ EXPORT_SYMBOL_GPL(osd_WaitEventCreate);
  *
  * Only used by Network and Storage Hyper-V drivers.
  */
-void osd_WaitEventSet(struct osd_waitevent *waitEvent)
+void osd_WaitEventSet(struct osd_waitevent *wait_event)
 {
-	waitEvent->condition = 1;
-	wake_up_interruptible(&waitEvent->event);
+	wait_event->condition = 1;
+	wake_up_interruptible(&wait_event->event);
 }
 EXPORT_SYMBOL_GPL(osd_WaitEventSet);
 
 /**
  * osd_WaitEventWait() - Wait for event till condition is true
- * @waitEvent: Structure to event to be put to sleep
+ * @wait_event: Structure to event to be put to sleep
  *
- * @waitevent is of type &struct osd_waitevent
+ * @wait_event is of type &struct osd_waitevent
  *
  * Set up the process to sleep until waitEvent->condition get true.
  * And set condition indicator in &struct osd_waitevent to indicate
@@ -161,25 +161,25 @@ EXPORT_SYMBOL_GPL(osd_WaitEventSet);
  *
  * Mainly used by Hyper-V drivers.
  */
-int osd_WaitEventWait(struct osd_waitevent *waitEvent)
+int osd_WaitEventWait(struct osd_waitevent *wait_event)
 {
 	int ret = 0;
 
-	ret = wait_event_interruptible(waitEvent->event,
-				       waitEvent->condition);
-	waitEvent->condition = 0;
+	ret = wait_event_interruptible(wait_event->event,
+				       wait_event->condition);
+	wait_event->condition = 0;
 	return ret;
 }
 EXPORT_SYMBOL_GPL(osd_WaitEventWait);
 
 /**
  * osd_WaitEventWaitEx() - Wait for event or timeout for process wakeup
- * @waitEvent: Structure to event to be put to sleep
- * @TimeoutInMs:       Total number of Milliseconds to wait before waking up
+ * @wait_event: Structure to event to be put to sleep
+ * @timeout_in_ms:       Total number of Milliseconds to wait before waking up
  *
- * @waitevent is of type &struct osd_waitevent
+ * @wait_event is of type &struct osd_waitevent
  * Set up the process to sleep until @waitEvent->condition get true or
- * @TimeoutInMs (Time out in Milliseconds) has been reached.
+ * @timeout_in_ms (Time out in Milliseconds) has been reached.
  * And set condition indicator in &struct osd_waitevent to indicate
  * the process is in a sleeping state.
  *
@@ -187,14 +187,14 @@ EXPORT_SYMBOL_GPL(osd_WaitEventWait);
  *
  * Mainly used by Hyper-V drivers.
  */
-int osd_WaitEventWaitEx(struct osd_waitevent *waitEvent, u32 TimeoutInMs)
+int osd_WaitEventWaitEx(struct osd_waitevent *wait_event, u32 timeout_in_ms)
 {
 	int ret = 0;
 
-	ret = wait_event_interruptible_timeout(waitEvent->event,
-					       waitEvent->condition,
-					       msecs_to_jiffies(TimeoutInMs));
-	waitEvent->condition = 0;
+	ret = wait_event_interruptible_timeout(wait_event->event,
+					       wait_event->condition,
+					       msecs_to_jiffies(timeout_in_ms));
+	wait_event->condition = 0;
 	return ret;
 }
 EXPORT_SYMBOL_GPL(osd_WaitEventWaitEx);
-- 
1.6.3.2

