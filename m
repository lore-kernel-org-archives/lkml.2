Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab1HRTHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:07:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47482 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab1HRTHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:07:00 -0400
Date: Thu, 18 Aug 2011 20:06:59 +0100
To: richard@nod.at
Subject: Subject: [PATCH 48/91] um: make load_initrd() static, kill
 shared/initrd.h
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7vf-0007nd-MV@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/shared/initrd.h |   12 ------------
 arch/um/kernel/initrd.c         |    4 ++--
 2 files changed, 2 insertions(+), 14 deletions(-)
 delete mode 100644 arch/um/include/shared/initrd.h

diff --git a/arch/um/include/shared/initrd.h b/arch/um/include/shared/initrd.h
deleted file mode 100644
index 22673bc..0000000
--- a/arch/um/include/shared/initrd.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/*
- * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __INITRD_USER_H__
-#define __INITRD_USER_H__
-
-extern int load_initrd(char *filename, void *buf, int size);
-
-#endif
-
diff --git a/arch/um/kernel/initrd.c b/arch/um/kernel/initrd.c
index d386c75..10cc18f 100644
--- a/arch/um/kernel/initrd.c
+++ b/arch/um/kernel/initrd.c
@@ -7,12 +7,12 @@
 #include "linux/bootmem.h"
 #include "linux/initrd.h"
 #include "asm/types.h"
-#include "initrd.h"
 #include "init.h"
 #include "os.h"
 
 /* Changed by uml_initrd_setup, which is a setup */
 static char *initrd __initdata = NULL;
+static int load_initrd(char *filename, void *buf, int size);
 
 static int __init read_initrd(void)
 {
@@ -62,7 +62,7 @@ __uml_setup("initrd=", uml_initrd_setup,
 "    name of the file containing the image.\n\n"
 );
 
-int load_initrd(char *filename, void *buf, int size)
+static int load_initrd(char *filename, void *buf, int size)
 {
 	int fd, n;
 
-- 
1.7.2.5


