Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab1DRMRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 08:17:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55033 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1DRMRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 08:17:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=gQkaUaP9zODnhwpWnjJ/4234chdYDGR6fdmhuEpY1BSPOMTzFVetVZuZsBQfP4u6rv
         jopVxDi1CF2ToUwrElpDZn504pSpLZH/6ZCZ9JOMPhX6P5nQgGli6YwBdTjyK1H7t/Yu
         DXE0ZZe5H1nDLirWHtlfYRdfwlhQnTsBNBWB8=
Subject: [PATCH] RTC: Add MODULE_DEVICE_TABLE to
 rtc-ds1672/rtc-max6900/rtc-max8998
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Dale Farnsworth <dale@farnsworth.org>,
        Minkyu Kang <mk7.kang@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Apr 2011 20:16:57 +0800
Message-ID: <1303129017.8158.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device table is required to load modules based on modaliases.
After adding MODULE_DEVICE_TABLE, below entries will be added to modules.alias:

alias i2c:ds1672 rtc_ds1672
alias i2c:max6900 rtc_max6900
alias platform:lp3974-rtc rtc_max8998
alias platform:max8998-rtc rtc_max8998

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Dale Farnsworth <dale@farnsworth.org>
Cc: Minkyu Kang <mk7.kang@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/rtc/rtc-ds1672.c  |    1 +
 drivers/rtc/rtc-max6900.c |    1 +
 drivers/rtc/rtc-max8998.c |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-ds1672.c b/drivers/rtc/rtc-ds1672.c
index 06dfb54..fa301d4 100644
--- a/drivers/rtc/rtc-ds1672.c
+++ b/drivers/rtc/rtc-ds1672.c
@@ -191,6 +191,7 @@ static struct i2c_device_id ds1672_id[] = {
 	{ "ds1672", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, ds1672_id);
 
 static struct i2c_driver ds1672_driver = {
 	.driver = {
diff --git a/drivers/rtc/rtc-max6900.c b/drivers/rtc/rtc-max6900.c
index 486142c..ef834c1 100644
--- a/drivers/rtc/rtc-max6900.c
+++ b/drivers/rtc/rtc-max6900.c
@@ -251,6 +251,7 @@ static struct i2c_device_id max6900_id[] = {
 	{ "max6900", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, max6900_id);
 
 static struct i2c_driver max6900_driver = {
 	.driver = {
diff --git a/drivers/rtc/rtc-max8998.c b/drivers/rtc/rtc-max8998.c
index 3f7bc6b..dade62e 100644
--- a/drivers/rtc/rtc-max8998.c
+++ b/drivers/rtc/rtc-max8998.c
@@ -315,6 +315,7 @@ static const struct platform_device_id max8998_rtc_id[] = {
 	{ "lp3974-rtc", TYPE_LP3974 },
 	{ }
 };
+MODULE_DEVICE_TABLE(platform, max8998_rtc_id);
 
 static struct platform_driver max8998_rtc_driver = {
 	.driver		= {
-- 
1.7.1



