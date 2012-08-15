Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab2HOGuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 02:50:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40337 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab2HOGuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 02:50:04 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH] extcon-max8997: remove usage of ret in max8997_muic_handle_charger_type_detach
Date: Wed, 15 Aug 2012 12:34:51 +0545
Message-Id: <1345013391-22521-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.12.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

actually we can do returns with error or success with out ret in this function,
so remove the ret variable, and reduce a very little (4byte) space on stack of this function

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 compile tested.

 drivers/extcon/extcon-max8997.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index ef9090a..77b66b0 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -271,8 +271,6 @@ out:
 static int max8997_muic_handle_charger_type_detach(
 				struct max8997_muic_info *info)
 {
-	int ret = 0;
-
 	switch (info->pre_charger_type) {
 	case MAX8997_CHARGER_TYPE_USB:
 		extcon_set_cable_state(info->edev, "USB", false);
@@ -290,11 +288,11 @@ static int max8997_muic_handle_charger_type_detach(
 		extcon_set_cable_state(info->edev, "Fast-charger", false);
 		break;
 	default:
-		ret = -EINVAL;
+		return -EINVAL;
 		break;
 	}
 
-	return ret;
+	return 0;
 }
 
 static int max8997_muic_handle_charger_type(struct max8997_muic_info *info,
-- 
1.7.12.rc2

