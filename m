Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab0KTKGe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 05:06:34 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53985 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0KTKGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 05:06:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=VImEurPOsmoPHMxZvUYk3HEIhRK2vxLpe97M35q43wSh73gwohftz3D8hB/qi4x0Sd
         eCelDkVTkO55nKSNv4gNVQidg7RZm1DwknOlBUq758sdivhLd1t9kuEYo+YgvrsMYWrV
         sWWEWyqh/CU6Pv2SjeOXALIRgioP83Z8Y7iXA=
Message-ID: <4CE79CE5.9050605@gmail.com>
Date: Sat, 20 Nov 2010 11:03:17 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/16 v4] pramfs: test module
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Test module.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
diff -Nurp linux-2.6.36-orig/fs/pramfs/pramfs_test.c linux-2.6.36/fs/pramfs/pramfs_test.c
--- linux-2.6.36-orig/fs/pramfs/pramfs_test.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.36/fs/pramfs/pramfs_test.c	2010-09-14 18:49:52.000000000 +0200
@@ -0,0 +1,49 @@
+/*
+ * FILE NAME fs/pramfs/pramfs_test.c
+ *
+ * BRIEF DESCRIPTION
+ *
+ * Pramfs test module.
+ *
+ * Copyright 2009-2010 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include "pram.h"
+
+int __init test_pramfs_write(void)
+{
+	struct pram_super_block *psb;
+
+	psb = get_pram_super();
+	if (!psb) {
+		printk(KERN_ERR
+			"%s: PRAMFS super block not found (not mounted?)\n",
+			__func__);
+		return 1;
+	}
+
+	/*
+	 * Attempt an unprotected clear of checksum information in the
+	 * superblock, this should cause a kernel page protection fault.
+	 */
+	printk("%s: writing to kernel VA %p\n", __func__, psb);
+	psb->s_sum = 0;
+
+	return 0;
+}
+
+void test_pramfs_write_cleanup(void) {}
+
+/* Module information */
+MODULE_LICENSE("GPL");
+module_init(test_pramfs_write);
+module_exit(test_pramfs_write_cleanup);
 
