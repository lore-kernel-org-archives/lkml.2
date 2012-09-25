Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab2IYHCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 03:02:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50639 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2IYHCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 03:02:34 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH] extcon: Fix return value in extcon_register_interest()
Date: Tue, 25 Sep 2012 12:28:55 +0530
Message-Id: <1348556335-14686-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the value obtained from extcon_find_cable_index()
instead of -ENODEV.

Fixes the following smatch info:
drivers/extcon/extcon-class.c:478 extcon_register_interest() info:
why not propagate 'obj->cable_index' from extcon_find_cable_index()
instead of -19?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/extcon/extcon-class.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 946a318..e996800 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -475,7 +475,7 @@ int extcon_register_interest(struct extcon_specific_cable_nb *obj,
 
 	obj->cable_index = extcon_find_cable_index(obj->edev, cable_name);
 	if (obj->cable_index < 0)
-		return -ENODEV;
+		return obj->cable_index;
 
 	obj->user_nb = nb;
 
-- 
1.7.4.1

