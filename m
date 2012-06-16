Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab2FPNZX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 09:25:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52568 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855Ab2FPNZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 09:25:22 -0400
Message-ID: <1339853111.4965.1.camel@phoenix>
Subject: [PATCH] extcon: max8997: Add missing kfree for info->edev in
 max8997_muic_remove()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 16 Jun 2012 21:25:11 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

extcon_dev_unregister(info->edev) doest not free info->edev, we need to call
kfree(info->edev) here.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/extcon/extcon-max8997.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 5ecf176..a4ed30b 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -514,6 +514,7 @@ static int __devexit max8997_muic_remove(struct platform_device *pdev)
 
 	extcon_dev_unregister(info->edev);
 
+	kfree(info->edev);
 	kfree(info);
 
 	return 0;
-- 
1.7.9.5



