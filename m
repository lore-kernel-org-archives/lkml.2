Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab2KIKA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 05:00:56 -0500
Received: from m15-60.126.com ([220.181.15.60]:35781 "EHLO m15-60.126.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab2KIKAy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 05:00:54 -0500
X-Greylist: delayed 1853 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Nov 2012 05:00:52 EST
X-Originating-IP: [121.14.98.46]
Date: Fri, 9 Nov 2012 17:29:40 +0800 (CST)
From: helight <helight@126.com>
To: linux-kernel@vger.kernel.org
Cc: lrg@ti.com, broonie@opensource.wolfsonmicro.com
Subject: =?GBK?Q?[PATCH]_fix_build_waring:_drive?=
 =?GBK?Q?rs/regulator/core.c:_warning:_=A1=AEv?=
 =?GBK?Q?al=A1=AF_may_be_used_uninitialized_in?=
 =?GBK?Q?_this_function_[-Wuninitialized]?=
X-Priority: 3
X-Mailer: Coremail Webmail Server Version SP_ntes V3.5 build
 20121016(20100.4985.4909) Copyright (c) 2002-2012 www.mailtech.cn 126com
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <73729ce5.abaa.13ae480da6d.Coremail.helight@126.com>
X-CM-TRANSID: PMqowECJCEUEzZxQZfwOAA--.469W
X-CM-SenderInfo: 5khoxwlkw6ij2wof0z/1tbiExpiCE0vMhb8cAABso
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix build waring on drivers/regulator/core.c
drivers/regulator/core.c: In function ¡®regulator_get_bypass_regmap¡¯:
drivers/regulator/core.c:2748:16: warning: ¡®val¡¯ may be used uninitialized in this function [-Wuninitialized]
drivers/regulator/core.c: In function ¡®regulator_get_voltage_sel_regmap¡¯:
drivers/regulator/core.c:2016:6: warning: ¡®val¡¯ may be used uninitialized in this function [-Wuninitialized]
drivers/regulator/core.c: In function ¡®regulator_is_enabled_regmap¡¯:
drivers/regulator/core.c:1786:14: warning: ¡®val¡¯ may be used uninitialized in this function [-Wuninitialized]


>From c5b564ba10101961ffca9a67c6ddcc6216b99dce Mon Sep 17 00:00:00 2001
From: helight xu <helight.xu@gmail.com>
Date: Sat, 10 Nov 2012 01:11:14 +0800
Subject: [PATCH] fix build waring: drivers/regulator/core.c: warning: ¡®val¡¯ may be used uninitialized in this function [-Wuninitialized]


Signed-off-by: helight xu <helight.xu@gmail.com>
---
 drivers/regulator/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 5c4829c..7ad7174 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1776,8 +1776,8 @@ EXPORT_SYMBOL_GPL(regulator_disable_deferred);
  */
 int regulator_is_enabled_regmap(struct regulator_dev *rdev)
 {
-   unsigned int val;
    int ret;
+   unsigned int val = 0;

    ret = regmap_read(rdev->regmap, rdev->desc->enable_reg, &val);
    if (ret != 0)
@@ -2006,8 +2006,8 @@ EXPORT_SYMBOL_GPL(regulator_is_supported_voltage);
  */
 int regulator_get_voltage_sel_regmap(struct regulator_dev *rdev)
 {
-   unsigned int val;
    int ret;
+   unsigned int val = 0;

    ret = regmap_read(rdev->regmap, rdev->desc->vsel_reg, &val);
    if (ret != 0)
@@ -2738,8 +2738,8 @@ EXPORT_SYMBOL_GPL(regulator_set_bypass_regmap);
  */
 int regulator_get_bypass_regmap(struct regulator_dev *rdev, bool *enable)
 {
-   unsigned int val;
    int ret;
+   unsigned int val = 0;

    ret = regmap_read(rdev->regmap, rdev->desc->bypass_reg, &val);
    if (ret != 0)
-- 
1.7.10.4
