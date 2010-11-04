Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab0KDPLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:11:00 -0400
Received: from smtp.nokia.com ([147.243.128.24]:45989 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751554Ab0KDPK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:10:59 -0400
X-Greylist: delayed 2335 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2010 11:10:59 EDT
From: Heikki Krogerus <heikki.krogerus@nokia.com>
To: cbouatmailru@gmail.com
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, ameya.palande@nokia.com,
        markus.lehtonen@nokia.com, heikki.krogerus@nokia.com
Subject: [PATCH 3/4] power_supply: isp1704: Set isp->dev before anything needs it
Date: Thu,  4 Nov 2010 16:31:48 +0200
Message-Id: <1288881109-18222-4-git-send-email-heikki.krogerus@nokia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288881109-18222-1-git-send-email-heikki.krogerus@nokia.com>
References: <1288881109-18222-1-git-send-email-heikki.krogerus@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

isp1704_test_ulpi() is the first place that needs isp->dev
member, so it must be set before calling the function.

Signed-off-by: Heikki Krogerus <heikki.krogerus@nokia.com>
---
 drivers/power/isp1704_charger.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
index 10c7cc5..77c11f1 100644
--- a/drivers/power/isp1704_charger.c
+++ b/drivers/power/isp1704_charger.c
@@ -391,13 +391,13 @@ static int __devinit isp1704_charger_probe(struct platform_device *pdev)
 	if (!isp->otg)
 		goto fail0;
 
+	isp->dev = &pdev->dev;
+	platform_set_drvdata(pdev, isp);
+
 	ret = isp1704_test_ulpi(isp);
 	if (ret < 0)
 		goto fail1;
 
-	isp->dev = &pdev->dev;
-	platform_set_drvdata(pdev, isp);
-
 	isp->psy.name		= "isp1704";
 	isp->psy.type		= POWER_SUPPLY_TYPE_USB;
 	isp->psy.properties	= power_props;
-- 
1.7.1

