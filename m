Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab0LERxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:53:48 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64682 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab0LERvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:51:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vMc7FT3Fe4BUWR3HbrO5vQkWyaVPfb+e4wTuSPdcEDDI9YT0M0UCxeoRvrbX0Q+moZ
         cNiQwE0TtM62yDg5EggxxWktOOPml9dR8gAXp5LspIy0TK7ATMSt6SBqLOi7x2+uDFet
         10851xpqWU9hzFBbbt2HiScMTIZ6mYrYIjbgQ=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 36/45] kstrtox: convert drivers/power/
Date: Sun,  5 Dec 2010 19:49:33 +0200
Message-Id: <1291571382-2719-36-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/power/pcf50633-charger.c   |    4 ++--
 drivers/power/power_supply_sysfs.c |    6 +-----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
index 4fa52e1..b6d9281 100644
--- a/drivers/power/pcf50633-charger.c
+++ b/drivers/power/pcf50633-charger.c
@@ -191,7 +191,7 @@ static ssize_t set_usblim(struct device *dev,
 	unsigned long ma;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &ma);
+	ret = kstrtoul(buf, 10, &ma);
 	if (ret)
 		return -EINVAL;
 
@@ -228,7 +228,7 @@ static ssize_t set_chglim(struct device *dev,
 	if (!mbc->pcf->pdata->charger_reference_current_ma)
 		return -ENODEV;
 
-	ret = strict_strtoul(buf, 10, &ma);
+	ret = kstrtoul(buf, 10, &ma);
 	if (ret)
 		return -EINVAL;
 
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index cd1f907..15d2d4a 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -107,15 +107,11 @@ static ssize_t power_supply_store_property(struct device *dev,
 	struct power_supply *psy = dev_get_drvdata(dev);
 	const ptrdiff_t off = attr - power_supply_attrs;
 	union power_supply_propval value;
-	long long_val;
 
 	/* TODO: support other types than int */
-	ret = strict_strtol(buf, 10, &long_val);
+	ret = kstrtoint(buf, 10, &value.intval);
 	if (ret < 0)
 		return ret;
-
-	value.intval = long_val;
-
 	ret = psy->set_property(psy, off, &value);
 	if (ret < 0)
 		return ret;
-- 
1.7.2.2

