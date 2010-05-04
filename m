Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832Ab0EDUXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:23:15 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47744 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933716Ab0EDUUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:20:20 -0400
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
Subject: [PATCH tip/core/rcu 42/48] input: __rcu annotations
Date: Tue,  4 May 2010 13:19:52 -0700
Message-Id: <1273004398-19760-42-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100504201934.GA19234@linux.vnet.ibm.com>
References: <20100504201934.GA19234@linux.vnet.ibm.com>
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
1.7.0

