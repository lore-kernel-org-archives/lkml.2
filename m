Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab2DWJiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:38:16 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:58524 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872Ab2DWJiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:38:15 -0400
From: Ulf Hansson <ulf.hansson@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Cc: Mattias Wallin <mattias.wallin@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Ulf Hansson <ulf.hansson@stericsson.com>
Subject: [PATCH] regulator: core: Keep boot_on regulators powered during init
Date: Mon, 23 Apr 2012 11:37:53 +0200
Message-ID: <1335173873-24301-1-git-send-email-ulf.hansson@stericsson.com>
X-Mailer: git-send-email 1.7.9
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regulators which has boot_on constraints set, will now remain
powered after regulator_init_complete is done.

In this case we leave the enable->disable operation to be
handled by the regulator consumer instead.

Signed-off-by: Ulf Hansson <ulf.hansson@stericsson.com>
---
 drivers/regulator/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 1caada2..c5af6d2 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3393,7 +3393,7 @@ static int __init regulator_init_complete(void)
 		ops = rdev->desc->ops;
 		c = rdev->constraints;
 
-		if (!ops->disable || (c && c->always_on))
+		if (!ops->disable || (c && (c->always_on || c->boot_on)))
 			continue;
 
 		mutex_lock(&rdev->mutex);
-- 
1.7.9

