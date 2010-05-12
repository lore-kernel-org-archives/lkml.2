Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab0ELVfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:35:50 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36621 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758131Ab0ELVeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:34:10 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Arnd Bergmann <arnd@arndb.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH RFC tip/core/rcu 17/23] input: __rcu annotations
Date: Wed, 12 May 2010 14:33:36 -0700
Message-Id: <1273700022-16523-17-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100512213317.GA15085@linux.vnet.ibm.com>
References: <20100512213317.GA15085@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
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
index 7ed2251..850b6b7 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1173,7 +1173,7 @@ struct input_dev {
 	int (*flush)(struct input_dev *dev, struct file *file);
 	int (*event)(struct input_dev *dev, unsigned int type, unsigned int code, int value);
 
-	struct input_handle *grab;
+	struct input_handle __rcu *grab;
 
 	spinlock_t event_lock;
 	struct mutex mutex;
-- 
1.7.0.6

