Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab1AYWSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:18:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:63529 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab1AYWSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:18:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 19/20] drivers: remove extraneous includes of smp_lock.h
Date: Tue, 25 Jan 2011 23:17:33 +0100
Message-Id: <1295993854-4971-20-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295993854-4971-1-git-send-email-arnd@arndb.de>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:vOrifhWy7YESYTivLLNKXwaAbtm/8qhtbPcT0QEjgc8
 mnLnZDesYurmkS9caoWG9o9DJ28Az4UBxry6+2vvG9GNxvV/mM
 nLGYskdUpYNCs4GfNImoByAJ3a8rAYeJaQTWzHn2OJMEiPjQwc
 0wBcA4WFyBreT8KbM3z4BQBQovkBH9lcUAPv38Y8jQRInCGQUi
 Dy4ItQyc+UaaRwzpccL0A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These were missed the last time I cleaned this up
globally, because of code moving around or new code
getting merged.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/megaraid/megaraid_sas_fp.c     |    1 -
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    1 -
 drivers/staging/easycap/easycap.h           |    1 -
 drivers/staging/easycap/easycap_ioctl.c     |    1 -
 drivers/target/target_core_device.c         |    1 -
 drivers/target/target_core_fabric_lib.c     |    1 -
 drivers/target/target_core_file.c           |    1 -
 drivers/target/target_core_hba.c            |    1 -
 drivers/target/target_core_iblock.c         |    1 -
 drivers/target/target_core_pscsi.c          |    1 -
 drivers/target/target_core_rd.c             |    1 -
 drivers/target/target_core_tpg.c            |    1 -
 drivers/target/target_core_transport.c      |    1 -
 drivers/tty/n_hdlc.c                        |    1 -
 drivers/tty/n_r3964.c                       |    1 -
 drivers/tty/pty.c                           |    1 -
 drivers/tty/tty_io.c                        |    1 -
 drivers/tty/tty_ldisc.c                     |    2 --
 drivers/tty/vt/selection.c                  |    1 -
 drivers/tty/vt/vc_screen.c                  |    1 -
 drivers/tty/vt/vt.c                         |    1 -
 drivers/tty/vt/vt_ioctl.c                   |    1 -
 22 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 53fa96a..8fe3a45 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -39,7 +39,6 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
-#include <linux/smp_lock.h>
 #include <linux/uio.h>
 #include <linux/uaccess.h>
 #include <linux/fs.h>
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index c1e09d5..d6e2a66 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -38,7 +38,6 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
-#include <linux/smp_lock.h>
 #include <linux/uio.h>
 #include <linux/uaccess.h>
 #include <linux/fs.h>
diff --git a/drivers/staging/easycap/easycap.h b/drivers/staging/easycap/easycap.h
index 8ebf96f..063d447 100644
--- a/drivers/staging/easycap/easycap.h
+++ b/drivers/staging/easycap/easycap.h
@@ -65,7 +65,6 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/kref.h>
 #include <linux/usb.h>
diff --git a/drivers/staging/easycap/easycap_ioctl.c b/drivers/staging/easycap/easycap_ioctl.c
index 447953a..c1a0c9c 100644
--- a/drivers/staging/easycap/easycap_ioctl.c
+++ b/drivers/staging/easycap/easycap_ioctl.c
@@ -25,7 +25,6 @@
 */
 /*****************************************************************************/
 
