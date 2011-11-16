Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1KPJOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 04:14:41 -0500
Received: from mail-va3.bigfish.com ([216.32.180.10]:52111 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753689Ab1KPJNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 04:13:08 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <spi-devel-general@lists.sourceforge.net>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/5] I2C: Add helper macro for i2c_driver boilerplate
Date: Wed, 16 Nov 2011 10:13:36 +0100
Message-ID: <1321434819-23678-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321434819-23678-1-git-send-email-lars@metafoo.de>
References: <1321434819-23678-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the module_i2c_driver macro which is a convenience macro
for I2C driver modules similar to module_platform_driver. It is intended to be
used by drivers which init/exit section does nothing but register/unregister
the I2C driver. By using this macro it is possible to eliminate a few lines of
boilerplate code per I2C driver.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 include/linux/i2c.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index a81bf6d..7e92854 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -485,6 +485,19 @@ static inline int i2c_adapter_id(struct i2c_adapter *adap)
 {
 	return adap->nr;
 }
+
+/**
+ * module_i2c_driver() - Helper macro for registering a I2C driver
+ * @__i2c_driver: i2c_driver struct
+ *
+ * Helper macro for I2C drivers which do not do anything special in module
+ * init/exit. This eliminates a lot of boilerplate. Each module may only
+ * use this macro once, and calling it replaces module_init() and module_exit()
+ */
+#define module_i2c_driver(__i2c_driver) \
+	module_driver(__i2c_driver, i2c_add_driver, \
+			i2c_del_driver)
+
 #endif /* I2C */
 #endif /* __KERNEL__ */
 
-- 
1.7.7.1


