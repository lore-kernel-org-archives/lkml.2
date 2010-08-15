Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab0HORMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 13:12:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59426 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab0HORMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 13:12:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pYw9pld6jy5hVDKYpHgerLZozI92ahsJaSewjnaOyeHZfh+bLw5O24Sl+TTs2kU8bv
         eGIezxK3wzhrkP0qXKpA8I96BtAgCMjtdD7CNjTNkZuYg8BT+9scnlAdmWByMIcy3VbW
         2LWvQGQa4tqnYRzmXIwvU/nZdWXV5PGlhHlL8=
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] init/main.c: add __force markup when casts to a __user pointer
Date: Sun, 15 Aug 2010 18:53:18 +0900
Message-Id: <1281865998-7784-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add __force markup when casts to a __user address space pointer. This removes
following sparse warnings:

 init/main.c:900:23: warning: cast adds address space to expression (<asn:1>)
 init/main.c:913:25: warning: cast adds address space to expression (<asn:1>)

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 init/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index b06b8f2..5a0be5c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -897,7 +897,7 @@ static int __init kernel_init(void * unused)
 	do_basic_setup();
 
 	/* Open the /dev/console on the rootfs, this should never fail */
-	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
+	if (sys_open((const char __user __force *) "/dev/console", O_RDWR, 0) < 0)
 		printk(KERN_WARNING "Warning: unable to open an initial console.\n");
 
 	(void) sys_dup(0);
@@ -910,7 +910,7 @@ static int __init kernel_init(void * unused)
 	if (!ramdisk_execute_command)
 		ramdisk_execute_command = "/init";
 
-	if (sys_access((const char __user *) ramdisk_execute_command, 0) != 0) {
+	if (sys_access((const char __user __force *) ramdisk_execute_command, 0) != 0) {
 		ramdisk_execute_command = NULL;
 		prepare_namespace();
 	}
-- 
1.7.0.4

