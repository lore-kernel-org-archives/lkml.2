Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab1HUW7e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 18:59:34 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:33763 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932077Ab1HUW7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 18:59:30 -0400
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Luca Risolia <luca.risolia@studio.unibo.it>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] [media] et61x251: Use current logging styles
Date: Sun, 21 Aug 2011 15:56:50 -0700
Message-Id: <41e34fe23bba1bd41c5c246edf0065ce150faada.1313966090.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1313966088.git.joe@perches.com>
References: <cover.1313966088.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pr_fmt and convert printks to pr_<level>
Remove explicit prefixes from logging messages.
One of the prefixes was defective, a copy/paste error.
Use ##__VA_ARGS__ for variadic macros.
Whitespace neatening.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/video/et61x251/et61x251.h            |   66 ++++++++++---------
 drivers/media/video/et61x251/et61x251_core.c       |    2 +
 drivers/media/video/et61x251/et61x251_tas5130d1b.c |    2 +
 3 files changed, 39 insertions(+), 31 deletions(-)

diff --git a/drivers/media/video/et61x251/et61x251.h b/drivers/media/video/et61x251/et61x251.h
index 14bb907..337ded4 100644
--- a/drivers/media/video/et61x251/et61x251.h
+++ b/drivers/media/video/et61x251/et61x251.h
@@ -165,45 +165,49 @@ et61x251_attach_sensor(struct et61x251_device* cam,
 #undef DBG
 #undef KDBG
 #ifdef ET61X251_DEBUG
-#	define DBG(level, fmt, args...)                                       \
-do {                                                                          \
-	if (debug >= (level)) {                                               \
-		if ((level) == 1)                                             \
-			dev_err(&cam->usbdev->dev, fmt "\n", ## args);        \
-		else if ((level) == 2)                                        \
-			dev_info(&cam->usbdev->dev, fmt "\n", ## args);       \
-		else if ((level) >= 3)                                        \
-			dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n",   \
-				 __FILE__, __func__, __LINE__ , ## args); \
-	}                                                                     \
+#define DBG(level, fmt, ...)						\
+do {									\
+	if (debug >= (level)) {						\
+		if ((level) == 1)					\
+			dev_err(&cam->usbdev->dev, fmt "\n",		\
+				##__VA_ARGS__);				\
+		else if ((level) == 2)					\
+			dev_info(&cam->usbdev->dev, fmt "\n",		\
+				 ##__VA_ARGS__);			\
+		else if ((level) >= 3)					\
+			dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n", \
+				 __FILE__, __func__, __LINE__,		\
+				 ##__VA_ARGS__);			\
+	}								\
 } while (0)
-#	define KDBG(level, fmt, args...)                                      \
-do {                                                                          \
-	if (debug >= (level)) {                                               \
-		if ((level) == 1 || (level) == 2)                             \
-			pr_info("et61x251: " fmt "\n", ## args);              \
-		else if ((level) == 3)                                        \
-			pr_debug("sn9c102: [%s:%s:%d] " fmt "\n", __FILE__,   \
-				 __func__, __LINE__ , ## args);           \
-	}                                                                     \
+#define KDBG(level, fmt, ...)						\
+do {									\
+	if (debug >= (level)) {						\
+		if ((level) == 1 || (level) == 2)			\
+			pr_info(fmt "\n", ##__VA_ARGS__);		\
+		else if ((level) == 3)					\
+			pr_debug("[%s:%s:%d] " fmt "\n",		\
+				 __FILE__,  __func__, __LINE__,		\
+				 ##__VA_ARGS__);			\
+	}								\
 } while (0)
-#	define V4LDBG(level, name, cmd)                                       \
-do {                                                                          \
-	if (debug >= (level))                                                 \
-		v4l_print_ioctl(name, cmd);                                   \
+#define V4LDBG(level, name, cmd)					\
+do {									\
+	if (debug >= (level))						\
+		v4l_print_ioctl(name, cmd);				\
 } while (0)
 #else
-#	define DBG(level, fmt, args...) do {;} while(0)
-#	define KDBG(level, fmt, args...) do {;} while(0)
-#	define V4LDBG(level, name, cmd) do {;} while(0)
+#define DBG(level, fmt, ...) do {;} while(0)
+#define KDBG(level, fmt, ...) do {;} while(0)
+#define V4LDBG(level, name, cmd) do {;} while(0)
 #endif
 
 #undef PDBG
-#define PDBG(fmt, args...)                                                    \
-dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n", __FILE__, __func__,   \
-	 __LINE__ , ## args)
+#define PDBG(fmt, ...)							\
+	dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n",		\
+		 __FILE__, __func__, __LINE__, ##__VA_ARGS__)
 
 #undef PDBGG
-#define PDBGG(fmt, args...) do {;} while(0) /* placeholder */
+#define PDBGG(fmt, args...) do {;} while (0) /* placeholder */
 
 #endif /* _ET61X251_H_ */
diff --git a/drivers/media/video/et61x251/et61x251_core.c b/drivers/media/video/et61x251/et61x251_core.c
index 9a1e80a..d3777c8 100644
--- a/drivers/media/video/et61x251/et61x251_core.c
+++ b/drivers/media/video/et61x251/et61x251_core.c
@@ -18,6 +18,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
  ***************************************************************************/
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/drivers/media/video/et61x251/et61x251_tas5130d1b.c b/drivers/media/video/et61x251/et61x251_tas5130d1b.c
index 04b7fbb..ced2e16 100644
--- a/drivers/media/video/et61x251/et61x251_tas5130d1b.c
+++ b/drivers/media/video/et61x251/et61x251_tas5130d1b.c
@@ -19,6 +19,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
  ***************************************************************************/
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "et61x251_sensor.h"
 
 
-- 
1.7.6.405.gc1be0

