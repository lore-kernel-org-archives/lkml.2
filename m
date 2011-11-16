Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab1KPJNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 04:13:15 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:51251
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754355Ab1KPJNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 04:13:10 -0500
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
Subject: [PATCH 3/5] SPI: Add helper macro for spi_driver boilerplate
Date: Wed, 16 Nov 2011 10:13:37 +0100
Message-ID: <1321434819-23678-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321434819-23678-1-git-send-email-lars@metafoo.de>
References: <1321434819-23678-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the module_spi_driver macro which is a convenience macro
for SPI driver modules similar to module_platform_driver. It is intended to be
used by drivers which init/exit section does nothing but register/unregister
the SPI driver. By using this macro it is possible to eliminate a few lines of
boilerplate code per SPI driver.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 include/linux/spi/spi.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index bb4f5fb..176fce9 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -200,6 +200,17 @@ static inline void spi_unregister_driver(struct spi_driver *sdrv)
 		driver_unregister(&sdrv->driver);
 }
 
+/**
+ * module_spi_driver() - Helper macro for registering a SPI driver
+ * @__spi_driver: spi_driver struct
+ *
+ * Helper macro for SPI drivers which do not do anything special in module
+ * init/exit. This eliminates a lot of boilerplate. Each module may only
+ * use this macro once, and calling it replaces module_init() and module_exit()
+ */
+#define module_spi_driver(__spi_driver) \
+	module_driver(__spi_driver, spi_register_driver, \
+			spi_unregister_driver)
 
 /**
  * struct spi_master - interface to SPI master controller
-- 
1.7.7.1


