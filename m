Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab2JUE7R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 00:59:17 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38223 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2JUE7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 00:59:16 -0400
From: anish kumar <anish198519851985@gmail.com>
To: gregkh@linuxfoundation.org, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com
Cc: linux-kernel@vger.kernel.org, anish kumar <anish198519851985@gmail.com>
Subject: [PATCH] extcon: trivial: kfree missed from remove path
Date: Sun, 21 Oct 2012 13:58:59 +0900
Message-Id: <1350795539-13206-1-git-send-email-anish198519851985@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

Extcon core doesn't free the memory when we do unregister.
Kfree is added in the remove path as it was missing.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 drivers/extcon/extcon-max77693.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index e21387e..67bc9ab 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -762,6 +762,7 @@ static int __devexit max77693_muic_remove(struct platform_device *pdev)
 		free_irq(muic_irqs[i].virq, info);
 	cancel_work_sync(&info->irq_work);
 	extcon_dev_unregister(info->edev);
+	kfree(info->edev);
 	kfree(info);
 
 	return 0;
-- 
1.7.1

