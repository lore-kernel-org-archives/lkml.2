Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab2JLXtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 19:49:49 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:36401 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab2JLXtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 19:49:45 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, backports@vger.kernel.org, rob@ti.com,
        arnd@arndb.de, davej@redhat.com, airlied@linux.ie, bskeggs@redhat.com,
        alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, tglx@linutronix.de,
        daniel.vetter@ffwll.ch, jbarnes@virtuousgeek.org,
        alexander.deucher@amd.com, paulmck@linux.vnet.ibm.com,
        gregkh@linuxfoundation.org, laurent.pinchart@ideasonboard.com,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 1/2] uapi: update includes for drm content when no kernel API exists
Date: Fri, 12 Oct 2012 16:49:31 -0700
Message-Id: <1350085772-8755-2-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350085772-8755-1-git-send-email-mcgrof@do-not-panic.com>
References: <1350085772-8755-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

The UAPI changes split kernel API and userspace API
content onto two separate header files. The userspace
API drm content was moved to include/uapi/drm/ with the
same file name while kernel specific API content was
kept under include/drm/ with the same file name. When
one file was split into two files the kernel header
includes the uapi header and a UAPI prefix was added to
the uapi header for its header guard. When there was no
kernel API content found the uapi header file was the
only one that was kept and the original guard for the
header file was kept. In this particular case the
original users of this header file were not modified
and the uapi header file is expected to be picked up
by path.

This may work well at compilation on the kernel but when
backporting this creates a few complexities. To help with
backporting [0] lets be explicit about the new uapi path
when there is no respective kernel API header file. For
more details on the UAPI changes see the lwn article on
this [1].

[0] https://backports.wiki.kernel.org
[1] http://lwn.net/Articles/507794/

Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Cc: backports@vger.kernel.org

Cc: Rob Clark <rob@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Jones <davej@redhat.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/gpu/drm/drm_crtc.c            |    2 +-
 drivers/gpu/drm/nouveau/nv04_cursor.c |    2 +-
 drivers/staging/omapdrm/omap_crtc.c   |    2 +-
 include/drm/drmP.h                    |    4 ++--
 include/drm/drm_crtc.h                |    4 ++--
 include/uapi/drm/drm.h                |    2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index ef1b221..6486e89 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -35,7 +35,7 @@
 #include <drm/drmP.h>
 #include <drm/drm_crtc.h>
 #include <drm/drm_edid.h>
-#include <drm/drm_fourcc.h>
+#include <uapi/drm/drm_fourcc.h>
 
 /* Avoid boilerplate.  I'm tired of typing. */
 #define DRM_ENUM_NAME_FN(fnname, list)				\
diff --git a/drivers/gpu/drm/nouveau/nv04_cursor.c b/drivers/gpu/drm/nouveau/nv04_cursor.c
index fe86f0d..7af590f 100644
--- a/drivers/gpu/drm/nouveau/nv04_cursor.c
+++ b/drivers/gpu/drm/nouveau/nv04_cursor.c
@@ -1,5 +1,5 @@
 #include <drm/drmP.h>
-#include <drm/drm_mode.h>
+#include <uapi/drm/drm_mode.h>
 #include "nouveau_drm.h"
 #include "nouveau_reg.h"
 #include "nouveau_crtc.h"
diff --git a/drivers/staging/omapdrm/omap_crtc.c b/drivers/staging/omapdrm/omap_crtc.c
index 732f2ad..029c9ec 100644
--- a/drivers/staging/omapdrm/omap_crtc.c
+++ b/drivers/staging/omapdrm/omap_crtc.c
@@ -19,7 +19,7 @@
 
 #include "omap_drv.h"
 
-#include "drm_mode.h"
+#include <uapi/drm/drm_mode.h>
 #include "drm_crtc.h"
 #include "drm_crtc_helper.h"
 
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 3fd8280..9030369 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -72,8 +72,8 @@
 #include <linux/workqueue.h>
 #include <linux/poll.h>
 #include <asm/pgalloc.h>
-#include <drm/drm.h>
-#include <drm/drm_sarea.h>
+#include <uapi/drm/drm.h>
+#include <uapi/drm/drm_sarea.h>
 
 #include <linux/idr.h>
 
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 3fa18b7..1012503 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -30,9 +30,9 @@
 #include <linux/types.h>
 #include <linux/idr.h>
 #include <linux/fb.h>
-#include <drm/drm_mode.h>
 
-#include <drm/drm_fourcc.h>
+#include <uapi/drm/drm_mode.h>
+#include <uapi/drm/drm_fourcc.h>
 
 struct drm_device;
 struct drm_mode_set;
diff --git a/include/uapi/drm/drm.h b/include/uapi/drm/drm.h
index 1e3481e..51ee504 100644
--- a/include/uapi/drm/drm.h
+++ b/include/uapi/drm/drm.h
@@ -628,7 +628,7 @@ struct drm_prime_handle {
 	__s32 fd;
 };
 
-#include <drm/drm_mode.h>
+#include <uapi/drm/drm_mode.h>
 
 #define DRM_IOCTL_BASE			'd'
 #define DRM_IO(nr)			_IO(DRM_IOCTL_BASE,nr)
-- 
1.7.10.4

