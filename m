Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab0JYCOm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 22:14:42 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41360 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab0JYCOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 22:14:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Cm33/S70u2J+hmRrhfU0Y5Qm3wLfB8nNZZGlJsYHhdcNY/du+uJ7egxsvKKqlWOdI/
         ibc9yhLbmbl9G514xSUmCWS26wcYND2yvgCrhxdXzbjtxwNEBGSv7rGLSxZfunxy7waX
         XO7yZ+iO5Gs+8zzkQcnMJI60Q/pTKhkUL+IoQ=
Subject: [PATCH 2/2] regulator: max8952 - fix max8952_set_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
In-Reply-To: <1287972667.23608.2.camel@mola>
References: <1287972667.23608.2.camel@mola>
Content-Type: text/plain
Date: Mon, 25 Oct 2010 10:17:06 +0800
Message-Id: <1287973026.23608.6.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, vid is declared as u8,
then "vid == -1" is always false, and "vid >= 0" is always true.
Thus change it to s8.

vid is always less than MAX8952_NUM_DVS_MODE in current implementation,
thus remove the cheking for "vid < MAX8952_NUM_DVS_MODE".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8952.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index 7d6aacf..5b4601e 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -136,7 +136,7 @@ static int max8952_set_voltage(struct regulator_dev *rdev,
 				int min_uV, int max_uV)
 {
 	struct max8952_data *max8952 = rdev_get_drvdata(rdev);
-	u8 vid = -1, i;
+	s8 vid = -1, i;
 
 	if (!gpio_is_valid(max8952->pdata->gpio_vid0) ||
 			!gpio_is_valid(max8952->pdata->gpio_vid0)) {
@@ -153,7 +153,7 @@ static int max8952_set_voltage(struct regulator_dev *rdev,
 				vid = i;
 	}
 
-	if (vid >= 0 && vid < MAX8952_NUM_DVS_MODE) {
+	if (vid >= 0) {
 		max8952->vid0 = (vid % 2 == 1);
 		max8952->vid1 = (((vid >> 1) % 2) == 1);
 		gpio_set_value(max8952->pdata->gpio_vid0, max8952->vid0);
-- 
1.7.2



