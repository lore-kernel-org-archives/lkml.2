Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659Ab2CNBFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 21:05:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43959 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760647Ab2CNBF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 21:05:28 -0400
Date: Wed, 14 Mar 2012 05:05:25 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Arun Murthy <arun.murthy@stericsson.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        karl.komierowski@stericsson.com, johan.palsson@stericsson.com,
        linus.walleij@linaro.org
Subject: [PATCH 6/6] ab8500: Turn unneeded global symbols into local ones
Message-ID: <20120314010525.GF10798@oksana.dev.rtsoft.ru>
References: <20120314005901.GB1778@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120314005901.GB1778@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixes the following sparse warning:

drivers/power/ab8500_charger.c:1619:6: warning: symbol 'ab8500_charger_detect_usb_type_work' was not declared. Should it be static?
drivers/power/abx500_chargalg.c:1709:24: warning: symbol 'abx500_chargalg_sysfs_ops' was not declared. Should it be static?
drivers/power/ab8500_fg.c:2328:24: warning: symbol 'ab8500_fg_sysfs_ops' was not declared. Should it be static?

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/power/ab8500_charger.c  |    2 +-
 drivers/power/ab8500_fg.c       |    2 +-
 drivers/power/abx500_chargalg.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index a7217d6..e2b4acc 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -1616,7 +1616,7 @@ static void ab8500_charger_ac_work(struct work_struct *work)
  *
  * Detect the type of USB plugged
  */
-void ab8500_charger_detect_usb_type_work(struct work_struct *work)
+static void ab8500_charger_detect_usb_type_work(struct work_struct *work)
 {
 	int ret;
 
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 0441f9d..eaf149e 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2325,7 +2325,7 @@ ab8500_fg_store(struct kobject *kobj, struct attribute *attr, const char *buf,
 	return entry->store(di, buf, count);
 }
 
-const struct sysfs_ops ab8500_fg_sysfs_ops = {
+static const struct sysfs_ops ab8500_fg_sysfs_ops = {
 	.show = ab8500_fg_show,
 	.store = ab8500_fg_store,
 };
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index fbb6a1f..804b88c 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -1706,7 +1706,7 @@ static struct attribute *abx500_chargalg_chg[] = {
 	NULL
 };
 
-const struct sysfs_ops abx500_chargalg_sysfs_ops = {
+static const struct sysfs_ops abx500_chargalg_sysfs_ops = {
 	.store = abx500_chargalg_sysfs_charger,
 };
 
-- 
1.7.9
