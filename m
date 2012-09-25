Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab2IYQPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:15:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095Ab2IYQOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:14:23 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 56/57] power: abx500_chargalg: Fix quick re-attach charger issue.
Date: Tue, 25 Sep 2012 10:12:53 -0600
Message-Id: <1348589574-25655-57-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Cooper <marcus.xm.cooper@stericsson.com>

The patch for 426250 added a change to check for the quick
re-attachment of the charger connection as an error in the
AB8500 HW meant that a quick detach/attach wouldn't be
detected.
This patch isolates the original change so that newer AB's
are not affected.

Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Martin SJOBLOM <martin.w.sjoblom@stericsson.com>
Reviewed-by: Hakan BERG <hakan.berg@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/abx500_chargalg.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index c8849af..7a81e4e 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -1299,11 +1299,12 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 	abx500_chargalg_check_charger_voltage(di);
 	charger_status = abx500_chargalg_check_charger_connection(di);
 
-	ret = abx500_chargalg_check_charger_enable(di);
-	if (ret < 0)
-		dev_err(di->dev, "Checking charger if enabled error: %d line: %d\n",
-				ret, __LINE__);
-
+	if (is_ab8500(di->parent)) {
+		ret = abx500_chargalg_check_charger_enable(di);
+		if (ret < 0)
+			dev_err(di->dev, "Checking charger is enabled error");
+			dev_err(di->dev, ": Returned Value %d\n", ret);
+	}
 	/*
 	 * First check if we have a charger connected.
 	 * Also we don't allow charging of unknown batteries if configured
-- 
1.7.5.4

