Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1FCFPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 01:15:36 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63622 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1FCFPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 01:15:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iEv1xdkSob+1uaZ+2zeNPqjZba5GKb/bdZED2iaGw/7yn5ZNnm2DYZd8QpCqNQ3NIB
         5jugxn9bcMd5vmvUvKvM1BJ0gXkjgae56CcSe12gN24FIZYc7BiLx8An3ylAVFNQT4CW
         iUIoLKh5usiCrmRzVboFlHpmGspuSRUTSquMI=
Subject: [PATCH 2/2] mtd: fsmc_nand: fix a memory leak
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Viresh Kumar <viresh.kumar@st.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-mtd@lists.infradead.org
In-Reply-To: <1307078050.4167.1.camel@phoenix>
References: <1307078050.4167.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 13:15:30 +0800
Message-ID: <1307078130.4167.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fsmc_nand_remove, we should call nand_release instead of
mtd_device_unregister to properly free bad block table memory
and bad block descriptor memory.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mtd/nand/fsmc_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index e9b275a..8a5f1aa 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -822,7 +822,7 @@ static int fsmc_nand_remove(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 
 	if (host) {
-		mtd_device_unregister(&host->mtd);
+		nand_release(&host->mtd);
 		clk_disable(host->clk);
 		clk_put(host->clk);
 
-- 
1.7.4.1



