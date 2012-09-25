Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab2IYQYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:24:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757518Ab2IYQNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:25 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 12/57] power: ab8500_fg: balance IRQ enable
Date: Tue, 25 Sep 2012 10:12:09 -0600
Message-Id: <1348589574-25655-13-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Andersson <rickard.andersson@stericsson.com>

In case of time out error IRQ needs to be disabled
otherwise we will get unbalanced enable/disable pairs.

Signed-off-by: Rickard Andersson <rickard.andersson@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_fg.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 7af616c..492f6bf 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -746,6 +746,7 @@ int ab8500_fg_inst_curr_blocking(struct ab8500_fg *di)
 	dev_dbg(di->dev, "%s instant current: %d", __func__, res);
 	return res;
 fail:
+	disable_irq(di->irq);
 	mutex_unlock(&di->cc_lock);
 	return ret;
 }
-- 
1.7.5.4

