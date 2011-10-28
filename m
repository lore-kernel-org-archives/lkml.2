Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742Ab1J1W4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 18:56:40 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58212 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935Ab1J1W4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 18:56:39 -0400
From: jhbird.choi@gmail.com
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Jonghwan Choi <jhbird.choi@gmail.com>
Subject: [PATCH] max8997_charger: Fix unsigned value for less than zero
Date: Sat, 29 Oct 2011 07:56:32 +0900
Message-Id: <1319842592-11334-1-git-send-email-jhbird.choi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@gmail.com>

The 'val' is a 'unsigned char', so it is never less than zero.

Signed-off-by: Jonghwan Choi <jhbird.choi@gmail.com>
---
 drivers/power/max8997_charger.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/max8997_charger.c b/drivers/power/max8997_charger.c
index ffc5033..a5eb3ed 100644
--- a/drivers/power/max8997_charger.c
+++ b/drivers/power/max8997_charger.c
@@ -97,7 +97,7 @@ static __devinit int max8997_battery_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	if (pdata->eoc_mA) {
-		u8 val = (pdata->eoc_mA - 50) / 10;
+		int val = (pdata->eoc_mA - 50) / 10;
 		if (val < 0)
 			val = 0;
 		if (val > 0xf)
-- 
1.7.0.4

