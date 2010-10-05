Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab0JECFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 22:05:04 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49914 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab0JECFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 22:05:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=qkUxtVB7xvHNMaECdnhSaBgBNAxfZBEjoJKu1p6tlTnhpc3zGzlRzqI8xu1D5Q5g1G
         sv8fiYEXwWQrBCgSuMe3LShbkWiXjoeydc0+zgLYnbPBMvmeZ2CN/+nqeijVyh0ZubEZ
         pcJHK21R2CLQKey63cXxjpMqbb7g0UuAC4bPs=
Subject: [PATCH] drivers/power: add missing kfree(di->bus) in
	bq27x00_battery_remove()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>
Content-Type: text/plain
Date: Tue, 05 Oct 2010 10:05:34 +0800
Message-Id: <1286244334.16819.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/bq27x00_battery.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 3ec9c6a..eff0273 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -418,6 +418,7 @@ static int bq27x00_battery_remove(struct i2c_client *client)
 
 	power_supply_unregister(&di->bat);
 
+	kfree(di->bus);
 	kfree(di->bat.name);
 
 	mutex_lock(&battery_mutex);
-- 
1.7.2



