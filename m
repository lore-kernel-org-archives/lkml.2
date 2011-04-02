Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab1DBGU4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 02:20:56 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49142 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1DBGUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 02:20:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jt7vooYe+6fVokFQKTh7+CYbXCWp3Q0xiKixWUJ9Jn27Tt2a5MaDWIP8hlE/4UITlU
         cO7V/G0csdyx1eZASD7FF5T3EqL5zG2h1ztMSoPEEEZ9vJTqmyjsnAB4jIzV4WzxqW3b
         WdIfQQUqhvlwPGuw+gpB9Kz96tQHZI9lGYTos=
From: Liu Yuan <namei.unix@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] drivers, pch_dma: Fix uninitialized var before use
Date: Sat,  2 Apr 2011 14:20:47 +0800
Message-Id: <1301725248-5102-1-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yuan <tailai.ly@taobao.com>

In the function pdc_desc_get(), var 'i' is not
initialized before use. This patch fixes it.

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
---
 drivers/dma/pch_dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 8d8fef1..6eebc62 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -403,7 +403,7 @@ static struct pch_dma_desc *pdc_desc_get(struct pch_dma_chan *pd_chan)
 {
 	struct pch_dma_desc *desc, *_d;
 	struct pch_dma_desc *ret = NULL;
-	int i;
+	int i = 0;
 
 	spin_lock(&pd_chan->lock);
 	list_for_each_entry_safe(desc, _d, &pd_chan->free_list, desc_node) {
-- 
1.7.1

