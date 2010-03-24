Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab0CXJJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 05:09:06 -0400
Received: from vps.mortis.eu ([79.99.135.181]:53807 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab0CXJJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 05:09:05 -0400
From: Giel van Schijndel <me@mortis.eu>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>, Giel van Schijndel <me@mortis.eu>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: f71882fg: code cleanup
Date: Wed, 24 Mar 2010 10:09:01 +0100
Message-Id: <1269421741-9706-1-git-send-email-me@mortis.eu>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <20100324084643.GB6368@salidar.me.mortis.eu>
References: <20100324084643.GB6368@salidar.me.mortis.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some code cleanup: properly using previously defined functions, rather
than duplicating their code.

Signed-off-by: Giel van Schijndel <me@mortis.eu>
---
 drivers/hwmon/f71882fg.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index 4230729..ca34e5c 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -856,10 +856,8 @@ static inline int superio_inb(int base, int reg)
 static int superio_inw(int base, int reg)
 {
 	int val;
-	outb(reg++, base);
-	val = inb(base + 1) << 8;
-	outb(reg, base);
-	val |= inb(base + 1);
+	val  = superio_inb(base, reg) << 8;
+	val |= superio_inb(base, reg + 1);
 	return val;
 }
 
@@ -905,10 +903,8 @@ static u16 f71882fg_read16(struct f71882fg_data *data, u8 reg)
 {
 	u16 val;
 
-	outb(reg++, data->addr + ADDR_REG_OFFSET);
-	val = inb(data->addr + DATA_REG_OFFSET) << 8;
-	outb(reg, data->addr + ADDR_REG_OFFSET);
-	val |= inb(data->addr + DATA_REG_OFFSET);
+	val  = f71882fg_read8(data, reg) << 8;
+	val |= f71882fg_read8(data, reg + 1);
 
 	return val;
 }
@@ -921,10 +917,8 @@ static void f71882fg_write8(struct f71882fg_data *data, u8 reg, u8 val)
 
 static void f71882fg_write16(struct f71882fg_data *data, u8 reg, u16 val)
 {
-	outb(reg++, data->addr + ADDR_REG_OFFSET);
-	outb(val >> 8, data->addr + DATA_REG_OFFSET);
-	outb(reg, data->addr + ADDR_REG_OFFSET);
-	outb(val & 255, data->addr + DATA_REG_OFFSET);
+	f71882fg_write8(data, reg,     val >> 8);
+	f71882fg_write8(data, reg + 1, val & 0xff);
 }
 
 static u16 f71882fg_read_temp(struct f71882fg_data *data, int nr)
-- 
1.6.4.4

