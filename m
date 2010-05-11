Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab0EKRET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:04:19 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:53989 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330Ab0EKREQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:04:16 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Anton Vorontsov <cbouatmailru@gmail.com>
Subject: [PATCH] w1: DS2760: move EXPORT_SYMBOL() to function declarations
Date: Tue, 11 May 2010 19:03:53 +0200
Message-Id: <1273597433-29241-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/w1/slaves/w1_ds2760.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/w1/slaves/w1_ds2760.c b/drivers/w1/slaves/w1_ds2760.c
index 6e15334..23c009f 100644
--- a/drivers/w1/slaves/w1_ds2760.c
+++ b/drivers/w1/slaves/w1_ds2760.c
@@ -63,11 +63,13 @@ int w1_ds2760_read(struct device *dev, char *buf, int addr, size_t count)
 {
 	return w1_ds2760_io(dev, buf, addr, count, 0);
 }
+EXPORT_SYMBOL(w1_ds2760_read);
 
 int w1_ds2760_write(struct device *dev, char *buf, int addr, size_t count)
 {
 	return w1_ds2760_io(dev, buf, addr, count, 1);
 }
+EXPORT_SYMBOL(w1_ds2760_write);
 
 static int w1_ds2760_eeprom_cmd(struct device *dev, int addr, int cmd)
 {
@@ -91,11 +93,13 @@ int w1_ds2760_store_eeprom(struct device *dev, int addr)
 {
 	return w1_ds2760_eeprom_cmd(dev, addr, W1_DS2760_COPY_DATA);
 }
+EXPORT_SYMBOL(w1_ds2760_store_eeprom);
 
 int w1_ds2760_recall_eeprom(struct device *dev, int addr)
 {
 	return w1_ds2760_eeprom_cmd(dev, addr, W1_DS2760_RECALL_DATA);
 }
+EXPORT_SYMBOL(w1_ds2760_recall_eeprom);
 
 static ssize_t w1_ds2760_read_bin(struct kobject *kobj,
 				  struct bin_attribute *bin_attr,
@@ -227,11 +231,6 @@ static void __exit w1_ds2760_exit(void)
 	idr_destroy(&bat_idr);
 }
 
-EXPORT_SYMBOL(w1_ds2760_read);
-EXPORT_SYMBOL(w1_ds2760_write);
-EXPORT_SYMBOL(w1_ds2760_store_eeprom);
-EXPORT_SYMBOL(w1_ds2760_recall_eeprom);
-
 module_init(w1_ds2760_init);
 module_exit(w1_ds2760_exit);
 
-- 
1.7.1

