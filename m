Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab1ATSDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 13:03:49 -0500
Received: from kroah.org ([198.145.64.141]:45914 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab1ATSDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 13:03:48 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/3] tty: move hvc drivers to drivers/tty/hvc/
Date: Thu, 20 Jan 2011 10:03:43 -0800
Message-Id: <1295546625-30681-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20110120174910.GA30124@kroah.com>
References: <20110120174910.GA30124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As requested by Arnd Bergmann, the hvc drivers are now
moved to the drivers/tty/hvc/ directory.  The virtio_console.c driver
was also moved, as it required the hvc_console.h file to be able to be
built, and it really is a hvc driver.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/Makefile                      |   13 -------------
 drivers/tty/Makefile                       |    1 +
 drivers/tty/hvc/Makefile                   |   13 +++++++++++++
 drivers/{char => tty/hvc}/hvc_beat.c       |    0
 drivers/{char => tty/hvc}/hvc_console.c    |    0
 drivers/{char => tty/hvc}/hvc_console.h    |    0
 drivers/{char => tty/hvc}/hvc_dcc.c        |    0
 drivers/{char => tty/hvc}/hvc_irq.c        |    0
 drivers/{char => tty/hvc}/hvc_iseries.c    |    0
 drivers/{char => tty/hvc}/hvc_iucv.c       |    0
 drivers/{char => tty/hvc}/hvc_rtas.c       |    0
 drivers/{char => tty/hvc}/hvc_tile.c       |    0
 drivers/{char => tty/hvc}/hvc_udbg.c       |    0
 drivers/{char => tty/hvc}/hvc_vio.c        |    0
 drivers/{char => tty/hvc}/hvc_xen.c        |    0
 drivers/{char => tty/hvc}/hvcs.c           |    0
 drivers/{char => tty/hvc}/hvsi.c           |    0
 drivers/{char => tty/hvc}/virtio_console.c |    0
 18 files changed, 14 insertions(+), 13 deletions(-)
 create mode 100644 drivers/tty/hvc/Makefile
 rename drivers/{char => tty/hvc}/hvc_beat.c (100%)
 rename drivers/{char => tty/hvc}/hvc_console.c (100%)
 rename drivers/{char => tty/hvc}/hvc_console.h (100%)
 rename drivers/{char => tty/hvc}/hvc_dcc.c (100%)
 rename drivers/{char => tty/hvc}/hvc_irq.c (100%)
 rename drivers/{char => tty/hvc}/hvc_iseries.c (100%)
 rename drivers/{char => tty/hvc}/hvc_iucv.c (100%)
 rename drivers/{char => tty/hvc}/hvc_rtas.c (100%)
 rename drivers/{char => tty/hvc}/hvc_tile.c (100%)
 rename drivers/{char => tty/hvc}/hvc_udbg.c (100%)
 rename drivers/{char => tty/hvc}/hvc_vio.c (100%)
 rename drivers/{char => tty/hvc}/hvc_xen.c (100%)
 rename drivers/{char => tty/hvc}/hvcs.c (100%)
 rename drivers/{char => tty/hvc}/hvsi.c (100%)
 rename drivers/{char => tty/hvc}/virtio_console.c (100%)

diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 1e9dffb..5bc765d 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -30,25 +30,12 @@ obj-$(CONFIG_SYNCLINK_GT)	+= synclink_gt.o
 obj-$(CONFIG_AMIGA_BUILTIN_SERIAL) += amiserial.o
 obj-$(CONFIG_SX)		+= sx.o generic_serial.o
 obj-$(CONFIG_RIO)		+= rio/ generic_serial.o
-obj-$(CONFIG_HVC_CONSOLE)	+= hvc_vio.o hvsi.o
-obj-$(CONFIG_HVC_ISERIES)	+= hvc_iseries.o
-obj-$(CONFIG_HVC_RTAS)		+= hvc_rtas.o
-obj-$(CONFIG_HVC_TILE)		+= hvc_tile.o
-obj-$(CONFIG_HVC_DCC)		+= hvc_dcc.o
-obj-$(CONFIG_HVC_BEAT)		+= hvc_beat.o
-obj-$(CONFIG_HVC_DRIVER)	+= hvc_console.o
-obj-$(CONFIG_HVC_IRQ)		+= hvc_irq.o
-obj-$(CONFIG_HVC_XEN)		+= hvc_xen.o
-obj-$(CONFIG_HVC_IUCV)		+= hvc_iucv.o
-obj-$(CONFIG_HVC_UDBG)		+= hvc_udbg.o
-obj-$(CONFIG_VIRTIO_CONSOLE)	+= virtio_console.o
 obj-$(CONFIG_RAW_DRIVER)	+= raw.o
 obj-$(CONFIG_SGI_SNSC)		+= snsc.o snsc_event.o
 obj-$(CONFIG_MSPEC)		+= mspec.o
 obj-$(CONFIG_MMTIMER)		+= mmtimer.o
 obj-$(CONFIG_UV_MMTIMER)	+= uv_mmtimer.o
 obj-$(CONFIG_VIOTAPE)		+= viotape.o
