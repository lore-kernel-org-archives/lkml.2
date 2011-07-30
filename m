Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab1G3MCE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 08:02:04 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:45006 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab1G3MCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 08:02:01 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] tty: clearify structure initializer in notify_write()
Date: Sat, 30 Jul 2011 14:01:59 +0200
Message-Id: <1312027319-1402-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though this is valid C we should not mix C99 initializers with
obfuscated ANSI C. Stick to C99 and initialize c by its name.

Found by clang:
drivers/tty/vt/vt.c:262:55: warning: explicitly assigning a variable of
type 'unsigned int' to itself [-Wself-assign]
    struct vt_notifier_param param = { .vc = vc, unicode = unicode };
                                                 ~~~~~~~ ^ ~~~~~~~

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 drivers/tty/vt/vt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index b3915b7..e716839 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -259,7 +259,7 @@ EXPORT_SYMBOL_GPL(unregister_vt_notifier);
 
 static void notify_write(struct vc_data *vc, unsigned int unicode)
 {
-	struct vt_notifier_param param = { .vc = vc, unicode = unicode };
+	struct vt_notifier_param param = { .vc = vc, .c = unicode };
 	atomic_notifier_call_chain(&vt_notifier_list, VT_WRITE, &param);
 }
 
-- 
1.5.6.5

