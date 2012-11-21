Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab2KUFM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 00:12:27 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61229 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab2KUFM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 00:12:26 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/2] PM/devfreq: Fix incorrect argument in error message
Date: Wed, 21 Nov 2012 10:36:13 +0530
Message-Id: <1353474374-21591-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'g' is cast to the error return code. Hence gives the following error
which is fixed by this patch.

drivers/devfreq/devfreq.c:645 devfreq_remove_governor() error:
'g' dereferencing possible ERR_PTR()

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/devfreq/devfreq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 45e053e..83c2129 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -643,7 +643,7 @@ int devfreq_remove_governor(struct devfreq_governor *governor)
 	g = find_devfreq_governor(governor->name);
 	if (IS_ERR(g)) {
 		pr_err("%s: governor %s not registered\n", __func__,
-		       g->name);
+		       governor->name);
 		err = -EINVAL;
 		goto err_out;
 	}
-- 
1.7.4.1

