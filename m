Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab1GUGiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 02:38:20 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:36160 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab1GUGiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 02:38:16 -0400
From: jhbird.choi@samsung.com
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH] PM / OPP: Fix dev_opp initial value
Date: Thu, 21 Jul 2011 15:31:48 +0900
Message-Id: <1311229908-6046-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@samsung.com>

Dev_opp initial value shoule be ERR_PTR(),
IS_ERR() is used to check error.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/base/power/opp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 56a6899..d4ebf80 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -453,7 +453,7 @@ int opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
 static int opp_set_availability(struct device *dev, unsigned long freq,
 		bool availability_req)
 {
-	struct device_opp *tmp_dev_opp, *dev_opp = NULL;
+	struct device_opp *tmp_dev_opp, *dev_opp = ERR_PTR(-ENODEV);
 	struct opp *new_opp, *tmp_opp, *opp = ERR_PTR(-ENODEV);
 	int r = 0;
 
-- 
1.7.0

