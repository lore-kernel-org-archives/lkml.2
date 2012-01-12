Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab2ALMpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 07:45:16 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52771 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab2ALMpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 07:45:14 -0500
Message-ID: <1326372302.5729.1.camel@phoenix>
Subject: [PATCH] power_supply: Add MODULE_DEVICE_TABLE for lp8727 charger
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Daniel Jeong <daniel.jeong@ti.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Date: Thu, 12 Jan 2012 20:45:02 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MODULE_DEVICE_TABLE to setup modalias for lp8727.
The i2c_device_id table is supposed to be zero-terminated.
Thus add a missing terminate entry for lp8727_ids.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/lp8727_charger.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index b15b575..8e901c9 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -464,7 +464,9 @@ static int __devexit lp8727_remove(struct i2c_client *cl)
 
 static const struct i2c_device_id lp8727_ids[] = {
 	{"lp8727", 0},
+	{ },
 };
+MODULE_DEVICE_TABLE(i2c, lp8727_ids);
 
 static struct i2c_driver lp8727_driver = {
 	.driver = {
-- 
1.7.5.4



