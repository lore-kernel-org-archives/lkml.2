Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab2J0IFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 04:05:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32831 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab2J0IFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 04:05:48 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@gnudd.com>
Subject: [PATCH 1/5] debugfs: pass NULL as the last parameter of debugfs_print_regs32()
Date: Sat, 27 Oct 2012 16:05:25 +0800
Message-Id: <1351325129-10097-1-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If 'prefix' is not used, pass NULL instead of empty string as the
last parameter of debugfs_print_regs32().

Cc: Alessandro Rubini <rubini@gnudd.com>

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---

This function is only used (twice) by the author of it, and the
'prefix' feature is never used. But it's a well-documented debugfs
API. It's added one year ago and appeared in many documents. I still
prefer to let this API stay unchanged and treat the empty string as
typo.

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
index c5ca6ae..6bdd450 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -668,7 +668,8 @@ static int debugfs_show_regset32(struct seq_file *s, void *data)
 {
 	struct debugfs_regset32 *regset = s->private;
 
-	debugfs_print_regs32(s, regset->regs, regset->nregs, regset->base, "");
+	debugfs_print_regs32(s, regset->regs, regset->nregs,
+			regset->base, NULL);
 	return 0;
 }
 
-- 
1.7.9.5

