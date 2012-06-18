Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab2FRMIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:08:53 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:63370 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab2FRMIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:08:52 -0400
Message-Id: <201206181207.q5IC7Hbm029241@sw-eng-lt-dc-vm2>
From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Date: Mon, 18 Jun 2012 13:04:29 +0100
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Anthony Olech <Anthony.Olech@diasemi.com>
Subject: [PATCH] regmap: Fix work_buf switching for page update during virtual range access.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After page update, orginal work_buf has to be restored regardless of
the result.

Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
---
 drivers/base/regmap/regmap.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 83a0166..d912eb2 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -693,10 +693,11 @@ static int _regmap_select_page(struct regmap *map, unsigned int *reg,
 					range->selector_mask,
 					win_page << range->selector_shift,
 					&page_chg);
-			if (ret < 0)
-				return ret;
 
 			map->work_buf = orig_work_buf;
+
+			if (ret < 0)
+				return ret;
 		}
 
 		*reg = range->window_start + win_offset;
-- 
1.7.0.4

