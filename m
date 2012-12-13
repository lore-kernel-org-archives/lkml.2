Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab2LMPZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:25:04 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58697 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab2LMPWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:22:09 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, Rickard Andersson <rickard.andersson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/18] power: ab8500_fg: balance IRQ enable
Date: Thu, 13 Dec 2012 15:21:31 +0000
Message-Id: <1355412102-14265-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
References: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Andersson <rickard.andersson@stericsson.com>

In case of time out error IRQ needs to be disabled
otherwise we will get unbalanced enable/disable pairs.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Rickard Andersson <rickard.andersson@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_fg.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 41eace3..c24dba1 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -745,6 +745,7 @@ int ab8500_fg_inst_curr_blocking(struct ab8500_fg *di)
 	dev_dbg(di->dev, "%s instant current: %d", __func__, res);
 	return res;
 fail:
+	disable_irq(di->irq);
 	mutex_unlock(&di->cc_lock);
 	return ret;
 }
-- 
1.7.9.5

