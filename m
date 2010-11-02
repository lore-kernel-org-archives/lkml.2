Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab0KBMXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 08:23:15 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:57373 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872Ab0KBMXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 08:23:07 -0400
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: <linux-kernel@vger.kernel.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH] regulator: regulator disable supply fix
Date: Tue, 2 Nov 2010 13:22:29 +0100
Message-ID: <1288700549-28535-1-git-send-email-mattias.wallin@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a disable failure when regulator supply is used.
A while loop in regulator disable checks for supply pointer != NULL
but the pointer is not always updated, resulting in the while loop
running too many times causing a disable failure.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
---
 drivers/regulator/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f1d10c9..dc7d36e 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1424,6 +1424,7 @@ int regulator_disable(struct regulator *regulator)
 	/* decrease our supplies ref count and disable if required */
 	while (supply_rdev != NULL) {
 		rdev = supply_rdev;
+		supply_rdev = NULL;
 
 		mutex_lock(&rdev->mutex);
 		_regulator_disable(rdev, &supply_rdev);
-- 
1.6.3.3

