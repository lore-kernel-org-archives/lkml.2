Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab2ENQcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:32:35 -0400
Received: from faui45.informatik.uni-erlangen.de ([131.188.34.45]:34646 "EHLO
	faui45.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257Ab2ENQce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:32:34 -0400
From: tartler@cs.fau.de
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Eric Miao <eric.y.miao@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@lists.cs.fau.de, Reinhard Tartler <siretart@tauware.de>,
        Reinhard Tartler <tartler@cs.fau.de>
Subject: [PATCH] mbxfb: unbreak compilation with CONFIG_FB_MBX_DEBUG
Date: Mon, 14 May 2012 18:31:51 +0200
Message-Id: <1337013111-7732-1-git-send-email-tartler@cs.fau.de>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Reinhard Tartler <siretart@tauware.de>

This patch adds missing function prototypes.

Signed-off-by: Reinhard Tartler <tartler@cs.fau.de>
---
 drivers/video/mbx/mbxfb.c |    3 +++
 1 file changed, 3 insertions(+)

This patch was found with tools developed in the VAMOS project:
http://www4.cs.fau.de/Research/VAMOS/

TBH, I'm not sure if this is the correct solution. However, I'd
appreciate if someone could confirm that this is a real bug.


diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/mbx/mbxfb.c
index 6ce3416..c2200ec 100644
--- a/drivers/video/mbx/mbxfb.c
+++ b/drivers/video/mbx/mbxfb.c
@@ -878,6 +878,9 @@ static int mbxfb_resume(struct platform_device *dev)
 #ifndef CONFIG_FB_MBX_DEBUG
 #define mbxfb_debugfs_init(x)	do {} while(0)
 #define mbxfb_debugfs_remove(x)	do {} while(0)
+#else
+void mbxfb_debugfs_init(struct fb_info *fbi);
+void mbxfb_debugfs_remove(struct fb_info *fbi);
 #endif
 
 #define res_size(_r) (((_r)->end - (_r)->start) + 1)
-- 
1.7.9.5