-#include <linux/smp_lock.h>
 #include "easycap.h"
 #include "easycap_debug.h"
 #include "easycap_standard.h"
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 317ce58..b0759d5 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -33,7 +33,6 @@
 #include <linux/timer.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/kthread.h>
 #include <linux/in.h>
 #include <net/sock.h>
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 2628564..a3c695a 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -28,7 +28,6 @@
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 0aaca88..190ca8a 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -33,7 +33,6 @@
 #include <linux/blkdev.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index 4bbe820..73f7d6d 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -31,7 +31,6 @@
 #include <linux/timer.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/in.h>
 #include <net/sock.h>
 #include <net/tcp.h>
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index c6e0d75..39dac3a 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -35,7 +35,6 @@
 #include <linux/blkdev.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/bio.h>
 #include <linux/genhd.h>
 #include <linux/file.h>
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 742d246..d7606b6 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -34,7 +34,6 @@
 #include <linux/blk_types.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/genhd.h>
 #include <linux/cdrom.h>
 #include <linux/file.h>
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 979aebf..8dc6d74 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -34,7 +34,6 @@
 #include <linux/blkdev.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index abfa81a..8f0ba2d 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -31,7 +31,6 @@
 #include <linux/timer.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/in.h>
 #include <net/sock.h>
 #include <net/tcp.h>
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 28b6292..1a5c00b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -34,7 +34,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/kthread.h>
 #include <linux/in.h>
 #include <linux/cdrom.h>
diff --git a/drivers/tty/n_hdlc.c b/drivers/tty/n_hdlc.c
index 47d3228..994745a 100644
--- a/drivers/tty/n_hdlc.c
+++ b/drivers/tty/n_hdlc.c
@@ -97,7 +97,6 @@
 #include <linux/slab.h>
 #include <linux/tty.h>
 #include <linux/errno.h>
-#include <linux/smp_lock.h>
 #include <linux/string.h>	/* used in new tty drivers */
 #include <linux/signal.h>	/* used in new tty drivers */
 #include <linux/if.h>
diff --git a/drivers/tty/n_r3964.c b/drivers/tty/n_r3964.c
index 88dda0c..5c6c314 100644
--- a/drivers/tty/n_r3964.c
+++ b/drivers/tty/n_r3964.c
@@ -57,7 +57,6 @@
 #include <linux/ioport.h>
 #include <linux/in.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/tty.h>
 #include <linux/errno.h>
 #include <linux/string.h>	/* used in new tty drivers */
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 923a485..2310cb7 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -23,7 +23,6 @@
 #include <linux/major.h>
 #include <linux/mm.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/sysctl.h>
 #include <linux/device.h>
 #include <linux/uaccess.h>
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 464d09d..f0422d5 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -90,7 +90,6 @@
 #include <linux/proc_fs.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/device.h>
 #include <linux/wait.h>
 #include <linux/bitops.h>
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 4214d58..70808ad 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -34,8 +34,6 @@
 #include <linux/vt_kern.h>
 #include <linux/selection.h>
 
-#include <linux/smp_lock.h>	/* For the moment */
-
 #include <linux/kmod.h>
 #include <linux/nsproxy.h>
 
diff --git a/drivers/tty/vt/selection.c b/drivers/tty/vt/selection.c
index ebae344..e04876b 100644
--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -26,7 +26,6 @@
 #include <linux/selection.h>
 #include <linux/tiocl.h>
 #include <linux/console.h>
-#include <linux/smp_lock.h>
 
 /* Don't take this from <ctype.h>: 011-015 on the screen aren't spaces */
 #define isspace(c)	((c) == ' ')
diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index eab3a1f..09dc635 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -34,7 +34,6 @@
 #include <linux/kbd_kern.h>
 #include <linux/console.h>
 #include <linux/device.h>
-#include <linux/smp_lock.h>
 #include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/poll.h>
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 76407ec..82517ad 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -89,7 +89,6 @@
 #include <linux/mutex.h>
 #include <linux/vt_kern.h>
 #include <linux/selection.h>
-#include <linux/smp_lock.h>
 #include <linux/tiocl.h>
 #include <linux/kbd_kern.h>
 #include <linux/consolemap.h>
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 6b68a0f..1d5f5e4 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -27,7 +27,6 @@
 #include <linux/console.h>
 #include <linux/consolemap.h>
 #include <linux/signal.h>
-#include <linux/smp_lock.h>
 #include <linux/timex.h>
 
 #include <asm/io.h>
-- 
1.7.1

