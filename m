Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab2KTOpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:45:13 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:60329 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab2KTOpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:45:10 -0500
X-Authority-Analysis: v=2.0 cv=OOOlLFmB c=1 sm=0 a=QKCpt3RAcCy1PgeoOVilzg==:17 a=2oGSFm5vdZwA:10 a=5xodDPq3oQwA:10 a=649elMfuWG0A:10 a=svWV0_fRAAAA:8 a=V42lzKT-7ucA:10 a=VwQbUJbxAAAA:8 a=wT8LoILcmU6lcX3Kn-YA:9 a=OSKtzXyDyhAA:10 a=QKCpt3RAcCy1PgeoOVilzg==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 24.73.230.86
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-kernel@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>, stable@vger.kernel.org
Subject: [PATCH] [firmware_class]  Fix compile with no builtin firmware
Date: Tue, 20 Nov 2012 09:45:14 -0500
Message-Id: <1353422714-18327-1-git-send-email-pizza@shaftnet.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling the firmware loader, the builtin firmware functions were
erroneously compiled as they were wrapped with CONFIG_FW_LOADER instead
of CONFIG_FIRMWARE_IN_KERNEL.  This is normally harmless, except when
there was actually no firmware to compile into the kernel, causing the
build to fail with a linking error:

drivers/built-in.o: In function `release_firmware':
(.text+0x192e2): undefined reference to `__end_builtin_fw'
drivers/built-in.o: In function `release_firmware':
(.text+0x19304): undefined reference to `__end_builtin_fw'
drivers/built-in.o: In function `_request_firmware':
firmware_class.c:(.text+0x1986c): undefined reference to `__end_builtin_fw'
firmware_class.c:(.text+0x19886): undefined reference to `__end_builtin_fw'
firmware_class.c:(.text+0x19a98): undefined reference to `__end_builtin_fw'
drivers/built-in.o: In function `release_firmware':
(.text+0x192dc): undefined reference to `__start_builtin_fw'
drivers/built-in.o: In function `_request_firmware':
firmware_class.c:(.text+0x19860): undefined reference to `__start_builtin_fw'
firmware_class.c:(.text+0x19a8a): undefined reference to `__start_builtin_fw'

This trivial patch fixes this oversight.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
CC: stable@vger.kernel.org
---
 drivers/base/firmware_class.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 8945f4e..3474e7f 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -38,7 +38,7 @@ MODULE_LICENSE("GPL");
 
 /* Builtin firmware support */
 
-#ifdef CONFIG_FW_LOADER
+#ifdef CONFIG_FIRMWARE_IN_KERNEL
 
 extern struct builtin_fw __start_builtin_fw[];
 extern struct builtin_fw __end_builtin_fw[];
-- 
1.7.11.7

