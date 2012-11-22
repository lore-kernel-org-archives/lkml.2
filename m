Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab2KVS0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:26:54 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40387 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2KVS0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:26:46 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, sachin.kamat@linaro.org
Subject: [PATCH Resend] tty: vt: Remove redundant null check before kfree.
Date: Thu, 22 Nov 2012 12:18:05 +0530
Message-Id: <1353566885-319-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kfree on a NULL pointer is a no-op.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/tty/vt/consolemap.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/vt/consolemap.c b/drivers/tty/vt/consolemap.c
index 2aaa0c2..248381b 100644
--- a/drivers/tty/vt/consolemap.c
+++ b/drivers/tty/vt/consolemap.c
@@ -410,10 +410,8 @@ static void con_release_unimap(struct uni_pagedir *p)
 		kfree(p->inverse_translations[i]);
 		p->inverse_translations[i] = NULL;
 	}
-	if (p->inverse_trans_unicode) {
-		kfree(p->inverse_trans_unicode);
-		p->inverse_trans_unicode = NULL;
-	}
+	kfree(p->inverse_trans_unicode);
+	p->inverse_trans_unicode = NULL;
 }
 
 /* Caller must hold the console lock */
-- 
1.7.4.1

