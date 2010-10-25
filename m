Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629Ab0JYXz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:55:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39380 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758566Ab0JYXz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:55:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=CjAeFd5SEThlSwg5V+HKls7kpMKORmXKA2Plt/cvW6PwHFY5jY/cbe6kPaV4NmN7+F
         fA7gX/9PvFoKHcd1yjUGiC/EsdD++g9zJhOP3gTeqSECQG9W/4Oui1wXlFq0tuD6o5Ef
         m55+h14/vTT/lmnbCedprN3gXTaqXzTB9WAr8=
Subject: [PATCH 2/2 v2] regulator: max8952 - fix max8952_set_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 07:55:54 +0800
Message-ID: <1288050954.2323.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, vid is declared as u8,
then "vid == -1" is always false, and "vid >= 0" is always true.
Thus change it to s8.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8952.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index f2af0b1..d5cc051 100644
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
-- 
1.7.0.4



