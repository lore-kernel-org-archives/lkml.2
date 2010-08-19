Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab0HSM55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 08:57:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37575 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab0HSM5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 08:57:55 -0400
Subject: [PATCH] uinput: add devname alias to allow module on-demand load
From: Kay Sievers <kay.sievers@vrfy.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 14:58:19 +0200
Message-ID: <1282222699.1236.21.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.6 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: uinput: add devname alias to allow module on-demand load

Recent modprobe and udev versions allow to create device nodes
for modules which are not loaded. Only the first access will cause
the in-kernel module loader to pull-in the module. Systems which
never access the device node will not needlessly load the module,
and no longer need init scripts or other facilities to unconditionally
load it.

Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/input/misc/uinput.c |    2 ++
 include/linux/miscdevice.h  |    1 +
 include/linux/uinput.h      |    1 -
 3 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -806,6 +806,8 @@ static struct miscdevice uinput_misc = {
 	.minor		= UINPUT_MINOR,
 	.name		= UINPUT_NAME,
 };
+MODULE_ALIAS_MISCDEV(UINPUT_MINOR);
+MODULE_ALIAS("devname:" UINPUT_NAME);
 
 static int __init uinput_init(void)
 {
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -33,6 +33,7 @@
 #define MWAVE_MINOR		219	/* ACP/Mwave Modem */
 #define MPT_MINOR		220
 #define MPT2SAS_MINOR		221
+#define UINPUT_MINOR		223
 #define HPET_MINOR		228
 #define FUSE_MINOR		229
 #define KVM_MINOR		232
--- a/include/linux/uinput.h
+++ b/include/linux/uinput.h
@@ -37,7 +37,6 @@
 #define UINPUT_VERSION		3
 
 #ifdef __KERNEL__
-#define UINPUT_MINOR		223
 #define UINPUT_NAME		"uinput"
 #define UINPUT_BUFFER_SIZE	16
 #define UINPUT_NUM_REQUESTS	16


