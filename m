Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab0JTJI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 05:08:27 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54729 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0JTJI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 05:08:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=QqT/zfigi9vIlD/f5Tz4jPZ8qvutHRva7Kpr/ftQEHScK9FQblJQAaSWdnzKqQNuc4
         rDpqP+zIW/P0uUb5tsHr3ZLHyqGUEHW0qSKB7rPtG568lgkh3p+2MH+oRrpSyYBjrjRy
         vZj0lxx3qBFTL939pI0C0SeiJ5yfoH8/3U7Xw=
Subject: [PATCH] mfd: Add free max8998->ono irq in max8998_irq_exit()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>
Content-Type: text/plain
Date: Wed, 20 Oct 2010 17:09:56 +0800
Message-Id: <1287565796.7849.6.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/max8998-irq.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/max8998-irq.c b/drivers/mfd/max8998-irq.c
index 346fd29..45bfe77 100644
--- a/drivers/mfd/max8998-irq.c
+++ b/drivers/mfd/max8998-irq.c
@@ -250,6 +250,9 @@ int max8998_irq_init(struct max8998_dev *max8998)
 
 void max8998_irq_exit(struct max8998_dev *max8998)
 {
+	if (max8998->ono)
+		free_irq(max8998->ono, max8998);
+
 	if (max8998->irq)
 		free_irq(max8998->irq, max8998);
 }
-- 
1.7.2



