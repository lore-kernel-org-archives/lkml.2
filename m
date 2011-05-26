Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab1EZGs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 02:48:26 -0400
Received: from mail.active-venture.com ([67.228.131.195]:60568 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab1EZGsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 02:48:25 -0400
X-Virus-Scan: Scanned by ClamAV 0.94.2 (no viruses);
  Thu, 26 May 2011 01:48:24 -0500
X-Originating-IP: 68.125.166.242
From: Guenter Roeck <linux@roeck-us.net>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] dma: Initialize uninitialized variable
Date: Wed, 25 May 2011 23:48:36 -0700
Message-Id: <1306392516-5906-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uninitialized variable results in random debug output.
Fix by initializing to 0.

This commit fixes the following warning:

drivers/dma/pch_dma.c: In function pdc_desc_get:
drivers/dma/pch_dma.c:406: warning: i may be used uninitialized in this function

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
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

