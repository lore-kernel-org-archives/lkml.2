Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab0GNUOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:14:20 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36552 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757531Ab0GNUKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:10:17 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        Arnd Bergmann <arnd@arndb.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH RFC tip/core/rcu 13/30] input: __rcu annotations
Date: Wed, 14 Jul 2010 13:09:47 -0700
Message-Id: <1279138204-12849-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100714200945.GA10535@linux.vnet.ibm.com>
References: <20100714200945.GA10535@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/evdev.c |    2 +-
 include/linux/input.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 2ee6c7a..73b1208 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -28,7 +28,7 @@ struct evdev {
 	int minor;
 	struct input_handle handle;
 	wait_queue_head_t wait;
-	struct evdev_client *grab;
+	struct evdev_client __rcu *grab;
 	struct list_head client_list;
 	spinlock_t client_lock; /* protects client_list */
 	struct mutex mutex;
diff --git a/include/linux/input.h b/include/linux/input.h
index 6fcc910..4d2d239 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1174,7 +1174,7 @@ struct input_dev {
 	int (*flush)(struct input_dev *dev, struct file *file);
 	int (*event)(struct input_dev *dev, unsigned int type, unsigned int code, int value);
 
-	struct input_handle *grab;
+	struct input_handle __rcu *grab;
 
 	spinlock_t event_lock;
 	struct mutex mutex;
-- 
1.7.0.6

