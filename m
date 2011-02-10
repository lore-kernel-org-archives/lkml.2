Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab1BJURP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 15:17:15 -0500
Received: from kroah.org ([198.145.64.141]:42872 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756835Ab1BJURO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 15:17:14 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Amit Shah <amit.shah@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/4] virtio: console: Move file back to drivers/char/
Date: Thu, 10 Feb 2011 12:17:09 -0800
Message-Id: <1297369032-18502-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110210201520.GA18283@kroah.com>
References: <20110210201520.GA18283@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@redhat.com>

Commit 728674a7e466628df2aeec6d11a2ae1ef968fb67 moved virtio_console.c
to drivers/tty/hvc/ under the perception of this being an hvc driver.
It was such once, but these days it has generic communication
capabilities as well, so move it to drivers/char/.

In the future, the hvc part from this file can be split off and moved
under drivers/tty/hvc/.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/Makefile                      |    1 +
 drivers/{tty/hvc => char}/virtio_console.c |    2 +-
 drivers/tty/hvc/Makefile                   |    1 -
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename drivers/{tty/hvc => char}/virtio_console.c (99%)

diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 5bc765d..8238f89 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_SYNCLINK_GT)	+= synclink_gt.o
 obj-$(CONFIG_AMIGA_BUILTIN_SERIAL) += amiserial.o
 obj-$(CONFIG_SX)		+= sx.o generic_serial.o
 obj-$(CONFIG_RIO)		+= rio/ generic_serial.o
+obj-$(CONFIG_VIRTIO_CONSOLE)	+= virtio_console.o
 obj-$(CONFIG_RAW_DRIVER)	+= raw.o
 obj-$(CONFIG_SGI_SNSC)		+= snsc.o snsc_event.o
 obj-$(CONFIG_MSPEC)		+= mspec.o
diff --git a/drivers/tty/hvc/virtio_console.c b/drivers/char/virtio_console.c
similarity index 99%
rename from drivers/tty/hvc/virtio_console.c
rename to drivers/char/virtio_console.c
index 896a2ce..5feadee 100644
--- a/drivers/tty/hvc/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -31,7 +31,7 @@
 #include <linux/virtio_console.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
-#include "hvc_console.h"
+#include "../tty/hvc/hvc_console.h"
 
 /*
  * This is a global struct for storing common data for all the devices
diff --git a/drivers/tty/hvc/Makefile b/drivers/tty/hvc/Makefile
index e6bed5f..d79e7e9 100644
--- a/drivers/tty/hvc/Makefile
+++ b/drivers/tty/hvc/Makefile
@@ -10,4 +10,3 @@ obj-$(CONFIG_HVC_XEN)		+= hvc_xen.o
 obj-$(CONFIG_HVC_IUCV)		+= hvc_iucv.o
 obj-$(CONFIG_HVC_UDBG)		+= hvc_udbg.o
 obj-$(CONFIG_HVCS)		+= hvcs.o
-obj-$(CONFIG_VIRTIO_CONSOLE)	+= virtio_console.o
-- 
1.7.3.2

