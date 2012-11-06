Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab2KFLrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:47:24 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:52313 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab2KFLrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:47:22 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: sachin.kamat@linaro.org, patches@linaro.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 1/1] extcon: Redo: Fix return value in extcon_register_interest()
Date: Tue,  6 Nov 2012 17:11:46 +0530
Message-Id: <1352202106-12007-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4f2de3bf (extcon : register for cable interest by cable name)
reverted the change done in commit 5cd3c277.
Re-doing it.

Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/extcon/extcon-class.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index d398821..8e577ed 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -472,7 +472,7 @@ int extcon_register_interest(struct extcon_specific_cable_nb *obj,
 
 		obj->cable_index = extcon_find_cable_index(obj->edev, cable_name);
 		if (obj->cable_index < 0)
-			return -ENODEV;
+			return -EINVAL;
 
 		obj->user_nb = nb;
 
-- 
1.7.4.1

