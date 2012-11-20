Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab2KTF3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 00:29:08 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65000 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2KTF3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 00:29:03 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 3/7] extcon: Fix return value in extcon-class.c
Date: Tue, 20 Nov 2012 10:52:39 +0530
Message-Id: <1353388963-23761-4-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353388963-23761-1-git-send-email-sachin.kamat@linaro.org>
References: <1353388963-23761-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the value obtained from the function extcon_register_interest
instead of -EINVAL.

Silences the following warning:
drivers/extcon/extcon-class.c:475 extcon_register_interest() info:
why not propagate 'obj->cable_index' from extcon_find_cable_index()
instead of -22?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/extcon/extcon-class.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 8e577ed..60adc04 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -472,7 +472,7 @@ int extcon_register_interest(struct extcon_specific_cable_nb *obj,
 
 		obj->cable_index = extcon_find_cable_index(obj->edev, cable_name);
 		if (obj->cable_index < 0)
-			return -EINVAL;
+			return obj->cable_index;
 
 		obj->user_nb = nb;
 
-- 
1.7.4.1

