Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab1FVGiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 02:38:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364Ab1FVGiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 02:38:04 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        Amerigo Wang <amwang@redhat.com>, Chris Ball <cjb@laptop.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philip Rakity <prakity@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-mmc@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: [PATCH 4/5] pm: move pm notifiers into suspend.h
Date: Wed, 22 Jun 2011 14:35:21 +0800
Message-Id: <1308724522-32461-5-git-send-email-amwang@redhat.com>
In-Reply-To: <1308724522-32461-1-git-send-email-amwang@redhat.com>
References: <1308724522-32461-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not necessary to share the same notifier.h.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
 drivers/mmc/core/core.c  |    3 +++
 include/linux/notifier.h |   10 ++--------
 include/linux/suspend.h  |    8 ++++++++
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 68091dd..2cd4ec5 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -23,6 +23,9 @@
 #include <linux/log2.h>
 #include <linux/regulator/consumer.h>
 #include <linux/pm_runtime.h>
+#ifdef CONFIG_PM
+#include <linux/suspend.h>
+#endif
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index 145c436..ae8f7d9 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -191,15 +191,9 @@ static inline int notifier_to_errno(int ret)
 
 /* reboot notifiers are defined in include/linux/reboot.h. */
 
-#define NETLINK_URELEASE	0x0001	/* Unicast netlink socket released */
+/* Hibernation and suspend events are defined in include/linux/suspend.h. */
 
-/* Hibernation and suspend events */
-#define PM_HIBERNATION_PREPARE	0x0001 /* Going to hibernate */
-#define PM_POST_HIBERNATION	0x0002 /* Hibernation finished */
-#define PM_SUSPEND_PREPARE	0x0003 /* Going to suspend the system */
-#define PM_POST_SUSPEND		0x0004 /* Suspend finished */
-#define PM_RESTORE_PREPARE	0x0005 /* Going to restore a saved image */
-#define PM_POST_RESTORE		0x0006 /* Restore failed */
+#define NETLINK_URELEASE	0x0001	/* Unicast netlink socket released */
 
 /* Console keyboard events.
  * Note: KBD_KEYCODE is always sent before KBD_UNBOUND_KEYCODE, KBD_UNICODE and
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 083ffea..95bc81c 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -260,6 +260,14 @@ static inline int hibernate(void) { return -ENOSYS; }
 static inline bool system_entering_hibernation(void) { return false; }
 #endif /* CONFIG_HIBERNATION */
 
+/* Hibernation and suspend events */
+#define PM_HIBERNATION_PREPARE	0x0001 /* Going to hibernate */
+#define PM_POST_HIBERNATION	0x0002 /* Hibernation finished */
+#define PM_SUSPEND_PREPARE	0x0003 /* Going to suspend the system */
+#define PM_POST_SUSPEND		0x0004 /* Suspend finished */
+#define PM_RESTORE_PREPARE	0x0005 /* Going to restore a saved image */
+#define PM_POST_RESTORE		0x0006 /* Restore failed */
+
 #ifdef CONFIG_PM_SLEEP
 void save_processor_state(void);
 void restore_processor_state(void);
-- 
1.7.4.4

