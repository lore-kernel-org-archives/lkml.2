Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab0JDU2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:28:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50554 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084Ab0JDU2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:28:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: gregkh@suse.de
Subject: [PATCH, RFC] autofs3: move to drivers/staging
Date: Mon, 4 Oct 2010 22:28:10 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.31-19-generic; KDE/4.5.1; x86_64; ; )
Cc: autofs@linux.kernel.org, Ian Kent <raven@themaw.net>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010042228.10642.arnd@arndb.de>
X-Provags-ID: V02:K0:ncLBkn/jIuL4cRKk0OV80cxfFjLlUsZ7SvU5ETZY1yq
 OG19FP0o7GaMz4NRNmQ9z1HwEsnsDut0NHw/d0NQMJm2//aGUL
 5cVMYC1aW5YhRnOcpl3pQA99ixyqmqsjTRTtfs89CpJJyh2eVs
 M+CKd+/sV1/2b7E+Qp6LqBhSY+g1m1pxegvG/JrRl5IvHt8EGU
 qtR92/HFoqfJ9eMHwlcHQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody appears to be interested in fixing autofs3 bugs
any more and it uses the BKL, which is going away.

Move this to staging for retirement. Unless someone
complains until 2.6.38, we can remove it for good.

The include/linux/auto_fs.h header file is still used
by autofs4, so it remains in place.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ian Kent <raven@themaw.net>
Cc: autofs@linux.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 MAINTAINERS                               |    4 ++--
 drivers/staging/Kconfig                   |    2 ++
 drivers/staging/Makefile                  |    1 +
 {fs => drivers/staging}/autofs/Kconfig    |    0
 {fs => drivers/staging}/autofs/Makefile   |    0
 {fs => drivers/staging}/autofs/autofs_i.h |    2 +-
 {fs => drivers/staging}/autofs/dirhash.c  |    2 +-
 {fs => drivers/staging}/autofs/init.c     |    2 +-
 {fs => drivers/staging}/autofs/inode.c    |    2 +-
 {fs => drivers/staging}/autofs/root.c     |    2 +-
 {fs => drivers/staging}/autofs/symlink.c  |    2 +-
 {fs => drivers/staging}/autofs/waitq.c    |    2 +-
 fs/Kconfig                                |    1 -
 fs/Makefile                               |    1 -
 14 files changed, 12 insertions(+), 11 deletions(-)
 rename {fs => drivers/staging}/autofs/Kconfig (100%)
 rename {fs => drivers/staging}/autofs/Makefile (100%)
 rename {fs => drivers/staging}/autofs/autofs_i.h (99%)
 rename {fs => drivers/staging}/autofs/dirhash.c (99%)
 rename {fs => drivers/staging}/autofs/init.c (97%)
 rename {fs => drivers/staging}/autofs/inode.c (99%)
 rename {fs => drivers/staging}/autofs/root.c (99%)
 rename {fs => drivers/staging}/autofs/symlink.c (95%)
 rename {fs => drivers/staging}/autofs/waitq.c (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index a3f9786..0d675a9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3314,8 +3314,8 @@ F:	Documentation/kdump/
 KERNEL AUTOMOUNTER (AUTOFS)
 M:	"H. Peter Anvin" <hpa@zytor.com>
 L:	autofs@linux.kernel.org
-S:	Odd Fixes
-F:	fs/autofs/
+S:	Obsolete
+F:	drivers/staging/autofs/
 
 KERNEL AUTOMOUNTER v4 (AUTOFS4)
 M:	Ian Kent <raven@themaw.net>
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index e8edba7..0150353 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -87,6 +87,8 @@ source "drivers/staging/dream/Kconfig"
 
 source "drivers/staging/pohmelfs/Kconfig"
 
+source "drivers/staging/autofs/Kconfig"
+
 source "drivers/staging/phison/Kconfig"
 
 source "drivers/staging/line6/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index d8eeea4..de5c0e5 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_SPECTRA)		+= spectra/
 obj-$(CONFIG_TRANZPORT)		+= frontier/
 obj-$(CONFIG_DREAM)		+= dream/
 obj-$(CONFIG_POHMELFS)		+= pohmelfs/
+obj-$(CONFIG_AUTOFS_FS)		+= autofs/
 obj-$(CONFIG_IDE_PHISON)	+= phison/
 obj-$(CONFIG_LINE6_USB)		+= line6/
 obj-$(CONFIG_USB_SERIAL_QUATECH2)	+= serqt_usb2/
diff --git a/fs/autofs/Kconfig b/drivers/staging/autofs/Kconfig
similarity index 100%
rename from fs/autofs/Kconfig
rename to drivers/staging/autofs/Kconfig
diff --git a/fs/autofs/Makefile b/drivers/staging/autofs/Makefile
similarity index 100%
rename from fs/autofs/Makefile
rename to drivers/staging/autofs/Makefile
diff --git a/fs/autofs/autofs_i.h b/drivers/staging/autofs/autofs_i.h
similarity index 99%
rename from fs/autofs/autofs_i.h
rename to drivers/staging/autofs/autofs_i.h
index 901a3e6..647a143 100644
--- a/fs/autofs/autofs_i.h
+++ b/drivers/staging/autofs/autofs_i.h
@@ -1,6 +1,6 @@
 /* -*- linux-c -*- ------------------------------------------------------- *
  *   
- * linux/fs/autofs/autofs_i.h
+ * drivers/staging/autofs/autofs_i.h
  *
  *   Copyright 1997-1998 Transmeta Corporation - All Rights Reserved
  *
diff --git a/fs/autofs/dirhash.c b/drivers/staging/autofs/dirhash.c
similarity index 99%
rename from fs/autofs/dirhash.c
rename to drivers/staging/autofs/dirhash.c
index e947915..8f3e2b8 100644
--- a/fs/autofs/dirhash.c
+++ b/drivers/staging/autofs/dirhash.c
@@ -1,6 +1,6 @@
 /* -*- linux-c -*- --------------------------------------------------------- *
  *
- * linux/fs/autofs/dirhash.c
+ * drivers/staging/autofs/dirhash.c
  *
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *
diff --git a/fs/autofs/init.c b/drivers/staging/autofs/init.c
similarity index 97%
rename from fs/autofs/init.c
rename to drivers/staging/autofs/init.c
index cea5219..765c72f 100644
--- a/fs/autofs/init.c
+++ b/drivers/staging/autofs/init.c
@@ -1,6 +1,6 @@
 /* -*- linux-c -*- --------------------------------------------------------- *
  *
- * linux/fs/autofs/init.c
+ * drivers/staging/autofs/init.c
  *
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *
diff --git a/fs/autofs/inode.c b/drivers/staging/autofs/inode.c
similarity index 99%
rename from fs/autofs/inode.c
rename to drivers/staging/autofs/inode.c
index e1734f2..74db190 100644
--- a/fs/autofs/inode.c
+++ b/drivers/staging/autofs/inode.c
@@ -1,6 +1,6 @@
 /* -*- linux-c -*- --------------------------------------------------------- *
  *
- * linux/fs/autofs/inode.c
+ * drivers/staging/autofs/inode.c
  *
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *
diff --git a/fs/autofs/root.c b/drivers/staging/autofs/root.c
similarity index 99%
rename from fs/autofs/root.c
rename to drivers/staging/autofs/root.c
index 11b1ea7..70210aa 100644
--- a/fs/autofs/root.c
+++ b/drivers/staging/autofs/root.c
@@ -1,6 +1,6 @@
 /* -*- linux-c -*- --------------------------------------------------------- *
  *
- * linux/fs/autofs/root.c
+ * drivers/staging/autofs/root.c
  *
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *
diff --git a/fs/autofs/symlink.c b/drivers/staging/autofs/symlink.c
similarity index 95%
rename from fs/autofs/symlink.c
rename to drivers/staging/autofs/symlink.c
index 7ce9cb2..ff2c65c 100644
--- a/fs/autofs/symlink.c
+++ b/drivers/staging/autofs/symlink.c
@@ -1,6 +1,6 @@
 /* -*- linux-c -*- --------------------------------------------------------- *
  *
- * linux/fs/autofs/symlink.c
+ * drivers/staging/autofs/symlink.c
  *
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *
diff --git a/fs/autofs/waitq.c b/drivers/staging/autofs/waitq.c
similarity index 99%
rename from fs/autofs/waitq.c
rename to drivers/staging/autofs/waitq.c
index be46805..d3c8cc9 100644
--- a/fs/autofs/waitq.c
+++ b/drivers/staging/autofs/waitq.c
@@ -1,6 +1,6 @@
 /* -*- linux-c -*- --------------------------------------------------------- *
  *
- * linux/fs/autofs/waitq.c
+ * drivers/staging/autofs/waitq.c
  *
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *
diff --git a/fs/Kconfig b/fs/Kconfig
index 3d18530..30da8ee 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -59,7 +59,6 @@ source "fs/notify/Kconfig"
 
 source "fs/quota/Kconfig"
 
-source "fs/autofs/Kconfig"
 source "fs/autofs4/Kconfig"
 source "fs/fuse/Kconfig"
 
diff --git a/fs/Makefile b/fs/Makefile
index e6ec1d3..e571fed 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -104,7 +104,6 @@ obj-$(CONFIG_UBIFS_FS)		+= ubifs/
 obj-$(CONFIG_AFFS_FS)		+= affs/
 obj-$(CONFIG_ROMFS_FS)		+= romfs/
 obj-$(CONFIG_QNX4FS_FS)		+= qnx4/
-obj-$(CONFIG_AUTOFS_FS)		+= autofs/
 obj-$(CONFIG_AUTOFS4_FS)	+= autofs4/
 obj-$(CONFIG_ADFS_FS)		+= adfs/
 obj-$(CONFIG_FUSE_FS)		+= fuse/
-- 
1.7.1

