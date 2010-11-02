Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab0KBNz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 09:55:57 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:45186 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752874Ab0KBNzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 09:55:54 -0400
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Nov 2010 09:55:53 EDT
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: <linux-kernel@vger.kernel.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH v2] regulator: regulator disable supply fix
Date: Tue, 2 Nov 2010 14:55:34 +0100
Message-ID: <1288706135-30836-1-git-send-email-mattias.wallin@stericsson.com>
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
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f1d10c9..c625633 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1359,6 +1359,7 @@ static int _regulator_disable(struct regulator_dev *rdev,
 		struct regulator_dev **supply_rdev_ptr)
 {
 	int ret = 0;
+	*supply_rdev_ptr = NULL;
 
 	if (WARN(rdev->use_count <= 0,
 			"unbalanced disables for %s\n",
-- 
1.6.3.3

