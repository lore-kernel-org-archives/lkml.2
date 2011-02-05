Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1BEOWc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:22:32 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57576 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab1BEOW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:22:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cq9av4tNZZvDD3hwvxYBZtT7H1Vp+Nm2YNtlM+cO52Qi7vHOF7KbH6XvM9pocUu8Jo
         U0UjG2ChGlpgqIdaioR6HLLom6Axj1iWyqsvfWrqJGzX6iaSh1FOBa7DIgx4g+fxvrHt
         ILguLuE9Hv8TIq/xlbnCrbeB86/86qjOIWpnU=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 34/52] kstrtox: convert drivers/power/
Date: Sat,  5 Feb 2011 16:20:37 +0200
Message-Id: <1296915654-7458-34-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
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
1.7.3.4

