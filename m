Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab2C0HVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 03:21:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53449 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2C0HVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 03:21:51 -0400
Message-ID: <1332832905.9942.7.camel@phoenix>
Subject: [PATCH 4/4] regulator: Return microamps in wm8350_isink_get_current
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 27 Mar 2012 15:21:45 +0800
In-Reply-To: <1332832646.9942.1.camel@phoenix>
References: <1332832646.9942.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The values in isink_cur array are microamps.
The regulator core expects get_current_limit callback to return microamps.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8350-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index f29803c..c5f3b40 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -186,7 +186,7 @@ static int wm8350_isink_get_current(struct regulator_dev *rdev)
 		return 0;
 	}
 
-	return DIV_ROUND_CLOSEST(isink_cur[val], 100);
+	return isink_cur[val];
 }
 
 /* turn on ISINK followed by DCDC */
-- 
1.7.5.4



