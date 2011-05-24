Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab1EXNDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:03:44 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:64766 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab1EXNDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:03:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kp7qUGHIfowB28swpkpE/M2mO9CdpKedWrxsKUboQcpbO/iwTibkfwtrQPFXlvN823
         xwrX7+bwjKV8AjpMy0/zzENlP7teFjDMvjhGzaBRGkXnuuVGgv+nI1zXaacwnOGBTbeZ
         lmLpnjEpNTLwP9ribyTxXOtuDJH/8gNf3VsIo=
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Chris Ball <cjb@laptop.org>, Grant Likely <grant.likely@secretlab.ca>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] drivers:mmc:add the NO_IRQ define to of_mmc_spi.c
Date: Tue, 24 May 2011 21:03:22 +0800
Message-Id: <1306242202-9252-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For archs that don't support NO_IRQ (such as mips),
provide a dummy value. Fix the build error for mips.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 drivers/mmc/host/of_mmc_spi.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/of_mmc_spi.c b/drivers/mmc/host/of_mmc_spi.c
index e2aecb7..ab66f24 100644
--- a/drivers/mmc/host/of_mmc_spi.c
+++ b/drivers/mmc/host/of_mmc_spi.c
@@ -25,6 +25,11 @@
 #include <linux/mmc/core.h>
 #include <linux/mmc/host.h>
 
+/* For archs that don't support NO_IRQ (such as mips), provide a dummy value */
+#ifndef NO_IRQ
+#define NO_IRQ 0
+#endif
+
 MODULE_LICENSE("GPL");
 
 enum {
-- 
1.7.4.1

