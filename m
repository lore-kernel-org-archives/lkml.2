Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab2DCGOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 02:14:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48297 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2DCGOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 02:14:03 -0400
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lars Ellenberg <drbd-dev@lists.linbit.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, drbd-user@lists.linbit.com
Subject: =?UTF-8?q?=5BPatch=5D=20drbd=3A=20check=20MODULE=20for=20THIS=5FMODULE?=
Date: Tue,  3 Apr 2012 14:13:36 +0800
Message-Id: <1333433616-8315-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

THIS_MODULE is NULL only when drbd is compiled as built-in,
so the #ifdef CONFIG_MODULES should be #ifdef MODULE instead.

This fixes the warning:

drivers/block/drbd/drbd_main.c: In function ‘drbd_buildtag’:
drivers/block/drbd/drbd_main.c:4187:24: warning: the comparison will always evaluate as ‘true’ for the address of ‘__this_module’ will never be NULL [-Waddress]

Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 211fc44..96c432f 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -4183,12 +4183,11 @@ const char *drbd_buildtag(void)
 	static char buildtag[38] = "\0uilt-in";
 
 	if (buildtag[0] == 0) {
-#ifdef CONFIG_MODULES
-		if (THIS_MODULE != NULL)
-			sprintf(buildtag, "srcversion: %-24s", THIS_MODULE->srcversion);
-		else
+#ifdef MODULE
+		sprintf(buildtag, "srcversion: %-24s", THIS_MODULE->srcversion);
+#else
+		buildtag[0] = 'b';
 #endif
-			buildtag[0] = 'b';
 	}
 
 	return buildtag;