-obj-$(CONFIG_HVCS)		+= hvcs.o
 obj-$(CONFIG_IBM_BSR)		+= bsr.o
 obj-$(CONFIG_SGI_MBCS)		+= mbcs.o
 obj-$(CONFIG_BRIQ_PANEL)	+= briq_panel.o
diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
index c43ef48..d3685f0 100644
--- a/drivers/tty/Makefile
+++ b/drivers/tty/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_N_GSM)		+= n_gsm.o
 obj-$(CONFIG_R3964)		+= n_r3964.o
 
 obj-y				+= vt/
+obj-$(CONFIG_HVC_DRIVER)	+= hvc/
diff --git a/drivers/tty/hvc/Makefile b/drivers/tty/hvc/Makefile
new file mode 100644
index 0000000..e6bed5f
--- /dev/null
+++ b/drivers/tty/hvc/Makefile
@@ -0,0 +1,13 @@
+obj-$(CONFIG_HVC_CONSOLE)	+= hvc_vio.o hvsi.o
+obj-$(CONFIG_HVC_ISERIES)	+= hvc_iseries.o
+obj-$(CONFIG_HVC_RTAS)		+= hvc_rtas.o
+obj-$(CONFIG_HVC_TILE)		+= hvc_tile.o
+obj-$(CONFIG_HVC_DCC)		+= hvc_dcc.o
+obj-$(CONFIG_HVC_BEAT)		+= hvc_beat.o
+obj-$(CONFIG_HVC_DRIVER)	+= hvc_console.o
+obj-$(CONFIG_HVC_IRQ)		+= hvc_irq.o
+obj-$(CONFIG_HVC_XEN)		+= hvc_xen.o
+obj-$(CONFIG_HVC_IUCV)		+= hvc_iucv.o
+obj-$(CONFIG_HVC_UDBG)		+= hvc_udbg.o
+obj-$(CONFIG_HVCS)		+= hvcs.o
+obj-$(CONFIG_VIRTIO_CONSOLE)	+= virtio_console.o
diff --git a/drivers/char/hvc_beat.c b/drivers/tty/hvc/hvc_beat.c
similarity index 100%
rename from drivers/char/hvc_beat.c
rename to drivers/tty/hvc/hvc_beat.c
diff --git a/drivers/char/hvc_console.c b/drivers/tty/hvc/hvc_console.c
similarity index 100%
rename from drivers/char/hvc_console.c
rename to drivers/tty/hvc/hvc_console.c
diff --git a/drivers/char/hvc_console.h b/drivers/tty/hvc/hvc_console.h
similarity index 100%
rename from drivers/char/hvc_console.h
rename to drivers/tty/hvc/hvc_console.h
diff --git a/drivers/char/hvc_dcc.c b/drivers/tty/hvc/hvc_dcc.c
similarity index 100%
rename from drivers/char/hvc_dcc.c
rename to drivers/tty/hvc/hvc_dcc.c
diff --git a/drivers/char/hvc_irq.c b/drivers/tty/hvc/hvc_irq.c
similarity index 100%
rename from drivers/char/hvc_irq.c
rename to drivers/tty/hvc/hvc_irq.c
diff --git a/drivers/char/hvc_iseries.c b/drivers/tty/hvc/hvc_iseries.c
similarity index 100%
rename from drivers/char/hvc_iseries.c
rename to drivers/tty/hvc/hvc_iseries.c
diff --git a/drivers/char/hvc_iucv.c b/drivers/tty/hvc/hvc_iucv.c
similarity index 100%
rename from drivers/char/hvc_iucv.c
rename to drivers/tty/hvc/hvc_iucv.c
diff --git a/drivers/char/hvc_rtas.c b/drivers/tty/hvc/hvc_rtas.c
similarity index 100%
rename from drivers/char/hvc_rtas.c
rename to drivers/tty/hvc/hvc_rtas.c
diff --git a/drivers/char/hvc_tile.c b/drivers/tty/hvc/hvc_tile.c
similarity index 100%
rename from drivers/char/hvc_tile.c
rename to drivers/tty/hvc/hvc_tile.c
diff --git a/drivers/char/hvc_udbg.c b/drivers/tty/hvc/hvc_udbg.c
similarity index 100%
rename from drivers/char/hvc_udbg.c
rename to drivers/tty/hvc/hvc_udbg.c
diff --git a/drivers/char/hvc_vio.c b/drivers/tty/hvc/hvc_vio.c
similarity index 100%
rename from drivers/char/hvc_vio.c
rename to drivers/tty/hvc/hvc_vio.c
diff --git a/drivers/char/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
similarity index 100%
rename from drivers/char/hvc_xen.c
rename to drivers/tty/hvc/hvc_xen.c
diff --git a/drivers/char/hvcs.c b/drivers/tty/hvc/hvcs.c
similarity index 100%
rename from drivers/char/hvcs.c
rename to drivers/tty/hvc/hvcs.c
diff --git a/drivers/char/hvsi.c b/drivers/tty/hvc/hvsi.c
similarity index 100%
rename from drivers/char/hvsi.c
rename to drivers/tty/hvc/hvsi.c
diff --git a/drivers/char/virtio_console.c b/drivers/tty/hvc/virtio_console.c
similarity index 100%
rename from drivers/char/virtio_console.c
rename to drivers/tty/hvc/virtio_console.c
-- 
1.7.1

