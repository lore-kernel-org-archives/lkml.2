Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab2H2BaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 21:30:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41442 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab2H2BaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 21:30:24 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 2/2] staging/rts_pstor: Use pr_ printks in debug.h
Date: Wed, 29 Aug 2012 10:30:15 +0900
Message-Id: <1346203816-5975-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346203766-5939-1-git-send-email-yamanetoshi@gmail.com>
References: <1346203766-5939-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
-WARNING: Prefer pr_debug(... to printk(KERN_DEBUG, ...

And added pr_fmt.

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/debug.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rts_pstor/debug.h b/drivers/staging/rts_pstor/debug.h
index ab305be..e6b3425 100644
--- a/drivers/staging/rts_pstor/debug.h
+++ b/drivers/staging/rts_pstor/debug.h
@@ -24,13 +24,13 @@
 #ifndef __REALTEK_RTSX_DEBUG_H
 #define __REALTEK_RTSX_DEBUG_H
 
-#include <linux/kernel.h>
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#define RTSX_STOR "rts_pstor: "
+#include <linux/kernel.h>
 
 #ifdef CONFIG_RTS_PSTOR_DEBUG
-#define RTSX_DEBUGP(x...) printk(KERN_DEBUG RTSX_STOR x)
-#define RTSX_DEBUGPN(x...) printk(KERN_DEBUG x)
+#define RTSX_DEBUGP(x...) pr_debug(x)
+#define RTSX_DEBUGPN(x...) pr_debug(x)
 #define RTSX_DEBUGPX(x...) printk(x)
 #define RTSX_DEBUG(x) x
 #else
-- 
1.7.9.5

