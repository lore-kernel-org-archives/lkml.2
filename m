Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab1FHJNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:13:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:30636 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab1FHJNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:13:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,337,1304319600"; 
   d="scan'208";a="15463007"
Date: Wed, 8 Jun 2011 11:13:41 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Anirudh Ghayal <aghayal@codeaurora.org>
Subject: [PATCH 1/2] input: pmic8xxx-keypad: Do not use mfd_get_data()
Message-ID: <20110608091341.GJ2880@sortiz-mobl>
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
 drivers/input/keyboard/pmic8xxx-keypad.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/input/keyboard/pmic8xxx-keypad.c b/drivers/input/keyboard/pmic8xxx-keypad.c
index 40b02ae..6229c3e 100644
--- a/drivers/input/keyboard/pmic8xxx-keypad.c
+++ b/drivers/input/keyboard/pmic8xxx-keypad.c
@@ -520,7 +520,8 @@ static void pmic8xxx_kp_close(struct input_dev *dev)
  */
 static int __devinit pmic8xxx_kp_probe(struct platform_device *pdev)
 {
-	const struct pm8xxx_keypad_platform_data *pdata = mfd_get_data(pdev);
+	const struct pm8xxx_keypad_platform_data *pdata =
+					dev_get_platdata(&pdev->dev);
 	const struct matrix_keymap_data *keymap_data;
 	struct pmic8xxx_kp *kp;
 	int rc;
-- 
1.7.2.3

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
