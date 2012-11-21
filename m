Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab2KUFMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 00:12:32 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61229 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2KUFM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 00:12:29 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 2/2] PM/devfreq: Fix return value in devfreq_remove_governor()
Date: Wed, 21 Nov 2012 10:36:14 +0530
Message-Id: <1353474374-21591-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353474374-21591-1-git-send-email-sachin.kamat@linaro.org>
References: <1353474374-21591-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the value obtained from the function instead of -EINVAL.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/devfreq/devfreq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 83c2129..2bd9ab0 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -644,7 +644,7 @@ int devfreq_remove_governor(struct devfreq_governor *governor)
 	if (IS_ERR(g)) {
 		pr_err("%s: governor %s not registered\n", __func__,
 		       governor->name);
-		err = -EINVAL;
+		err = PTR_ERR(g);
 		goto err_out;
 	}
 	list_for_each_entry(devfreq, &devfreq_list, node) {
-- 
1.7.4.1

