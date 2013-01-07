Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab3AGC2s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 21:28:48 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:58110 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab3AGC2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 21:28:46 -0500
Message-ID: <1357525711.16331.1.camel@phoenix>
Subject: [PATCH] regulator: lp8755: Remove enum bucks
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Daniel Jeong <gshark.jeong@gmail.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 07 Jan 2013 10:28:31 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have enum lp8755_bucks in lp8755.h, so it looks pointless adding
enum bucks in lp8755.c.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/lp8755.c |   50 +++++++++++++++-----------------------------
 1 file changed, 17 insertions(+), 33 deletions(-)

diff --git a/drivers/regulator/lp8755.c b/drivers/regulator/lp8755.c
index dbc4d12..29a1f81 100644
--- a/drivers/regulator/lp8755.c
+++ b/drivers/regulator/lp8755.c
@@ -37,15 +37,6 @@
 #define LP8755_BUCK_LINEAR_OUT_MAX	0x76
 #define LP8755_BUCK_VOUT_M	0x7F
 
-enum bucks {
-	BUCK0 = 0,
-	BUCK1,
-	BUCK2,
-	BUCK3,
-	BUCK4,
-	BUCK5,
-};
-
 struct lp8755_mphase {
 	int nreg;
 	int buck_num[LP8755_BUCK_MAX];
@@ -262,33 +253,26 @@ static struct regulator_ops lp8755_buck_ops = {
 }
 
 static struct regulator_init_data lp8755_reg_default[LP8755_BUCK_MAX] = {
-	[BUCK0] = lp8755_buck_init(0),
-	[BUCK1] = lp8755_buck_init(1),
-	[BUCK2] = lp8755_buck_init(2),
-	[BUCK3] = lp8755_buck_init(3),
-	[BUCK4] = lp8755_buck_init(4),
-	[BUCK5] = lp8755_buck_init(5),
+	[LP8755_BUCK0] = lp8755_buck_init(0),
+	[LP8755_BUCK1] = lp8755_buck_init(1),
+	[LP8755_BUCK2] = lp8755_buck_init(2),
+	[LP8755_BUCK3] = lp8755_buck_init(3),
+	[LP8755_BUCK4] = lp8755_buck_init(4),
+	[LP8755_BUCK5] = lp8755_buck_init(5),
 };
 
 static const struct lp8755_mphase mphase_buck[MPHASE_CONF_MAX] = {
-	{3, {BUCK0, BUCK3, BUCK5}
-	 },
-	{6, {BUCK0, BUCK1, BUCK2, BUCK3, BUCK4, BUCK5}
-	 },
-	{5, {BUCK0, BUCK2, BUCK3, BUCK4, BUCK5}
-	 },
-	{4, {BUCK0, BUCK3, BUCK4, BUCK5}
-	 },
-	{3, {BUCK0, BUCK4, BUCK5}
-	 },
-	{2, {BUCK0, BUCK5}
-	 },
-	{1, {BUCK0}
-	 },
-	{2, {BUCK0, BUCK3}
-	 },
-	{4, {BUCK0, BUCK2, BUCK3, BUCK5}
-	 },
+	{ 3, { LP8755_BUCK0, LP8755_BUCK3, LP8755_BUCK5 } },
+	{ 6, { LP8755_BUCK0, LP8755_BUCK1, LP8755_BUCK2, LP8755_BUCK3,
+	       LP8755_BUCK4, LP8755_BUCK5 } },
+	{ 5, { LP8755_BUCK0, LP8755_BUCK2, LP8755_BUCK3, LP8755_BUCK4,
+	       LP8755_BUCK5} },
+	{ 4, { LP8755_BUCK0, LP8755_BUCK3, LP8755_BUCK4, LP8755_BUCK5} },
+	{ 3, { LP8755_BUCK0, LP8755_BUCK4, LP8755_BUCK5} },
+	{ 2, { LP8755_BUCK0, LP8755_BUCK5} },
+	{ 1, { LP8755_BUCK0} },
+	{ 2, { LP8755_BUCK0, LP8755_BUCK3} },
+	{ 4, { LP8755_BUCK0, LP8755_BUCK2, LP8755_BUCK3, LP8755_BUCK5} },
 };
 
 static int lp8755_init_data(struct lp8755_chip *pchip)
-- 
1.7.9.5



