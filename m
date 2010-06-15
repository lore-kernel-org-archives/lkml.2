Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab0FOApI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 20:45:08 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:16018 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754251Ab0FOApF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 20:45:05 -0400
From: Ryan Mallon <ryan@bluewatersys.com>
To: cbouatmailru@gmail.com
Cc: mike@compulab.co.il, linux-kernel@vger.kernel.org, vilensky@compulab.co.il,
       mike.rapoport@gmail.com, Ryan Mallon <ryan@bluewatersys.com>
Subject: [PATCH] ds2782: Fix ds2782_get_capacity return value
Date: Tue, 15 Jun 2010 12:44:59 +1200
Message-Id: <1276562699-4933-1-git-send-email-ryan@bluewatersys.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ds2782_get_capacity function should return 0 on success, not the
capacity value.

Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
---
 drivers/power/ds2782_battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index d762a0c..2afbeec 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -163,7 +163,7 @@ static int ds2782_get_capacity(struct ds278x_info *info, int *capacity)
 	if (err)
 		return err;
 	*capacity = raw;
-	return raw;
+	return 0;
 }
 
 static int ds2786_get_current(struct ds278x_info *info, int *current_uA)
-- 
1.5.5.1

