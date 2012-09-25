Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab2IYLFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:05:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37399 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2IYLFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:05:20 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH Resend] extcon: Fix return value in extcon_register_interest()
Date: Tue, 25 Sep 2012 16:31:19 +0530
Message-Id: <1348570879-24067-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Propagate the value returned from extcon_find_cable_index()
instead of -ENODEV. For readability, -EINVAL is returned in place of
the variable.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/extcon/extcon-class.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 946a318..6348b64 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -475,7 +475,7 @@ int extcon_register_interest(struct extcon_specific_cable_nb *obj,
 
 	obj->cable_index = extcon_find_cable_index(obj->edev, cable_name);
 	if (obj->cable_index < 0)
-		return -ENODEV;
+		return -EINVAL;
 
 	obj->user_nb = nb;
 
-- 
1.7.4.1

