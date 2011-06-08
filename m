Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab1FHJPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:15:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:24465 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498Ab1FHJPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:15:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,337,1304319600"; 
   d="scan'208";a="15463297"
Date: Wed, 8 Jun 2011 11:15:01 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Anirudh Ghayal <aghayal@codeaurora.org>
Subject: [PATCH 2/2] input: pmic8xxx-pwrkey: Do not use mfd_get_data()
Message-ID: <20110608091501.GK2880@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mfd_get_data() has been removed from the MFD API.

Cc: Anirudh Ghayal <aghayal@codeaurora.org>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/input/misc/pmic8xxx-pwrkey.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/pmic8xxx-pwrkey.c b/drivers/input/misc/pmic8xxx-pwrkey.c
index 97e07e7..b3cfb9c 100644
--- a/drivers/input/misc/pmic8xxx-pwrkey.c
+++ b/drivers/input/misc/pmic8xxx-pwrkey.c
@@ -90,7 +90,8 @@ static int __devinit pmic8xxx_pwrkey_probe(struct platform_device *pdev)
 	unsigned int delay;
 	u8 pon_cntl;
 	struct pmic8xxx_pwrkey *pwrkey;
-	const struct pm8xxx_pwrkey_platform_data *pdata = mfd_get_data(pdev);
+	const struct pm8xxx_pwrkey_platform_data *pdata =
+					dev_get_platdata(&pdev->dev);
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "power key platform data not supplied\n");
-- 
1.7.2.3

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
