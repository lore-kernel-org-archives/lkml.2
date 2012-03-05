Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab2CEAes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 19:34:48 -0500
Received: from mail.windriver.com ([147.11.1.11]:50081 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab2CEAeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 19:34:23 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/2] device.h: cleanup users outside of linux/include (C files)
Date: Sun,  4 Mar 2012 19:34:16 -0500
Message-Id: <1330907657-2156-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1330907657-2156-1-git-send-email-paul.gortmaker@windriver.com>
References: <1330907657-2156-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For files that are actively using linux/device.h, make sure
that they call it out.  This will allow us to clean up some
of the implicit uses of linux/device.h within include/*
without introducing build regressions.

Yes, this was created by "cheating" -- i.e. the headers were
cleaned up, and then the fallout was found and fixed, and then
the two commits were reordered.  This ensures we don't introduce
build regressions into the git history.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/base/power/clock_ops.c        |    1 +
 drivers/base/power/common.c           |    1 +
 drivers/base/power/opp.c              |    1 +
 drivers/base/regmap/regcache-lzo.c    |    1 +
 drivers/base/regmap/regcache-rbtree.c |    1 +
 drivers/base/regmap/regcache.c        |    1 +
 drivers/base/regmap/regmap-debugfs.c  |    1 +
 drivers/base/regmap/regmap-irq.c      |    1 +
 drivers/edac/edac_stub.c              |    1 +
 drivers/edac/mce_amd_inj.c            |    1 +
 drivers/mfd/wm8994-regmap.c           |    1 +
 drivers/power/apm_power.c             |    1 +
 drivers/power/power_supply.h          |    4 ++++
 drivers/power/power_supply_leds.c     |    1 +
 drivers/power/power_supply_sysfs.c    |    1 +
 net/rfkill/core.c                     |    1 +
 sound/core/init.c                     |    1 +
 sound/core/pcm.c                      |    1 +
 sound/core/seq/seq.c                  |    1 +
 sound/core/timer.c                    |    1 +
 20 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
index 428e55e..869d7ff 100644
--- a/drivers/base/power/clock_ops.c
+++ b/drivers/base/power/clock_ops.c
@@ -8,6 +8,7 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/device.h>
 #include <linux/io.h>
 #include <linux/pm.h>
 #include <linux/pm_clock.h>
diff --git a/drivers/base/power/common.c b/drivers/base/power/common.c
index 4af7c1c..a14085c 100644
--- a/drivers/base/power/common.c
+++ b/drivers/base/power/common.c
@@ -8,6 +8,7 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/device.h>
 #include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/pm_clock.h>
diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 95706fa..ac993ea 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/cpufreq.h>
+#include <linux/device.h>
 #include <linux/list.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
diff --git a/drivers/base/regmap/regcache-lzo.c b/drivers/base/regmap/regcache-lzo.c
index b7d1614..51f6f28 100644
--- a/drivers/base/regmap/regcache-lzo.c
+++ b/drivers/base/regmap/regcache-lzo.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/device.h>
 #include <linux/lzo.h>
 
 #include "internal.h"
diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 32620c4..b487c29 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/device.h>
 #include <linux/debugfs.h>
 #include <linux/rbtree.h>
 #include <linux/seq_file.h>
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 1ead661..214f704 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -12,6 +12,7 @@
 
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/device.h>
 #include <trace/events/regmap.h>
 #include <linux/bsearch.h>
 #include <linux/sort.h>
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 6f39747..8c90a83 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -15,6 +15,7 @@
 #include <linux/mutex.h>
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
+#include <linux/device.h>
 
 #include "internal.h"
 
diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 428836f..1befaa7 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/export.h>
+#include <linux/device.h>
 #include <linux/regmap.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
diff --git a/drivers/edac/edac_stub.c b/drivers/edac/edac_stub.c
index 670c448..6c86f6e 100644
--- a/drivers/edac/edac_stub.c
+++ b/drivers/edac/edac_stub.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/edac.h>
 #include <linux/atomic.h>
+#include <linux/device.h>
 #include <asm/edac.h>
 
 int edac_op_state = EDAC_OPSTATE_INVAL;
diff --git a/drivers/edac/mce_amd_inj.c b/drivers/edac/mce_amd_inj.c
index 885e8ad..66b5151 100644
--- a/drivers/edac/mce_amd_inj.c
+++ b/drivers/edac/mce_amd_inj.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/kobject.h>
+#include <linux/device.h>
 #include <linux/edac.h>
 #include <linux/module.h>
 #include <asm/mce.h>
diff --git a/drivers/mfd/wm8994-regmap.c b/drivers/mfd/wm8994-regmap.c
index c598ae6..0c0a215 100644
--- a/drivers/mfd/wm8994-regmap.c
+++ b/drivers/mfd/wm8994-regmap.c
@@ -15,6 +15,7 @@
 #include <linux/mfd/wm8994/core.h>
 #include <linux/mfd/wm8994/registers.h>
 #include <linux/regmap.h>
+#include <linux/device.h>
 
 #include "wm8994.h"
 
diff --git a/drivers/power/apm_power.c b/drivers/power/apm_power.c
index 8a612de..3976301 100644
--- a/drivers/power/apm_power.c
+++ b/drivers/power/apm_power.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/device.h>
 #include <linux/power_supply.h>
 #include <linux/apm-emulation.h>
 
diff --git a/drivers/power/power_supply.h b/drivers/power/power_supply.h
index 018de2b..cc439fd 100644
--- a/drivers/power/power_supply.h
+++ b/drivers/power/power_supply.h
@@ -10,6 +10,10 @@
  *  You may use this code as per GPL version 2
  */
 
+struct device;
+struct device_type;
+struct power_supply;
+
 #ifdef CONFIG_SYSFS
 
 extern void power_supply_init_attrs(struct device_type *dev_type);
diff --git a/drivers/power/power_supply_leds.c b/drivers/power/power_supply_leds.c
index da25eb9..995f966 100644
--- a/drivers/power/power_supply_leds.c
+++ b/drivers/power/power_supply_leds.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/device.h>
 #include <linux/power_supply.h>
 #include <linux/slab.h>
 
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index b52b57c..4368e7d 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/ctype.h>
+#include <linux/device.h>
 #include <linux/power_supply.h>
 #include <linux/slab.h>
 #include <linux/stat.h>
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 354760e..f974961 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -29,6 +29,7 @@
 #include <linux/rfkill.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
+#include <linux/device.h>
 #include <linux/miscdevice.h>
 #include <linux/wait.h>
 #include <linux/poll.h>
diff --git a/sound/core/init.c b/sound/core/init.c
index 3ac49b1..995fc5d 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/device.h>
 #include <linux/file.h>
 #include <linux/slab.h>
 #include <linux/time.h>
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index 8928ca87..1888a90 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/mutex.h>
+#include <linux/device.h>
 #include <sound/core.h>
 #include <sound/minors.h>
 #include <sound/pcm.h>
diff --git a/sound/core/seq/seq.c b/sound/core/seq/seq.c
index 9d8379a..7121105 100644
--- a/sound/core/seq/seq.c
+++ b/sound/core/seq/seq.c
@@ -21,6 +21,7 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/device.h>
 #include <sound/core.h>
 #include <sound/initval.h>
 
diff --git a/sound/core/timer.c b/sound/core/timer.c
index 8e7561d..6ddcf06 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/mutex.h>
+#include <linux/device.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <sound/core.h>
-- 
1.7.9.1

