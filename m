Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0KEDQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:16:25 -0400
Received: from mail.perches.com ([173.55.12.10]:4098 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab0KEDIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:08:48 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Dimitris Michailidis <dm@chelsio.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/49] drivers/net/cxgb4: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:42 -0700
Message-Id: <e208320e90dc0d7e77686cf8bf8131553f7a7b6e.1288925424.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/cxgb4/cxgb4_main.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/cxgb4/cxgb4_main.c b/drivers/net/cxgb4/cxgb4_main.c
index f17703f..b7758ce 100644
--- a/drivers/net/cxgb4/cxgb4_main.c
+++ b/drivers/net/cxgb4/cxgb4_main.c
@@ -868,12 +868,11 @@ out:	release_firmware(fw);
  */
 void *t4_alloc_mem(size_t size)
 {
-	void *p = kmalloc(size, GFP_KERNEL);
+	void *p = kzalloc(size, GFP_KERNEL);
 
 	if (!p)
-		p = vmalloc(size);
-	if (p)
-		memset(p, 0, size);
+		p = vzalloc(size);
+
 	return p;
 }
 
-- 
1.7.3.1.g432b3.dirty

