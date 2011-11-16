Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab1KPL0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:26:42 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:38003 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756087Ab1KPL0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:26:40 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <rabin.vincent@stericsson.com>, <linus.walleij@stericsson.com>,
        <srinidhi.kasagar@stericsson.com>
Cc: <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <armando.visconti@st.com>, <shiraz.hashim@st.com>,
        <vipin.kumar@st.com>, <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>,
        <grant.likely@secretlab.ca>
Subject: [PATCH 3/5] mfd/stmpe: Add support for stmpe variant 610
Date: Wed, 16 Nov 2011 16:56:08 +0530
Message-ID: <ac67418530980e5ac3c25e8665d5ba3c5ef37c8e.1321442150.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1321442150.git.viresh.kumar@st.com>
References: <cover.1321442150.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

STMPE610 is very much like STMPE811, except the number of gpio pins, which is 8
in 811 and 6 in 610. This patch adds support for variant 610. STMPE610 will
share most of the code with STMPE811.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/mfd/stmpe-i2c.c   |    1 +
 drivers/mfd/stmpe-spi.c   |    1 +
 drivers/mfd/stmpe.c       |   20 ++++++++++++++++++--
 include/linux/mfd/stmpe.h |    1 +
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index 671fd5c..c004319 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -71,6 +71,7 @@ static int __devexit stmpe_i2c_remove(struct i2c_client *i2c)
 }
 
 static const struct i2c_device_id stmpe_i2c_id[] = {
+	{ "stmpe610", STMPE610 },
 	{ "stmpe811", STMPE811 },
 	{ "stmpe1601", STMPE1601 },
 	{ "stmpe2401", STMPE2401 },
diff --git a/drivers/mfd/stmpe-spi.c b/drivers/mfd/stmpe-spi.c
index 21861d8..25928f6 100644
--- a/drivers/mfd/stmpe-spi.c
+++ b/drivers/mfd/stmpe-spi.c
@@ -109,6 +109,7 @@ static int __devexit stmpe_spi_remove(struct spi_device *spi)
 }
 
 static const struct spi_device_id stmpe_spi_id[] = {
+	{ "stmpe610", STMPE610 },
 	{ "stmpe811", STMPE811 },
 	{ "stmpe1601", STMPE1601 },
 	{ "stmpe2401", STMPE2401 },
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index a564f91..34046b5 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -321,7 +321,7 @@ static struct mfd_cell stmpe_keypad_cell = {
 };
 
 /*
- * Touchscreen (STMPE811)
+ * Touchscreen (STMPE811 or STMPE610)
  */
 
 static struct resource stmpe_ts_resources[] = {
@@ -346,7 +346,7 @@ static struct mfd_cell stmpe_ts_cell = {
 };
 
 /*
- * STMPE811
+ * STMPE811 or STMPE610
  */
 
 static const u8 stmpe811_regs[] = {
@@ -417,6 +417,21 @@ static struct stmpe_variant_info stmpe811 = {
 	.get_altfunc	= stmpe811_get_altfunc,
 };
 
+/* Similar to 811, except number of gpios */
+static struct stmpe_variant_info stmpe610 = {
+	.name		= "stmpe610",
+	.id_val		= 0x0811,
+	.id_mask	= 0xffff,
+	.num_gpios	= 6,
+	.af_bits	= 1,
+	.regs		= stmpe811_regs,
+	.blocks		= stmpe811_blocks,
+	.num_blocks	= ARRAY_SIZE(stmpe811_blocks),
+	.num_irqs	= STMPE811_NR_INTERNAL_IRQS,
+	.enable		= stmpe811_enable,
+	.get_altfunc	= stmpe811_get_altfunc,
+};
+
 /*
  * STMPE1601
  */
@@ -651,6 +666,7 @@ static struct stmpe_variant_info stmpe2403 = {
 };
 
 static struct stmpe_variant_info *stmpe_variant_info[] = {
+	[STMPE610]	= &stmpe610,
 	[STMPE811]	= &stmpe811,
 	[STMPE1601]	= &stmpe1601,
 	[STMPE2401]	= &stmpe2401,
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index 102c06d..79e4fc4 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -20,6 +20,7 @@ enum stmpe_block {
 };
 
 enum stmpe_partnum {
+	STMPE610,
 	STMPE811,
 	STMPE1601,
 	STMPE2401,
-- 
1.7.2.2

