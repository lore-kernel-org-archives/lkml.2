Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab1CJCnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 21:43:51 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65349 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab1CJCnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 21:43:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wVAxAGPu34wU1Z0ke3Lk1dFdxdiHu+4bR+cf2TLipcx4wWt/2Q12BBypInD3uUqCCG
         Rkbd6qk/eXShs13Hkm6VYw37pSGB1qOJ+dJo3YpjKh3N/2OH2mglTsJBuqgSfmovhJWy
         l3rZKgTu5AEZ1lLyglIwhifunjrfueaIAOrGw=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>,
        "Igor M. Liplianin" <liplianin@netup.ru>
Subject: [PATCH next 1/6] staging: altera-stapl: fix memory leaks
Date: Thu, 10 Mar 2011 05:43:03 +0300
Message-Id: <1299724988-25351-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free resources before exit.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Igor M. Liplianin <liplianin@netup.ru>
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

