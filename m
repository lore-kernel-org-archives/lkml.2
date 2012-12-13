Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab2LMPWF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:22:05 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:35527 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab2LMPWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:22:02 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/18] power: ab8500_fg: flush sync on suspend
Date: Thu, 13 Dec 2012 15:21:27 +0000
Message-Id: <1355412102-14265-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
References: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Do flush sync on the fg workqueue at suspend instead of
just flushing it.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Reviewed-by: Johan BJORNSTEDT <johan.bjornstedt@stericsson.com>
---
 drivers/power/ab8500_fg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 828529e..b1bc893 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2436,7 +2436,7 @@ static int ab8500_fg_suspend(struct platform_device *pdev,
 {
 	struct ab8500_fg *di = platform_get_drvdata(pdev);
 
-	flush_delayed_work(&di->fg_periodic_work);
+	flush_delayed_work_sync(&di->fg_periodic_work);
 
 	/*
 	 * If the FG is enabled we will disable it before going to suspend
-- 
1.7.9.5

