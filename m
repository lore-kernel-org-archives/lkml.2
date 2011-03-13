Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab1CMSxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 14:53:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44613 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab1CMSxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 14:53:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gF7GKaz5/xPA1mLubUa8v+KCzvvFt+reiphFb/oCfEMwBTlz4NOHePQOLQtgQrqJlp
         J1l/iqBhQh0N9bVd77WuSQv0Je115QagY8yPLu7Gd5krAxDg3o/ssJ9wMvPb9NoLWLkX
         AjaxltrgR36p3WCgtpGIX3mXM8w5yiHQ1NDvs=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: mchehab@redhat.com
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] staging: altera-stapl: fix memory leaks
Date: Sun, 13 Mar 2011 21:52:58 +0300
Message-Id: <1300042378-24183-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free resources before exit.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/altera-stapl/altera.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/altera-stapl/altera.c b/drivers/staging/altera-stapl/altera.c
index 05aad35..fcc7650 100644
--- a/drivers/staging/altera-stapl/altera.c
+++ b/drivers/staging/altera-stapl/altera.c
@@ -2435,11 +2435,16 @@ int altera_init(struct altera_config *config, const struct firmware *fw)
 	if (!key)
 		return -ENOMEM;
 	value = kzalloc(257 * sizeof(char), GFP_KERNEL);
-	if (!value)
+	if (!value) {
+		kfree(key);
 		return -ENOMEM;
+	}
 	astate = kzalloc(sizeof(struct altera_state), GFP_KERNEL);
-	if (!astate)
+	if (!astate) {
+		kfree(value);
+		kfree(key);
 		return -ENOMEM;
+	}
 
 	astate->config = config;
 	if (!astate->config->jtag_io) {
-- 
1.7.4.1

