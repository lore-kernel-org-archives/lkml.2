Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab2KUFZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 00:25:21 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:65229 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab2KUFZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 00:25:20 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] tty: vt: Remove redundant null check before kfree.
Date: Wed, 21 Nov 2012 10:49:07 +0530
Message-Id: <1353475147-28308-1-git-send-email-sachin.kamat@linaro.org>
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

