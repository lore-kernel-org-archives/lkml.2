Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035Ab2JZRzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 13:55:53 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:53663 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894Ab2JZRzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 13:55:51 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] debugfs: pass NULL as the last parameter of debugfs_print_regs32()
Date: Sat, 27 Oct 2012 01:55:42 +0800
Message-Id: <1351274144-31591-1-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass NULL instead of empty string to debugfs_print_regs32() when
prefix is not used, according to the intention of the code.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 drivers/usb/dwc3/debugfs.c |    2 +-
 fs/debugfs/file.c          |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
index d4a30f1..6557272 100644
--- a/drivers/usb/dwc3/debugfs.c
+++ b/drivers/usb/dwc3/debugfs.c
@@ -382,7 +382,7 @@ static int dwc3_regdump_show(struct seq_file *s, void *unused)
 
 	seq_printf(s, "DesignWare USB3 Core Register Dump\n");
 	debugfs_print_regs32(s, dwc3_regs, ARRAY_SIZE(dwc3_regs),
-			     dwc->regs, "");
+			     dwc->regs, NULL);
 	return 0;
 }
 
diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index c5ca6ae..3915cc9 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -668,7 +668,8 @@ static int debugfs_show_regset32(struct seq_file *s, void *data)
 {
 	struct debugfs_regset32 *regset = s->private;
 
-	debugfs_print_regs32(s, regset->regs, regset->nregs, regset->base, "");
+	debugfs_print_regs32(s, regset->regs, regset->nregs,
+					regset->base, NULL);
 	return 0;
 }
 
-- 
1.7.9.5

