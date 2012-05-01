Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab2EAUpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 16:45:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792Ab2EAUpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 16:45:53 -0400
From: NeilBrown <neilb@suse.de>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 02 May 2012 06:44:50 +1000
Subject: [PATCH 1/2] twl-regulator: define all feature flags in one place.
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>
Message-ID: <20120501204449.27026.29720.stgit@notabene.brown>
In-Reply-To: <20120501204259.27026.40156.stgit@notabene.brown>
References: <20120501204259.27026.40156.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

twl-regulator has a collection of feature flags, some defined
in twl-core.c and  one defined in i2c/twl.h.
This is confusing for anyone adding a new feature flag.

So collect them together and place them in twl.h immediately
after the structure in which they are initially set.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/mfd/twl-core.c  |    7 -------
 include/linux/i2c/twl.h |    8 ++++++--
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 4cbf285..269b296 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -224,13 +224,6 @@
 #define HIGH_PERF_SQ			(1 << 3)
 #define CK32K_LOWPWR_EN			(1 << 7)
 
-
-/* chip-specific feature flags, for i2c_device_id.driver_data */
-#define TWL4030_VAUX2		BIT(0)	/* pre-5030 voltage ranges */
-#define TPS_SUBSET		BIT(1)	/* tps659[23]0 have fewer LDOs */
-#define TWL5031			BIT(2)  /* twl5031 has different registers */
-#define TWL6030_CLASS		BIT(3)	/* TWL6030 class */
-
 /*----------------------------------------------------------------------*/
 
 /* is driver active, bound to a chip? */
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index b526031..88e8cd8 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -171,8 +171,6 @@ static inline int twl_class_is_ ##class(void)	\
 TWL_CLASS_IS(4030, TWL4030_CLASS_ID)
 TWL_CLASS_IS(6030, TWL6030_CLASS_ID)
 
-#define TWL6025_SUBCLASS	BIT(4)  /* TWL6025 has changed registers */
-
 /*
  * Read and write single 8-bit registers
  */
@@ -748,6 +746,12 @@ struct twl_regulator_driver_data {
 	void		*data;
 	unsigned long	features;
 };
+/* chip-specific feature flags, for twl_regulator_driver_data.features */
+#define TWL4030_VAUX2		BIT(0)	/* pre-5030 voltage ranges */
+#define TPS_SUBSET		BIT(1)	/* tps659[23]0 have fewer LDOs */
+#define TWL5031			BIT(2)  /* twl5031 has different registers */
+#define TWL6030_CLASS		BIT(3)	/* TWL6030 class */
+#define TWL6025_SUBCLASS	BIT(4)  /* TWL6025 has changed registers */
 
 /*----------------------------------------------------------------------*/
 


