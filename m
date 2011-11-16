Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab1KPL0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:26:40 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:41753 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756156Ab1KPL0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:26:38 -0500
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
Subject: [PATCH 2/5] mfd/stmpe: Move struct stmpe_variant_info to linux/mfd/stmpe.h
Date: Wed, 16 Nov 2011 16:56:07 +0530
Message-ID: <2387af0d60d15dda03153a8802905196eeb6ad8f.1321442150.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1321442150.git.viresh.kumar@st.com>
References: <cover.1321442150.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pratyush Anand <pratyush.anand@st.com>

Some variants like GPIO of STMPE801 have different register definition. So,
variant ID will be needed by stmpe-gpio.c to distinguish between STMPE801. Move
this struct definition from drivers/mfd/stmpe.h to include/linux/stmpe.h

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
---
 drivers/mfd/stmpe.h       |   32 --------------------------------
 include/linux/mfd/stmpe.h |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/drivers/mfd/stmpe.h b/drivers/mfd/stmpe.h
index a73f4c1..7df0bda 100644
--- a/drivers/mfd/stmpe.h
+++ b/drivers/mfd/stmpe.h
@@ -44,38 +44,6 @@ struct stmpe_variant_block {
 };
 
 /**
- * struct stmpe_variant_info - variant-specific information
- * @name:	part name
- * @id_val:	content of CHIPID register
- * @id_mask:	bits valid in CHIPID register for comparison with id_val
- * @num_gpios:	number of GPIOS
- * @af_bits:	number of bits used to specify the alternate function
- * @regs: variant specific registers.
- * @blocks:	list of blocks present on this device
- * @num_blocks:	number of blocks present on this device
- * @num_irqs:	number of internal IRQs available on this device
- * @enable:	callback to enable the specified blocks.
- *		Called with the I/O lock held.
- * @get_altfunc: callback to get the alternate function number for the
- *		 specific block
- * @enable_autosleep: callback to configure autosleep with specified timeout
- */
-struct stmpe_variant_info {
-	const char *name;
-	u16 id_val;
-	u16 id_mask;
-	int num_gpios;
-	int af_bits;
-	const u8 *regs;
-	struct stmpe_variant_block *blocks;
-	int num_blocks;
-	int num_irqs;
-	int (*enable)(struct stmpe *stmpe, unsigned int blocks, bool enable);
-	int (*get_altfunc)(struct stmpe *stmpe, enum stmpe_block block);
-	int (*enable_autosleep)(struct stmpe *stmpe, int autosleep_timeout);
-};
-
-/**
  * struct stmpe_client_info - i2c or spi specific routines/info
  * @data: client specific data
  * @read_byte: read single byte
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index 5afaf89..102c06d 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -51,6 +51,7 @@ enum {
 
 struct stmpe_variant_info;
 struct stmpe_client_info;
+struct stmpe_variant_block;
 
 /**
  * struct stmpe - STMPE MFD structure
@@ -86,6 +87,38 @@ struct stmpe {
 	struct stmpe_platform_data *pdata;
 };
 
+/**
+ * struct stmpe_variant_info - variant-specific information
+ * @name:	part name
+ * @id_val:	content of CHIPID register
+ * @id_mask:	bits valid in CHIPID register for comparison with id_val
+ * @num_gpios:	number of GPIOS
+ * @af_bits:	number of bits used to specify the alternate function
+ * @regs: variant specific registers.
+ * @blocks:	list of blocks present on this device
+ * @num_blocks:	number of blocks present on this device
+ * @num_irqs:	number of internal IRQs available on this device
+ * @enable:	callback to enable the specified blocks.
+ *		Called with the I/O lock held.
+ * @get_altfunc: callback to get the alternate function number for the
+ *		 specific block
+ * @enable_autosleep: callback to configure autosleep with specified timeout
+ */
+struct stmpe_variant_info {
+	const char *name;
+	u16 id_val;
+	u16 id_mask;
+	int num_gpios;
+	int af_bits;
+	const u8 *regs;
+	struct stmpe_variant_block *blocks;
+	int num_blocks;
+	int num_irqs;
+	int (*enable)(struct stmpe *stmpe, unsigned int blocks, bool enable);
+	int (*get_altfunc)(struct stmpe *stmpe, enum stmpe_block block);
+	int (*enable_autosleep)(struct stmpe *stmpe, int autosleep_timeout);
+};
+
 extern int stmpe_reg_write(struct stmpe *stmpe, u8 reg, u8 data);
 extern int stmpe_reg_read(struct stmpe *stmpe, u8 reg);
 extern int stmpe_block_read(struct stmpe *stmpe, u8 reg, u8 length,
-- 
1.7.2.2

